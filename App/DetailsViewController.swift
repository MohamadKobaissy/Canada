//
//  DetailsViewController.swift
//  CanadaHome
//
//  Created by Kobaissy on 5/22/21.
//  Copyright © 2021 IDS Mac. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: DefaultViewController , WKNavigationDelegate , WKUIDelegate , UIScrollViewDelegate {
    
    @IBOutlet weak var viewContainer: UIView!
    
    var webView = WKWebView()
    
    var linkStr: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.viewContainer.isHidden = false
        
        // User Agent
        webView.customUserAgent = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
        
        
        if let link = self.linkStr { // URL(string: self.linkStr){
            let request = URLRequest(url: link, cachePolicy: (NetworkReachabilityManager()!.isReachable ? .reloadRevalidatingCacheData : .returnCacheDataElseLoad))
            webView.load(request)
        }
    }
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //print("navigationAction.request.url: ", navigationAction.request.url?.absoluteString)
        
        if navigationAction.navigationType == .linkActivated  {
            // let hostLink = (Bundle.main.infoDictionary!["host_link"] as? String) ?? ""
            let hostLink = UserDefaults.standard.string(forKey: "savedLink") ?? ((Bundle.main.infoDictionary!["host_link"] as? String) ?? "")
            
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
                decisionHandler(.cancel)
                
                if let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailsViewControllerID") as? DetailsViewController {
                    vc.linkStr = navigationAction.request.url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
}
