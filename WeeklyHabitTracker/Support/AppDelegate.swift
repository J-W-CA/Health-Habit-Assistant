//
//  AppDelegate.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit
import BackgroundTasks
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var habits: [Habit]!
    private var dateClosed: Date!
    private let dateClosedKey = "dateClosedKey"
    private let defaults = UserDefaults.standard
    private let persistenceService = PersistenceService.shared
    private let notificationCenter = NotificationCenter.default
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func getUserDefaults() -> UserDefaults { return self.defaults }
    func getPersistenceService() -> PersistenceService { return self.persistenceService }
    func getNotificationCenter() -> NotificationCenter { return self.notificationCenter }
    func getUserNotificationCenter() -> UNUserNotificationCenter { return self.userNotificationCenter }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted { print("granted") }
            else { print("not granted") }
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.forming.refresh", using: nil) { [weak self] (task) in
            guard let self = self else { return }
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        self.notificationCenter.addObserver(self, selector: #selector(dayChangeNotification), name: .NSCalendarDayChanged, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // for next update
//        let habits = self.persistenceService.fetch(Habit.self)
//        for habit in habits {
//            habit.goal = -1
//            habit.archive.goal = habit.goal
//        }
//        let archives = self.persistenceService.fetch(Archive.self)
//        for archive in archives {
//            archive.successRate = 0
//            let total = Double(archive.completedTotal + archive.failedTotal)
//            if total != 0 { archive.successRate = Double(archive.completedTotal) / total }
//            else { archive.successRate = 1.0 }
//            print(archive.successRate)
//        }
//        persistenceService.save()
        
        return true
    }
    
    @objc func didBecomeActive() {
        if let date = self.defaults.object(forKey: self.dateClosedKey) as? Date {
            if !Calendar.current.isDateInToday(date) {
                self.habits = self.persistenceService.fetch(Habit.self)
                let elapsed = CalUtility.getDaysElapsed(fromOldDate: date, toCurrentDate: CalUtility.getCurrentDate())
                for (elapsedDay, elapsedDate) in zip(elapsed.0, elapsed.1) {
                    changeDays(toDay: elapsedDay, andDate: elapsedDate)
                }
                self.persistenceService.save()
                self.notificationCenter.post(name: NSNotification.Name(NotificationName.newDay.rawValue), object: nil)

                self.dateClosed = CalUtility.getCurrentDate()
                self.defaults.set(self.dateClosed, forKey: self.dateClosedKey)
            }
        } else {
            self.dateClosed = CalUtility.getCurrentDate()
            self.defaults.set(self.dateClosed, forKey: self.dateClosedKey)
        }
    }

    @objc func didEnterBackground() {
        self.dateClosed = CalUtility.getCurrentDate()
        self.defaults.set(self.dateClosed, forKey: self.dateClosedKey)

        self.persistenceService.save()

        self.scheduleAppRefresh()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.persistenceService.save()
    }
    
    @objc func dayChangeNotification() {
        DispatchQueue.main.async {
            if UIApplication.shared.applicationState == .active {
                self.didBecomeActive()
            }
        }
    }

//    func scheduleLocalNotification(withTitle title: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = "Notification"
//        content.sound = UNNotificationSound.default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        self.userNotificationCenter.add(request)
//    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.forming.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Successfully scheduled app refresh.")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.addOperation {
            self.didBecomeActive()
        }

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            queue.cancelAllOperations()
        }

        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }
    }

    func changeDays(toDay newDay: Int, andDate newDate: Date) {
        switch newDay {
        case 0: for habit in self.habits { habit.weekChanged(toDate: newDate, andDay: newDay) }
        default: for habit in self.habits { habit.dayChanged(toDay: newDay) }
        }
    }
}
