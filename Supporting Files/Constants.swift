
import UIKit


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)


func getFont(size: CGFloat) -> UIFont {
    if(getLanguage() == Language.AR) {
        return UIFont(name: "DroidArabicKufi", size: size)!
    } else {
        return UIFont(name: "MyriadPro-Regular", size: size)! // Gilroy-Light "Lato-Regular"
    }
}


func getBoldFont(size: CGFloat) -> UIFont {
    if(getLanguage() == Language.AR) {
        return UIFont(name: "DroidArabicKufi-Bold", size: size)!
    } else {
        return UIFont(name: "MyriadPro-Semibold", size: size)! // Gilroy-ExtraBold "Lato-Regular"
    }
}
