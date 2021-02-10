//
//  MainTabBarController.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit
import SwiftUI
import UserNotifications

class MainTabBarController: UITabBarController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        setUpViewControllers()
    }

    fileprivate func setUpViewControllers() {
        let boldConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17, weight: .bold))
        
        let homeNavController = buildTabBarControllers(withTitle: "Habits",
                                                       andImage: UIImage(named: "checkmark", in: nil, with: boldConfig)!,
                                                       andRootVC: HomeCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(),
                                                                                               persistenceManager: self.appDelegate.getPersistenceService(),
                                                                                               defaults: self.appDelegate.getUserDefaults(),
                                                                                               userNotifCenter: self.appDelegate.getUserNotificationCenter(),
                                                                                               notifCenter: self.appDelegate.getNotificationCenter()))

        let historyNavController = buildTabBarControllers(withTitle: "History",
                                                          andImage: UIImage(named: "arrow.counterclockwise", in: nil, with: boldConfig)!,
                                                          andRootVC: HistoryCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(),
                                                                                                     persistenceManager: self.appDelegate.getPersistenceService(),
                                                                                                     defaults: self.appDelegate.getUserDefaults(),
                                                                                                     notifCenter: self.appDelegate.getNotificationCenter(),
                                                                                                     userNotifCenter: self.appDelegate.getUserNotificationCenter()))

        let settingsHostController = SettingsViewController(rootView: SettingsSwiftUI())
        settingsHostController.title = "Health Fixed"
        settingsHostController.tabBarItem.title = "Health Fixed"
        settingsHostController.tabBarItem.image = UIImage(named: "gear", in: nil, with: boldConfig)!

        viewControllers = [homeNavController, historyNavController, settingsHostController]
    }
        
    fileprivate func buildTabBarControllers(withTitle title: String, andImage image: UIImage, andRootVC vc: UIViewController = UIViewController()) -> UINavigationController {
        vc.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.tintColor = .systemGreen
        return navController
    }
}
