//
//  Constants.swift

//  Copyright (c) IDS 2017  All rights reserved.
//

import UIKit
//import ESTabBarController_swift
//import pop

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}



extension UILabel {
    public var substituteFontName: String {
        get {
            return self.font.fontName
        }
        set {
            self.font = UIFont(name: newValue, size: self.font.pointSize)
        }
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}



extension UITextView {
    public var substituteFontName: String {
        get {
            return self.font?.fontName ?? ""
        }
        set {
            self.font = UIFont(name: newValue, size: self.font?.pointSize ?? 17)
        }
    }
    
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}



extension UITextField {
    public var substituteFontName: String {
        get {
            return self.font?.fontName ?? ""
        }
        set {
            self.font = UIFont(name: newValue, size: self.font?.pointSize ?? 17)
        }
    }
    
    func setAttributedPlaceholder(txt: String , color : UIColor){
        self.attributedPlaceholder = NSAttributedString(string: txt, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}



extension UIImage {
    
    var isPortrait: Bool { return size.height > size.width }
    var isLandscape: Bool { return size.width > size.height }
    var breadth: CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // create a 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    func alpha(_ value: CGFloat) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x:0,y:0,width:size.width,height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}



extension Bundle {
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



extension Date {
    var ticks: String {
        return String(UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000))
    }
    
    func toString(dateFormat format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}



extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func shakeLow() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [-2.0, 2.0, -2.0, 2.0 ,-5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func refreshDisplay() {
        
        self.setNeedsDisplay()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getTitleView() -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "logo")
        imageView.image = logo
        return imageView
    }
    
    
    func roundTop(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func rounde() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func roundTwoCorners(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = (getLanguage() == Language.AR ? [.layerMaxXMaxYCorner, .layerMinXMinYCorner] : [.layerMaxXMinYCorner, .layerMinXMaxYCorner])
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func roundThreePoint(radius:CGFloat = 5){
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner , .layerMinXMaxYCorner]
        }
    }
    
    
    func roundThreePointRight(radius:CGFloat = 5){
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner , .layerMinXMaxYCorner]
        }
    }
    
    
    func viewIndicator(loadingInProgress: Bool) {
        let center: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2 ,y :40)
        let tag = 12093
        if loadingInProgress {
            var indicator = UIActivityIndicatorView()
            indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            indicator.tag = tag
            indicator.style = UIActivityIndicatorView.Style.whiteLarge
            indicator.color = UIColor.gray
            indicator.center = center
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            self.superview?.addSubview(indicator)
        }else {
            if let indicator = self.superview?.viewWithTag(tag) as? UIActivityIndicatorView { do {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                }
            }
        }
    }
}



extension UIViewController {
    
    func addBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(hex:"f2f2f2").cgColor, UIColor(hex:"f2f2f2").cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        //        let imageViewBackground = UIImageView(frame: CGRect(x:0,y: 0,width: 300, height:200))
        //
        //        imageViewBackground.image =  UIImage(named: "backCircle")!
        //        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFit
        //
        //        self.view.addSubview(imageViewBackground)
        //        self.view.sendSubviewToBack(imageViewBackground)
        
        //        let background = UIImage(named: "bg")
        //        var imageView : UIImageView!
        //        imageView = UIImageView(frame: view.bounds)
        //        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        //        imageView.clipsToBounds = true
        //        imageView.image = background
        //        imageView.center = view.center
        //        imageView.alpha = 0.85
        //        view.addSubview(imageView)
        //        self.view.sendSubviewToBack(imageView)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension UIButton {
    
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        
        if (self.viewWithTag(tag) == nil && show) {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else if(!show) {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
    /// 0 => .ScaleToFill
    /// 1 => .ScaleAspectFit
    /// 2 => .ScaleAspectFill
    @IBInspectable
    var imageContentMode: Int {
        get {
            return self.imageView?.contentMode.rawValue ?? 0
        }
        set {
            if let mode = UIView.ContentMode(rawValue: imageContentMode),
                self.imageView != nil {
                self.imageView?.contentMode = mode
            }
        }
    }
}



extension String {
    var MD5:String {
        get{
            let messageData = self.data(using:.utf8)!
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            
            _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
                }
            }
            
            return digestData.map { String(format: "%02hhx", $0) }.joined()
        }
    }
    
    func isArabic() -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        return predicate.evaluate(with: self)
    }
    
    func hashtags() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive){
            let string = self as NSString
            
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "#", with: "").lowercased()
            }
        }
        return []
    }
    
    func getYoutubeId() -> String {
        return URLComponents(string: self)?.queryItems?.first(where: { $0.name == "v" })?.value ?? ""
    }
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        return (self as NSString).substring(with: result.range)
    }
    
    var withoutHtml: String {
        var txt = self.replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: nil)
        txt = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return txt.replacingOccurrences(of: "nbsp;", with: "", options: .regularExpression, range: nil)
    }
    
    var withoutHtmlTag: String {
        //print("string withoutHtml",self)
        let stringss = self.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<\\br>", with: "\n").replacingOccurrences(of: "<br\\>", with: "\n")
        
        guard let data = stringss.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html
            , .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    
    
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}



extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
} // extension



extension UITableView {
    func setEmptyMessage(txt: String) {
        print("UIScreen.main.bounds.size.height = " , UIScreen.main.bounds.size.height) //667.0 -> ipad:iphone app // 896.0 -> XR  // 1024.0 - >ipad
        let messageLabel = UILabel(frame: CGRect(x: 300, y: 200, width: 30, height: 15))
        messageLabel.text = txt.isEmpty ? "No data" : txt
        messageLabel.textColor = AppColors.orange
        messageLabel.backgroundColor = .clear // AppColors.grey
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = getFont(size: 18)
        //        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}



extension UICollectionView {
    func setEmptyMessage(txt: String) {
        print("UIScreen.main.bounds.size.height = " , UIScreen.main.bounds.size.height) //667.0 -> ipad:iphone app // 896.0 -> XR  // 1024.0 - >ipad
        let messageLabel = UILabel(frame: CGRect(x: 300, y: 200, width: 30, height: 15))
        messageLabel.text = txt.isEmpty ? "No data" : txt
        messageLabel.textColor = AppColors.orange
        messageLabel.backgroundColor = .clear // AppColors.grey
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = getFont(size: 17)
        //        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}



extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}



public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
        
    }
}



extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.frame.size) //CGSize.zero
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.calculateMaxLines()
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        print("label numberOfLines =" , label.numberOfLines)
        print("label calculateMaxLines =" , label.calculateMaxLines())
        
        ///*
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        //CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x , (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        //CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x, locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        print("indexOfCharacter: " , indexOfCharacter)
        return NSLocationInRange(indexOfCharacter, targetRange)
        //*/
        
        
        /*
         // Begin computation of actual frame
         // Glyph is the final display representation
         var glyphRange = NSRange()
         // Extract the glyph range
         layoutManager.characterRangeForGlyphRange(moreStringRange!, actualGlyphRange: &glyphRange)
         
         // Compute the rect of glyph in the text container
         print("glyphRange\(glyphRange)")
         print("textContainer\(textContainer)")
         let glyphRect:CGRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
         
         // Final rect relative to the textLabel.
         print("\(glyphRect)")
         
         // Now figure out if the touch point is inside our rect
         let touchPoint:CGPoint = tapRec.locationOfTouch(0, inView: label)
         
         if glyphRect.contains(touchPoint) {
         print("User tapped on Read More. So show something more")
         return true
         }
         return false*/
    }
}


//final class DarkAlertController: CustomizableAlertController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.visualEffectView?.effect = UIBlurEffect(style: .dark)
//        self.tintColor = UIColor(red: 0.4, green: 0.5, blue: 1.0, alpha: 1.0)
//
//        let whiteStringAttribute = StringAttribute(key: .foregroundColor, value: UIColor.white)
//        self.titleAttributes = [whiteStringAttribute]
//        self.messageAttributes = [whiteStringAttribute]
//    }
//}


/*
 import ESTabBarController_swift
 class ExampleIrregularityBasicContentView: ExampleBouncesContentView {
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 
 textColor = AppColors.greyFooter // UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
 highlightTextColor = AppColors.green // UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
 iconColor = AppColors.greyFooter // UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
 highlightIconColor = AppColors.green // init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
 backdropColor = AppColors.white // UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
 highlightBackdropColor = AppColors.white // UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
 }
 
 public required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 }
 
 
 class ExampleBouncesContentView: ExampleBasicContentView {
 
 public var duration = 0.3
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 }
 
 public required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 override func selectAnimation(animated: Bool, completion: (() -> ())?) {
 self.bounceAnimation()
 completion?()
 }
 
 override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
 self.bounceAnimation()
 completion?()
 }
 
 func bounceAnimation() {
 let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
 impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
 impliesAnimation.duration = duration * 2
 impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
 imageView.layer.add(impliesAnimation, forKey: nil)
 }
 }
 
 
 
 class ExampleBasicContentView: ESTabBarItemContentView {
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 textColor = UIColor.green // init(white: 175.0 / 255.0, alpha: 1.0)
 highlightTextColor = UIColor.green // init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
 iconColor = UIColor.green // init(white: 175.0 / 255.0, alpha: 1.0)
 highlightIconColor = UIColor.green // init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
 }
 
 public required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 }
 
 
 class ExampleIrregularityContentView: ESTabBarItemContentView {
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 
 self.imageView.backgroundColor = UIColor(hex:"c32130") // UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
 self.imageView.layer.borderWidth = 3.0
 self.imageView.layer.borderColor = UIColor.init(white: 235 / 255.0, alpha: 1.0).cgColor
 self.imageView.layer.cornerRadius = 35
 self.insets = UIEdgeInsets.init(top: -32, left: 0, bottom: 0, right: 0)
 let transform = CGAffineTransform.identity
 self.imageView.transform = transform
 self.superview?.bringSubviewToFront(self)
 
 textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
 highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
 iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
 highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
 backdropColor = .clear
 highlightBackdropColor = .clear
 }
 
 public required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
 let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
 return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
 }
 
 override func updateLayout() {
 super.updateLayout()
 self.imageView.sizeToFit()
 self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
 }
 
 public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
 let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
 view.layer.cornerRadius = 1.0
 view.layer.opacity = 0.5
 view.backgroundColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
 self.addSubview(view)
 playMaskAnimation(animateView: view, target: self.imageView, completion: {
 [weak view] in
 view?.removeFromSuperview()
 completion?()
 })
 }
 
 public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
 completion?()
 }
 
 public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
 completion?()
 }
 
 public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
 UIView.beginAnimations("small", context: nil)
 UIView.setAnimationDuration(0.2)
 let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
 self.imageView.transform = transform
 UIView.commitAnimations()
 completion?()
 }
 
 public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
 UIView.beginAnimations("big", context: nil)
 UIView.setAnimationDuration(0.2)
 let transform = CGAffineTransform.identity
 self.imageView.transform = transform
 UIView.commitAnimations()
 completion?()
 }
 
 private func playMaskAnimation(animateView view: UIView, target: UIView, completion: (() -> ())?) {
 view.center = CGPoint.init(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)
 
 let scale = POPBasicAnimation.init(propertyNamed: kPOPLayerScaleXY)
 scale?.fromValue = NSValue.init(cgSize: CGSize.init(width: 1.0, height: 1.0))
 scale?.toValue = NSValue.init(cgSize: CGSize.init(width: 36.0, height: 36.0))
 scale?.beginTime = CACurrentMediaTime()
 scale?.duration = 0.3
 scale?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
 scale?.removedOnCompletion = true
 
 let alpha = POPBasicAnimation.init(propertyNamed: kPOPLayerOpacity)
 alpha?.fromValue = 0.6
 alpha?.toValue = 0.6
 alpha?.beginTime = CACurrentMediaTime()
 alpha?.duration = 0.25
 alpha?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
 alpha?.removedOnCompletion = true
 
 view.layer.pop_add(scale, forKey: "scale")
 view.layer.pop_add(alpha, forKey: "alpha")
 
 scale?.completionBlock = ({ animation, finished in
 completion?()
 })
 }
 }*/

