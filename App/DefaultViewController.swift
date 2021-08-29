//
//  DefaultViewController.swift
//  
//
//  Copyright © Kobaissy. All rights reserved.
//

import UIKit
import Toast_Swift
import KYDrawerController
//import PopupController

class DefaultViewController: UIViewController {
    
    var menuBtn: UIButton!
    var navHeight:CGFloat = 44
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if(self.navigationController != nil ){
            navHeight = self.navigationController!.navigationBar.frame.height
        } else {
            navHeight = 44.0
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backItem?.title = ""
        
        if let drawerController = tabBarController?.parent as? KYDrawerController {
            drawerController.screenEdgePanGestureEnabled = true
            drawerController.drawerWidth = UIScreen.main.bounds.width * (appDelegate.isIpad ? 0.4 : 0.6)
            drawerController.drawerDirection = .left
        }
        
        menuBtn = UIButton(frame: CGRect(x: -6, y: 4, width: 38, height: 28))
        menuBtn.setImage(UIImage(named: "drawer")?.withRenderingMode(.alwaysTemplate), for: .normal)
        menuBtn.imageView?.contentMode = .scaleAspectFit
        menuBtn.imageView?.tintColor = AppColors.red // UIColor(hex: "1f2437") //AppColors.orange
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 1, left: 5, bottom: 0, right: 5)
        
        if let navgVc = self.navigationController , navgVc.viewControllers.count == 1 {
            self.addDrawerBtn()
        }
        
        addCenterLogo()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let drawerController = tabBarController?.parent as? KYDrawerController {
            drawerController.screenEdgePanGestureEnabled = true
        }
    }
    
    
    func showToastMsg(msgTxt: String){
        var style = ToastStyle()
        style.messageFont = getFont(size: 14)
        style.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.makeToast(msgTxt, duration: 2.0, style: style)
        // self.navigationController?.view.makeToast(msgTxt, duration: 2.0, style: style)
    }
    
    
    func addCenterLogo(){
        let image = UIImage(named: "img_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 24))
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    
    func addDrawerBtn() {
        let viewFN = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: navHeight))
        viewFN.addSubview(menuBtn)
        menuBtn.addTarget(self, action: #selector(openDrawer), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: viewFN)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: navHeight))
        let rightBarButton = UIBarButtonItem(customView: emptyView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func openDrawer() {
        if let drawerController = tabBarController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
