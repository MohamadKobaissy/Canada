//
//  HomeViewController.swift
//  IOS_App
//
//  Created by Kobaissy on 8/29/21.
//  Copyright © 2021 IDS Mac. All rights reserved.
//

import UIKit
import KYDrawerController

class HomeViewController: DefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.addDrawerBtn()
        
        
        appDelegate.topNavHeight = (self.navigationController?.navigationBar.frame.height ?? 0.0)
        if #available(iOS 13.0, *) {
            appDelegate.topNavHeight += (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0)
        }
    }
    
}
