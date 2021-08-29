//
//  DrawerTableViewCell.swift
//  Nabeh
//
//  Created by Kobaissy on 10/6/19.
//  Copyright © 2019 IDS Mac. All rights reserved.
//

import UIKit

class DrawerHeaderTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var viewSprt: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var btnHeader: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblName.font = getFont(size: 15)
        lblName.textColor = AppColors.red
        
        imgIcon.layer.cornerRadius = appRad
        imgIcon.isHidden = true
        
        imgArrow.tintColor = AppColors.red
        imgArrow.image = imgArrow.image?.withRenderingMode(.alwaysTemplate)
    }
    
}
