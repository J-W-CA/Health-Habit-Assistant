//
//  NewContentView.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/20/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import SwiftUI
import UserNotifications

class NewContentView: UIHostingController<NewContentViewCon> {
    
}

let Settings = UserDefaults.standard

struct NewContentViewCon: View {
    // MARK: - Properties

    @State var showingSettings = false

    @ObservedObject var ThePomoshTimer = PomoshTimer()
    var isIpad = UIDevice.current.model.hasPrefix("iPad")
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let notificationCenter = UNUserNotificationCenter.current()
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    // MARK: - InDaClub
    init() {
        if ThePomoshTimer.showNotifications {
            notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                if granted {
                    Settings.set(true, forKey: "didNotificationsAllowed")
                } else {
                    Settings.set(false, forKey: "didNotificationsAllowed")
                }
            }
        }
        // Reset notification badge when app opened
        UIApplication.shared.applicationIconBadgeNumber = 0
        // No sleep 🐑
        UIApplication.shared.isIdleTimerDisabled = true
    }

    // MARK: - Main Component

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                TimerRing(color1: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), width: isIpad ? 600 : 300, height: isIpad ? 600 : 300, percent: CGFloat(((Float(ThePomoshTimer.fulltime) - Float(ThePomoshTimer.timeRemaining)) / Float(ThePomoshTimer.fulltime)) * 100), Timer: ThePomoshTimer)
                    .padding()
                    .scaledToFit()
                    .frame(maxWidth: 1200, maxHeight: 1200, alignment: .center)
            }.navigationBarTitle(Text("Time Arrange"))
            .navigationBarItems(
                leading: Button(action: {
                    generator.impactOccurred()
                    self.ThePomoshTimer.isActive = false
                    self.ThePomoshTimer.round -= 1
                    self.ThePomoshTimer.fulltime = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                    self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                    if self.ThePomoshTimer.playSound {
                        self.ThePomoshTimer.endSound()
                    }
                }) {
                    HStack {
                        Image("Skip")
                            .antialiased(false)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 28, maxHeight: 28, alignment: .center)
                    }
                }
                .buttonStyle(PomoshButtonStyle()),
                trailing:
                Button(action: {
                    generator.impactOccurred()
                    self.showingSettings.toggle()
                }) {
                    HStack {
                        Image("Settings")
                            .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 28, maxHeight: 28, alignment: .center)
                    }
                }
                .buttonStyle(PomoshButtonStyle())
            )
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color("Background"))
            .edgesIgnoringSafeArea(.all)
            // Catches soft close
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                if self.ThePomoshTimer.isActive && self.ThePomoshTimer.showNotifications && self.ThePomoshTimer.timeRemaining > 0 {
                    self.scheduleAlarmNotification(sh: TimeInterval(self.ThePomoshTimer.timeRemaining))
                    Settings.set(self.ThePomoshTimer.round, forKey: "lastKnownRound")
                    Settings.set(self.ThePomoshTimer.runnedRounds, forKey: "lastRunnedRound")
                    Settings.set(self.ThePomoshTimer.isBreakActive, forKey: "itWasBreak")
                }
            }
            // Catches total destruction
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                if self.ThePomoshTimer.isActive && self.ThePomoshTimer.showNotifications && self.ThePomoshTimer.timeRemaining > 0 {
                    self.scheduleAlarmNotification(sh: TimeInterval(self.ThePomoshTimer.timeRemaining))
                    Settings.set(self.ThePomoshTimer.runnedRounds, forKey: "lastKnownRound")
                    Settings.set(self.ThePomoshTimer.isBreakActive, forKey: "itWasBreak")
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                cancelNotifications()
                if isCameFromNotification {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        generator.impactOccurred()
                        withAnimation(.interpolatingSpring(mass: 1.0,
                                                           stiffness: 100.0,
                                                           damping: 10,
                                                           initialVelocity: 0)) {
                            self.ThePomoshTimer.isActive = true
                            self.ThePomoshTimer.timeRemaining = 2
                            self.ThePomoshTimer.round = UserDefaults.standard.integer(forKey: "lastKnownRound")
                            self.ThePomoshTimer.runnedRounds = UserDefaults.standard.integer(forKey: "lastRunnedRound")
                            if UserDefaults.standard.bool(forKey: "itWasBreak") {
                                self.ThePomoshTimer.isBreakActive = true
                            } else {
                                self.ThePomoshTimer.isBreakActive = false
                            }
                        }
                    }

                    isCameFromNotification = false
                }
            }
            .onReceive(timer) { _ in
                guard self.ThePomoshTimer.isActive else { return }

                if self.ThePomoshTimer.timeRemaining > 0 {
                    self.ThePomoshTimer.timeRemaining -= 1
                }

                if self.ThePomoshTimer.timeRemaining == 1 && self.ThePomoshTimer.round > 0 {
                    if self.ThePomoshTimer.playSound {
                        self.ThePomoshTimer.endSound()
                    }
                    self.ThePomoshTimer.isBreakActive.toggle()

                    if self.ThePomoshTimer.isBreakActive == true {
                        if self.ThePomoshTimer.round == 1 {
                            self.ThePomoshTimer.timeRemaining = 0
                            self.ThePomoshTimer.isBreakActive = false
                        } else {
                            if self.ThePomoshTimer.runnedRounds == self.ThePomoshTimer.longBreakRound - 1 {
                                self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "fullLongBreakTime") ?? 1200
                                self.ThePomoshTimer.fulltime = UserDefaults.standard.optionalInt(forKey: "fullLongBreakTime") ?? 1200
                            } else {
                                self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "fullBreakTime") ?? 600
                                self.ThePomoshTimer.fulltime = UserDefaults.standard.optionalInt(forKey: "fullBreakTime") ?? 600
                            }
                        }
                        self.ThePomoshTimer.runnedRounds += 1
                        self.ThePomoshTimer.round -= 1
                    } else {
                        self.ThePomoshTimer.fulltime = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                        self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                    }
                    generator.impactOccurred()
                } else if self.ThePomoshTimer.timeRemaining == 0 {
                    self.ThePomoshTimer.isActive = false
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Local Notifications

    func scheduleAlarmNotification(sh: TimeInterval) {
        let content = UNMutableNotificationContent()
        var bodyString: String {
            var string = ""
            if self.ThePomoshTimer.isBreakActive == true {
                string = "Now, It's time to work 💪. Tap here too start the timer..."
            } else {
                string = "Awesome! It's break time ☕️. Tap here to start the timer..."
            }
            return string
        }
        content.title = "Task has done!"
        content.body = bodyString
        content.badge = 1
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: sh, repeats: false)
        let identifier = "localNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.getNotificationSettings { Settings in
            if Settings.authorizationStatus == .authorized {
                self.notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
