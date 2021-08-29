//
//  Constants.swift

//  Copyright (c) IDS 2017  All rights reserved.
//

import UIKit

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let deviceType = "0"
let appRad : CGFloat =  3

/*--------------User Defaults keys-------------*/
enum FSUserDefaultsKey {
    enum DeviceToken {
        private static let Prefix = "FSDeviceToken"
        
        static let Data = GenerateKey(Prefix, key: "Data")
        static let String = GenerateKey(Prefix, key: "String")
    }
}


enum ErrorCodes {
    static let connection = "Error: connection"
    static let parseData = "Error: parseData"
    static let fatalError = "Error: fatalError"
    static let sessionExpired = "Error: sessionExpired"
    static let login = "Error: login"
}


enum Webservice {
    static let baseUrl = "https://inoyadi.com/shca/"
    static let url = baseUrl + "api.php?"
    
    static let get_category = item(key: "01",value: url + "class=category&function=get_category")
    
    static let add_device = item(key: "00",value: url + "class=Device&function=creat_token")
}


/*----------Colors----------*/
enum AppColors {
    static let white = UIColor.white
    static let lightGreen = UIColor(hex:"55d5a0")
    //    static let DarkGreen = UIColor(hex:"016652")
    //    static let grey = UIColor(hex:"f2f2f2")
    //    static let greyLight = UIColor(hex:"f8f8f8")
    //    static let backGrey = UIColor(hex:"e8e8e8")
    //    static let backGreyAlt = UIColor(hex:"dcdcdc")
    //    static let yellow = UIColor(hex:"ffca85")
    //    static let greyText = UIColor(hex:"727272")
    static let shadow = UIColor(hex:"7c7c7c")
    //    static let swichGrey = UIColor(hex:"cccccc")
    //    static let sepGrey = UIColor(hex:"e5e5e5")
    //    static let brown = UIColor(hex:"D89359")
    //
    //    static let stringRed = "c32130"
    //    static let darkGrey = UIColor(hex:"232225")
    //    static let lightRed = UIColor(hex:"e97c87")
    //
    //
    //    static let stringGreen = "398e3d"
    //    static let green = UIColor(hex: stringGreen)
    //    static let greyFooter = UIColor(hex: "999999")
    //    static let violet = UIColor(hex: "A375CD")
    //
    //    static let stringBlue = "0061A7"
    //    static let LightBlue = UIColor(hex: "57D0D3")
    
    //    static let bgColor = UIColor(hex: "FAFAFA")
    
    static let red = UIColor(hex: "cc2632")
    static let lightGrey = UIColor(hex:"eeeeee")
    static let Blue = UIColor(hex: "0061A7")
    static let black = UIColor(hex: "333333")
    
    static let orange = UIColor(hex: "f6d046") //UIColor(hex: "FE5E32")
    
    static let Yellow = UIColor(hex: "f6d046")
    static let Grey = UIColor(hex: "363636")
    static let Purple = UIColor(hex: "800080")
}


/*----------Helpers----------*/
private func GenerateKey (_ prefix: String, key: String) -> String {
    return "__\(prefix)-\(key)__"
}

func calculateImageHeight(image: UIImage, width: CGFloat) -> CGFloat {
    
    let aspect = image.size.height / image.size.width
    let height = width * aspect
    return height
    
}


func getEmptyLabel() -> UILabel {
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    let label = UILabel(frame: CGRect(x: w / 2, y: h / 2, width: UIScreen.main.bounds.width, height: 30))
    label.text = NSLocalizedString("NoData", comment: "")
    label.center = CGPoint(x: w / 2, y: h / 2)
    label.textAlignment = .center
    label.textColor = UIColor.white
    
    return label
}


func imageWithImage(image: UIImage, scaleToSize newSize: CGSize, isAspectRation aspect: Bool) -> UIImage {
    
    let originRatio = image.size.width / image.size.height;//CGFloat
    let newRatio = newSize.width / newSize.height
    
    var sz: CGSize = CGSize()
    
    if (!aspect) {
        sz = newSize
    } else {
        if (originRatio < newRatio) {
            sz.height = newSize.height
            sz.width = newSize.height * originRatio
        } else {
            sz.width = newSize.width
            sz.height = newSize.width / originRatio
        }
    }
    let scale: CGFloat = 1.0
    
    sz.width /= scale
    sz.height /= scale
    UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
    image.draw(in: CGRect(x: 0, y: 0, width: sz.width, height: sz.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}


func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}


func getFont(size: CGFloat) -> UIFont {
    var sizee = size
    if(appDelegate.isIpad){
        sizee = size + 2
    }
    
    if(getLanguage() == Language.AR) {
        return UIFont(name: "DroidArabicKufi", size: sizee - 1)!
    } else {
        return UIFont(name: "MyriadPro-Regular", size: sizee)! // Gilroy-Light "Lato-Regular"
    }
}

func getSemiBoldFont(size: CGFloat) -> UIFont {
    var sizee = size
    if(appDelegate.isIpad){
        sizee = size + 2
    }
    
    if(getLanguage() == Language.AR) {
        return UIFont(name: "DroidArabicKufi-Bold", size: sizee - 1)!
    } else {
        return UIFont(name: "MyriadPro-Semibold", size: sizee)! // Gilroy-ExtraBold "Lato-Regular"
    }
}
/*
 GillSans-SemiBold
 GillSans-UltraBold
 GillSans-Bold
 
 Gilroy-ExtraBold
 */
func getBoldFont(size: CGFloat) -> UIFont {
    var sizee = size
    if(appDelegate.isIpad){
        sizee = size + 2
    }
    
    if(getLanguage() == Language.AR) {
        return UIFont(name: "DroidArabicKufi-Bold", size: sizee - 1)!
    } else {
        return UIFont(name: "Gilroy-ExtraBold", size: sizee)! // Gilroy-ExtraBold "Lato-Regular"
    }
}


extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 2.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension Date
{
    func toDateString(dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


func getTabBarColor(frame : CGRect) -> CAGradientLayer{
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.colors = [UIColor.black.cgColor ,UIColor.black.cgColor ] //[ UIColor(hex:"2ca681").cgColor, UIColor(hex:"4abd8e").cgColor]
    return gradientLayer
}


public enum Model : String {
    case simulator     = "simulator/sandbox",
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPad5              = "iPad 5", //aka iPad 2017
    iPad6              = "iPad 6", //aka iPad 2018
    //iPad mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    //iPad pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    iPhone11           = "iPhone 11",
    iPhone11Pro        = "iPhone 11 Pro",
    iPhone11ProMax     = "iPhone 11 Max",
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
//MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        let modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //aka iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //aka iPad 2018
            "iPad7,6"   : .iPad6,
            //iPad mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            //iPad pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            //AppleTV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}


extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
}
