//
//  LoadingViewController.swift
//  CanadaHome
//
//  Created by Kobaissy on 5/22/21.
//  Copyright © 2021 IDS Mac. All rights reserved.
//

import UIKit
import WebKit

class LoadingViewController: DefaultViewController , WKNavigationDelegate , WKUIDelegate , UIScrollViewDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openLink), name: Notification.Name("NotificationReceived"), object: nil)
        
        let logoName = (Bundle.main.infoDictionary!["logo_image"] as? String) ?? ""
        logoImage.image = UIImage(named: logoName)
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        
        self.webView = WKWebView(frame:CGRect(origin: CGPoint.zero, size: viewContainer.frame.size), configuration: configuration)
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.frame = CGRect(origin: CGPoint.zero, size: viewContainer.frame.size)
        self.webView.tag = 111
        self.webView.isOpaque = true
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = .clear
        self.webView.scrollView.bounces = true
        self.webView.scrollView.delegate = self
        self.webView.scrollView.isScrollEnabled = true
        self.webView.scrollView.bouncesZoom = false
        self.webView.scrollView.alwaysBounceVertical = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.viewContainer.addSubview(webView)
        self.viewContainer.backgroundColor = .white
        self.viewContainer.isHidden = true
        
        // User Agent
        webView.customUserAgent = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
        
        //print("viewContainer.frame.height:",viewContainer.frame.height)
        //print("webView:",webView.frame.height)
        
        //if !NetworkReachabilityManager()!.isReachable {
        //    self.viewContainer.isHidden = false
        //}
        
        let appVersion: Double = Bundle.main.getVersionNumber ?? 0
        let appBundle: Double = Double(Bundle.main.getBundleNumber) ?? 0
        let savedAppVersion: Double = UserDefaults.standard.double(forKey: "lastVersion")
        let savedAppBundle: Double = UserDefaults.standard.double(forKey: "lastBundle")
        
        print("app Version:",appVersion)
        print("app Bundle:",appBundle)
        print("saved AppVersion:",savedAppVersion)
        print("saved AppBundle:",savedAppBundle)
        
        if (UserDefaults.standard.string(forKey: "lastVersion") == nil){
            deleteCache()
        }
        else if ((appVersion > savedAppVersion) || (appBundle > savedAppBundle)) {
            deleteCache()
        }
        else {
            self.loadLink((Bundle.main.infoDictionary!["site_link"] as? String) ?? "")
        }
        
        UserDefaults.standard.set(appVersion, forKey: "lastVersion")
        UserDefaults.standard.set(appBundle, forKey: "lastBundle")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    
    func deleteCache(_ loadNew: Bool = false){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
        
        DispatchQueue.main.async {
            self.loadLink()
        }
    }
    
    
    func loadLink(_ link: String = ""){
        var linkStr = link
        if linkStr.isEmpty { linkStr = (Bundle.main.infoDictionary!["site_link"] as? String) ?? "" }
        print("getData linkStr:",linkStr)
        
        if !appDelegate.openClosingAppLink.isEmpty {
            linkStr = appDelegate.openClosingAppLink
        }
        
        if let link = URL(string: linkStr){
            let request = URLRequest(url: link, cachePolicy: (NetworkReachabilityManager()!.isReachable ? .reloadRevalidatingCacheData : .returnCacheDataElseLoad))
            webView.load(request)
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascriptStyle = """
        var css = '*{-webkit-touch-callout: none; -webkit-user-select: none;}';
        var inputCss = 'input, textarea {-webkit-touch-callout: default; -webkit-user-select: text;}';
        var head = document.head || document.getElementsByTagName('head')[0];
        var style = document.createElement('style');
        style.type = 'text/css';
        style.appendChild(document.createTextNode(css));
        style.appendChild(document.createTextNode(inputCss));
        head.appendChild(style);
        """
        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
        
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let scrollHeight = height as? CGFloat {
                        print("webView contentSize scrollHeight:",scrollHeight)
                        self.viewContainer.isHidden = false
                        self.logoImage.isHidden = true
                        self.loader.stopAnimating()
                        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.webView.frame = CGRect(origin: CGPoint.zero, size: self.viewContainer.frame.size)
                    }
                })
            }
        })
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //print("navigationAction.request.url: ", navigationAction.request.url?.absoluteString)
        
        if navigationAction.navigationType == .linkActivated  {
            // let hostLink = (Bundle.main.infoDictionary!["host_link"] as? String) ?? ""
            let hostLink = ((Bundle.main.infoDictionary!["host_link"] as? String) ?? "")
            
            if let url = navigationAction.request.url,
               //let host = url.host, !host.hasPrefix(hostLink){
               let host = url.host, !hostLink.contains(host){
                
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                print("Redirected url:",url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
                
                //    if let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailsViewControllerID") as? DetailsViewController {
                //        vc.linkStr = navigationAction.request.url
                //        self.navigationController?.pushViewController(vc, animated: true)
                //    }
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    
    @objc func openLink(notification: Notification){
        if notification.object != nil {
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            
            if webView != nil, let link = notification.object! as? String {
                if let url = URL(string: link){
                    let request = URLRequest(url: url, cachePolicy: (NetworkReachabilityManager()!.isReachable ? .reloadRevalidatingCacheData : .returnCacheDataElseLoad))
                    webView.load(request)
                }
            }
        }
    }
    
}
