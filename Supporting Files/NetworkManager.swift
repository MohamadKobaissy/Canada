//
//  NetworkManager.swift
//  FIXOT
//
//  Created by MBPR on 5/15/18.
//  Copyright © Kobaissy. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com.lb")
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
                self.alert()
                appDelegate.isConnected = false
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                appDelegate.isConnected = false
                self.alert()
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                appDelegate.isConnected = true
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                appDelegate.isConnected = true
            }
        }
        // start listening
        reachabilityManager?.startListening()
    }
    
    func reload(){
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewControllerID")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionCrossDissolve, animations: { () -> Void in
        }) { (finished) -> Void in
        }
    }
    
    func alert(){
        //appDelegate.showNetworkErrorAlert()
        //appDelegate.showAlert(titleTxt: NSLocalizedString("noConnection", comment: ""), msgTxt: "", btnTxt: NSLocalizedString("ok", comment: ""))
    }
    
}
