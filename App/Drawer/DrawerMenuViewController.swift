//
//  DrawerViewController.swift
//  Nabeh
//
//  Created by Kobaissy on 10/6/19.
//  Copyright © 2019 IDS Mac. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnIconClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var menuData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCellID")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCellID", for: indexPath) as? DrawerTableViewCell)!
        
        cell.lblName.font = getSemiBoldFont(size: 16)
        cell.lblName.text = menuData[indexPath.row]
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        cell.viewSprt.isHidden = (indexPath.row == (menuData.count - 1))
        
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let drawerController = self.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: false)
        }
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
        
        print("Drawer didSelectRowAt name:",self.menuData[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
