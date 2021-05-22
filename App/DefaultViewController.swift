//
//  DefaultViewController.swift
//  
//
//  Copyright © Kobaissy. All rights reserved.
//

import UIKit
import Toast_Swift
//import PopupController

class DefaultViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    
    func showToastMsg(msgTxt: String){
        var style = ToastStyle()
        style.messageFont = getFont(size: 14)
        style.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.makeToast(msgTxt, duration: 2.0, style: style)
        // self.navigationController?.view.makeToast(msgTxt, duration: 2.0, style: style)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
