//
//  NotificationManager.swift
//  AlMadina_Live
//
//  Created by Stas Lee on 11/30/20.
//  Copyright © 2020 MK Mac. All rights reserved.
//

import Alamofire
import UserNotifications
import FirebaseMessaging

extension Foundation.Notification.Name {
    static let PushNotificationTapped = Foundation.Notification.Name("PushNotificationTapped")
    static let DidReceivePushNotification = Foundation.Notification.Name("DidReceivePushNotification")
}

enum PushNotificationType: String {
    case unknown
    case requests
    case confirmation
}

final class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    let center = UNUserNotificationCenter.current()
    
    private override init() {}
    
    func checkNotificationSettingsStatus() {
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                break
            case .notDetermined:
                NotificationManager.shared.requestAuthorization()
            case .provisional:
                break
            default:
                break
            }
        }
    }
    
    func setupDelegate() {
        center.delegate = self
    }
    
    func requestAuthorization() {
        // For iOS 10 display notification (sent via APNS)
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        // 1 Capture a weak reference to self in the completion handler.
        center.requestAuthorization(options: options) { [weak self] granted, _ in
            // 2 Then, make sure you have been granted the proper authorization to register for notifications.
            guard granted else {
                return
            }
            // 3 Finally, you just need to set the UNUserNotificationCenter’s delegate to be the AppDelegate object.
            self?.setupDelegate()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func sendFCMTokenToServer(){
        guard let token = Messaging.messaging().fcmToken, !token.isEmpty  else {
            // Request fcm token from server
            return
        }
        print("FCM Token:",token)
        appDelegate.tokenString = token
    }
}


//MARK: - UNUserNotificationCenter delegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NotificationCenter.default.post(name: .DidReceivePushNotification, object: nil, userInfo: userInfo)
        
        completionHandler( [.alert, .badge, .sound])
    }
    
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard response.actionIdentifier != UNNotificationDismissActionIdentifier else {
            return
        }
        
        let userInfo = response.notification.request.content.userInfo
        
        let state = UIApplication.shared.applicationState
        if(state == .inactive) { //# App is transitioning from background to foreground (user taps notification), do what you need when user taps here!
            handleNotification(show: true, userInfo: userInfo)
        }
        else if(state == .active) { //# App is currently active, can update badges count here
            handleNotification(show: true, userInfo: userInfo)
        }
        else if(state == .background) { //# App is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here */
            handleNotification(show: false, userInfo: userInfo)
        }
        
        NotificationCenter.default.post(name: .PushNotificationTapped, object: nil, userInfo: userInfo)
        
        completionHandler()
    }
    
}


//MARK:- Firebase Messaging
extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        // TODO: If necessary send token to application server.
        print("Firebase registration token: \((fcmToken ?? ""))")
    }
    
}


func handleNotification(show: Bool, userInfo: [AnyHashable: Any]?) {
    //self.showNotification = true
    
    if let userInfo = userInfo {
        var link = (userInfo["pagelink"] as? String ?? "")
        link += (userInfo["url"] as? String ?? "")
        
        print("handleNotification userInfo:",userInfo)
        
        if(UIDevice.current.name.elementsEqual("MK iPhone 7+")){
            let pasteboard = UIPasteboard.general
            pasteboard.string = "HandleNotification userInfo: \(userInfo)"
        }
        
        if let aps = userInfo["aps"] as? [String: AnyObject]{
            link += (aps["pagelink"] as? String ?? "")
            link += (aps["url"] as? String ?? "")
        }
        
        if (show) { // active --- forground
            NotificationCenter.default.post(name: Notification.Name("NotificationReceived"), object: link)
        }
        else {
            appDelegate.openClosingAppLink = link
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
