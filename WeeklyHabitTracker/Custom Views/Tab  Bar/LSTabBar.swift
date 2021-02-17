//import UIKit
//
//class LSTabBar: UITabBarController {
//
//    // MARK: View Controller
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//}
//
//
//// MARK: - Methods
//private extension LSTabBar {
//
//    func createHomeNC() -> UINavigationController {
//        let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
//        homeVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.house, selectedImage: Asserts.houseFill)
//        homeVC.tabBarItem.tag = 0
//        return UINavigationController(rootViewController: homeVC)
//    }
//
//
//    func createMakeHabbitsNC() -> UINavigationController {
//        let makeHabitsVC = MakeHabitsVC()
//        makeHabitsVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.plusSquare, selectedImage: Asserts.plusSquareFill)
//        makeHabitsVC.tabBarItem.tag = 1
//        return UINavigationController(rootViewController: makeHabitsVC)
//    }
//
//
//    func createLifeStylesListNC() -> UINavigationController {
//        let lifeStylesListVC = LifeStylesVC()
//        lifeStylesListVC.tabBarItem = UITabBarItem(title: Strings.empty, image: Asserts.star, selectedImage: Asserts.starFill)
//        lifeStylesListVC.tabBarItem.tag = 2
//        return UINavigationController(rootViewController: lifeStylesListVC)
//    }
//
//
//    func setupUI() {
//        UITabBar.appearance().tintColor = AppColor.lightBlack
//        viewControllers = [createHomeNC(), createMakeHabbitsNC(), createLifeStylesListNC()]
//
//        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]
//        var descriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: Fonts.avenirNext])
//        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
//
//        let attributesForTitle = [
//            NSAttributedString.Key.font: UIFont(descriptor: descriptor, size: 18),
//            NSAttributedString.Key.foregroundColor : AppColor.lightBlack
//        ]
//
//        let attributesForLargeTitle = [
//            NSAttributedString.Key.font: UIFont(descriptor: descriptor, size: 35),
//            NSAttributedString.Key.foregroundColor : AppColor.lightBlack
//        ]
//
//        UINavigationBar.appearance().tintColor = AppColor.lightAsh
//        UINavigationBar.appearance().titleTextAttributes = attributesForTitle
//        UINavigationBar.appearance().largeTitleTextAttributes = attributesForLargeTitle
//    }
//}
