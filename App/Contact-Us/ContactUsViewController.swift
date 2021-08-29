//
//  ContactUsViewController.swift
//  IOS_App
//
//  Created by Kobaissy on 8/29/21.
//  Copyright © 2021 IDS Mac. All rights reserved.
//

import UIKit

class ContactUsViewController: DefaultViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var viewFormCard: UIView!
    
    @IBOutlet weak var lblWhyChosseUs: UILabel!
    @IBOutlet weak var lblHaveAnyQuestion: UILabel!
    @IBOutlet weak var lblFeelFreeContact: UILabel!
    @IBOutlet weak var lblMostVisas: UILabel!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var viewSubject: UIView!
    @IBOutlet weak var txtSubject: UITextField!
    
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var txtViewMessage: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblWhyChosseUs.font = getBoldFont(size: 14)
        lblHaveAnyQuestion.font = getFont(size: 24)
        lblFeelFreeContact.font = getBoldFont(size: 24)
        lblMostVisas.font = getSemiBoldFont(size: 18)
        
        let views: [UIView] = [viewFormCard, viewName, viewEmail, viewPhone, viewSubject, viewMessage]
        views.forEach { (view) in
            view.layer.cornerRadius = 6
            view.clipsToBounds = false
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 0.2
            view.layer.shadowColor = AppColors.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        viewFormCard.layer.cornerRadius = 8
        
        let txts: [UITextField] = [txtName, txtEmail, txtPhone, txtSubject]
        txts.forEach { (txt) in
            txt.font = getFont(size: 16)
            txt.delegate = self
            txt.clearButtonMode = .whileEditing
            txt.backgroundColor = .clear
            txt.autocorrectionType = .no
            txt.spellCheckingType = .no
            txt.textColor = .darkGray
        }
        
        txtViewMessage.delegate = self
        txtViewMessage.font = getFont(size: 16)
        
        btnSubmit.layer.cornerRadius = 6
        btnSubmit.layer.borderWidth = 1
        btnSubmit.titleLabel?.font = getBoldFont(size: 18)
        btnSubmit.layer.borderColor = (btnSubmit.titleLabel?.textColor ?? UIColor.black).cgColor
        btnSubmit.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            txtPhone.becomeFirstResponder()
        case txtPhone:
            txtSubject.becomeFirstResponder()
        case txtSubject:
            txtViewMessage.becomeFirstResponder()
        case txtViewMessage:
            self.view.endEditing(true)
        default:
            break
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: textField.frame.width, height: 16))
        title.text = textField.placeholder ?? ""
        title.backgroundColor = .clear
        title.font = getFont(size: 11)
        title.textColor = .lightGray
        title.tag = 1212
        textField.addSubview(title)
        textField.setAttributedPlaceholder(txt: textField.placeholder ?? "",color: .clear)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        textField.text = txt
        
        if txt.isEmpty {
            textField.subviews.forEach { view in
                if view.tag == 1212 {
                    view.removeFromSuperview()
                }
            }
            textField.setAttributedPlaceholder(txt: textField.placeholder ?? "",color: UIColor.lightGray.withAlphaComponent(0.8))
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text! == "Message" {
            textView.text = ""
            textView.textColor = .darkGray
        }
        
        let title = UILabel(frame: CGRect(x: 0, y: -4, width: textView.frame.width, height: 16))
        title.text = "Message"
        title.backgroundColor = .clear
        title.font = getFont(size: 11)
        title.textColor = .lightGray
        title.tag = 1212
        textView.addSubview(title)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text!.isEmpty {
            textView.text = "Message"
            textView.textColor = .lightGray
        }
        
        if textView.text!.isEmpty || textView.text! == "Message" {
            textView.subviews.forEach { view in
                if view.tag == 1212 {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func submitForm(){
        var isValid = true
        
        let name = txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = txtPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let subject = txtSubject.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = txtViewMessage.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            isValid = false
            txtName.shakeLow()
            viewName.shakeLow()
        }
        
        if email.isEmpty {
            isValid = false
            txtEmail.shakeLow()
            viewEmail.shakeLow()
        }
        
        if phone.isEmpty {
            isValid = false
            txtPhone.shakeLow()
            viewPhone.shakeLow()
        }
        
        if subject.isEmpty {
            isValid = false
            txtSubject.shakeLow()
            viewSubject.shakeLow()
        }
        
        if message.isEmpty || message == "Message" {
            isValid = false
            txtViewMessage.shakeLow()
            viewMessage.shakeLow()
        }
        
        if isValid {
            
        } else {
            appDelegate.showAlert(vc: self, titleTxt: "Please Fill All Data", msgTxt: ((!email.isEmpty && !email.isValidEmail()) ? "Please Enter a Valid Email" : ""), btnTxt: "OK")
        }
    }
    
}
