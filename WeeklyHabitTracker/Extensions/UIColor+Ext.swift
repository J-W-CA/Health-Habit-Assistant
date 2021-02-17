import UIKit

enum AssertColor: String {
    case lightAsh = "light_ash"
    case darkestAsh = "darkest_ash"
    case greenishBlue = "greenish_blue"
    case lighestGreen = "lighest_green"
    case lightYellow = "light_yellow"
    case pinkishRed = "pinkish_red"
    case teal = "teal"
    case lightBlack = "light_black"
}


extension UIColor {
    static func appColor(color: AssertColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}


struct AppColor {
    static let lightAsh = UIColor.appColor(color: .lightAsh)
    static let darkestAsh = UIColor.appColor(color: .darkestAsh)
    static let greenishBlue = UIColor.appColor(color: .greenishBlue)
    static let lighestGreen = UIColor.appColor(color: .lighestGreen)
    static let lightYellow = UIColor.appColor(color: .lightYellow)
    static let pinkishRed = UIColor.appColor(color: .pinkishRed)
    static let teal = UIColor.appColor(color: .teal)
    static let lightBlack = UIColor.appColor(color: .lightBlack)
}
