//
//  DrawerViewController.swift
//  Nabeh
//
//  Created by Kobaissy on 10/6/19.
//  Copyright © 2019 IDS Mac. All rights reserved.
//

import UIKit
import MapKit
import KYDrawerController

class DrawerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDropUs: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCallUs: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblGetDirection: UILabel!
    @IBOutlet weak var btnGetDirection: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.topHeight.constant = appDelegate.topNavHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCellID")
        tableView.register(UINib(nibName: "DrawerHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DrawerHeaderTableViewCellID")
        
        let imgs: [UIImageView] = [imgEmail, imgPhone, imgAddress]
        imgs.forEach { (img) in
            img.layer.cornerRadius = 4
        }
        
        let lblTitles: [UILabel] = [lblEmail, lblPhone, lblAddress]
        lblTitles.forEach { (lbl) in
            lbl.font = getFont(size: 13)
            lbl.minimumScaleFactor = 0.4
            lbl.adjustsFontSizeToFitWidth = true
        }
        
        let lblSubTitles: [UILabel] = [lblDropUs, lblCallUs, lblGetDirection]
        lblSubTitles.forEach { (lbl) in
            lbl.font = getFont(size: 14)
            lbl.minimumScaleFactor = 0.4
            lbl.adjustsFontSizeToFitWidth = true
        }
        
        btnEmail.addTarget(self, action: #selector(openEmail), for: .touchUpInside)
        btnPhone.addTarget(self, action: #selector(callPhone), for: .touchUpInside)
        btnGetDirection.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        
        // self.view.backgroundColor = .white
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return appDelegate.allCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DrawerHeaderTableViewCellID") as! DrawerHeaderTableViewCell
        let item = appDelegate.allCategory[section]
        
        headerView.lblName.font = getSemiBoldFont(size: 17)
        headerView.lblName.text = item.name
        
        headerView.btnHeader.tag = section
        headerView.btnHeader.isHidden = (item.chlid == nil || item.chlid!.count == 0)
        headerView.btnHeader.addTarget(self, action: #selector(btnCategoryClick), for: .touchUpInside)
        
        headerView.imgArrow.isHidden = (item.chlid == nil || item.chlid!.count == 0)
        headerView.imgArrow.image = UIImage(named: item.isOpen ? "arrow_up" : "arrow_down")
        headerView.contentView.backgroundColor = .white //UIColor.white.withAlphaComponent(0.6)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appDelegate.allCategory[section].isOpen {
            return appDelegate.allCategory[section].chlid?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCellID", for: indexPath) as? DrawerTableViewCell)!
        
        if let item = appDelegate.allCategory[indexPath.section].chlid?[indexPath.row] {
            cell.lblName.font = getFont(size: 16)
            cell.lblName.text = item.name
        }
        else {
            cell.lblName.text = ""
        }
        
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let drawerController = self.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: false)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func btnCategoryClick(sender: UIButton){
        appDelegate.allCategory[sender.tag].isOpen = !appDelegate.allCategory[sender.tag].isOpen
        self.tableView.reloadData()
    }
    
    
    @objc func openEmail(){
        let email = "Info@Canadasweethome.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func callPhone(){
        guard let number = URL(string: "tel://" + "1-587-777-7111") else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func openMap(){
        let latitude = 51.0374097
        let longitude = -113.9479498
        
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "1803 60 St SE, Calgary, AB T2B 0M5"
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        mapItem.openInMaps(launchOptions: options)
    }
    
}
