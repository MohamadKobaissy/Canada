//
//  TabBarViewController.swift
//  Nabeh
//
//  Created by Kobaissy on 10/1/19.
//  Copyright © 2019 IDS Mac. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = delegate
        
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.white
        }
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor(hex: "1f2437")
    }
    
    
    @objc func selectIndex(notification: Notification) {
        let index = notification.object! as! Int
        self.selectedIndex = index
    }
    
}
