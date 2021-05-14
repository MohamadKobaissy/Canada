//
//  Localizer.swift
//  Localization
//
//  Copyright © 2017 Maarouf karakeh. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

class Localizer: NSObject {
    class func doTheMagic() {
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey: value: table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_: value: table:)))
        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
        MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews))
        MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))

    }
}

extension UILabel {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
        if self.textAlignment == .center{ return }
        
        if(self.tag != 999){
            if UIApplication.isRTL() {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }

    }
}

extension UITextField {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()

        if(self.tag != 999){
            if UIApplication.isRTL() {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}

/*----------Language----------*/
enum Language {
    static let EN = "en"
    static let FR = "fr"
    static let AR = "ar-LB"

    static let ENTitle = "EN"
    static let FRTitle = "FR"
    static let ARTitle = "AR"
}

func applicationIsRTL() -> Bool {
    return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
}

func getLanguage() -> String {
    if (UserDefaults.standard.string(forKey: "lang") != nil)
        {
        return UserDefaults.standard.string(forKey: "lang")!
    }
    return Language.EN
}

func getWebserviceLanguage() -> String {
    if (UserDefaults.standard.string(forKey: "lang") != nil)
        {
        var lang = UserDefaults.standard.string(forKey: "lang")!

        switch (lang) {
        case Language.EN:
            lang = "en"
        case Language.AR:
            lang = "ar"
        default:
            lang = "en"
        }

        return lang
    }
    return Language.ENTitle
}


func getLanguageCode() -> String {
    if (UserDefaults.standard.string(forKey: "lang") != nil)
    {
        var lang = UserDefaults.standard.string(forKey: "lang")!
        
        switch (lang) {
        case Language.EN:
            lang = "1"
        case Language.FR:
            lang = "2"
        case Language.AR:
            lang = "3"
        default:
            lang = "1"
        }
        
        return lang
    }
    return "1"
}


func getLanguageTitle() -> String {
    if (UserDefaults.standard.string(forKey: "lang") != nil)
        {
        var lang = UserDefaults.standard.string(forKey: "lang")!

        switch (lang) {
        case Language.EN:
            lang = Language.ENTitle
        case Language.FR:
            lang = Language.FRTitle
        case Language.AR:
            lang = Language.ARTitle
        default:
            lang = Language.ENTitle
        }

        return lang
    }
    return Language.ENTitle
}

func currentAppleLanguage() -> String{
    let userdef = UserDefaults.standard
    let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
    let current = langArray.firstObject as! String
    let endIndex = current.startIndex
    let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
    return currentWithoutLocale
}

func currentAppleLanguageFull() -> String {
    let userdef = UserDefaults.standard
    let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
    let current = langArray.firstObject as! String
    return current
}

func setLanguage(lang: String, isRTL: Bool) {
    
    UserDefaults.standard.set(lang, forKey: "lang")
    UserDefaults.standard.synchronize()
    
    // UserDefaults.standard.removeObject(forKey: "AppleLanguages")
    // UserDefaults.standard.set([lang], forKey: "AppleLanguages")
    UserDefaults.standard.set([lang,currentAppleLanguage()], forKey: "AppleLanguages")
    
    UserDefaults.standard.synchronize()
    
    if(isRTL) {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
    }
    else {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
}


extension UIApplication {
    @objc var cstm_userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if getLanguage() == Language.AR {
                direction = .rightToLeft
            }
            return direction
        }
    }
}

extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = getLanguage()
            var bundle = Bundle()
            if let _path = Bundle.main.path(forResource: currentAppleLanguageFull(), ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } else
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } else {
                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: _path)!
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
    
    var getVersionNumber: Double? {
        let ver = infoDictionary?["CFBundleShortVersionString"] as? String
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        let number = numberFormatter.number(from: ver!)
        let verNb = number?.doubleValue
        return verNb
    }
    
    var appDisplayName: String {
        return (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    }
    
    var getBundleNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String ?? "")
    }
}
 
/// Exchange the implementation of two methods of the same Class

func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
    } else {
        method_exchangeImplementations(origMethod, overrideMethod)
    }
}


func getAlignment () -> UIControl.ContentHorizontalAlignment{
    
    if getLanguage() == Language.AR{
        return .right
    }else{
        return .left
    }
    
}


func reloadApp(){
    let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
    let mainwindow = (UIApplication.shared.delegate?.window!)!
    UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionCrossDissolve, animations: { () -> Void in
    }) { (finished) -> Void in
    }
}


func reloadAppFromLogin(){
    let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
    let mainwindow = (UIApplication.shared.delegate?.window!)!
    UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionCrossDissolve, animations: { () -> Void in
    }) { (finished) -> Void in
    }
}


class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}

