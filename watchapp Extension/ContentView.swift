//
//  ContentView.swift
//  watchapp Extension
//
//  Created by Jason Wang on 13/2/2021.
//  Copyright © 2021 Jason Wang. All rights reserved.
//

import SwiftUI

let settings = UserDefaults.standard

struct ContentView: View {
    // MARK: - Properties

    @ObservedObject var ThePomoshTimer: PomoshTimer = PomoshTimer()
    @State private var currentPage = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Main Component

    var body: some View {
        VStack {
            PagerView(pageCount: 2, currentIndex: $currentPage) {
                VStack(alignment: .center) {
                    if self.ThePomoshTimer.isActive == true {
                        VStack {
                            Text(self.ThePomoshTimer.isBreakActive ? "☕️ Break time" : "Priority X \(self.ThePomoshTimer.round)")
                                .font(.body)
                                .foregroundColor(Color.gray)
                            Text("\(self.ThePomoshTimer.textForPlaybackTime(time: TimeInterval(self.ThePomoshTimer.timeRemaining)))")
                                .font(Font.system(.largeTitle).monospacedDigit())
                                .fontWeight(.bold)
                                .animation(nil)
                        }
                        .onTapGesture {
                            self.ThePomoshTimer.isActive.toggle()
                            WKInterfaceDevice.current().play(.stop)
                        }
                    } else {
                        Text(self.ThePomoshTimer.round > 0 ? self.ThePomoshTimer.isBreakActive ? "Break stopped" : "Paused" : "Create New Session")
                            .font(.body)
                            .foregroundColor(Color.gray)
                            .onTapGesture {
                                if self.ThePomoshTimer.round == 0 {
                                    self.ThePomoshTimer.round = UserDefaults.standard.optionalInt(forKey: "fullround") ?? 5
                                    self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                                    WKInterfaceDevice.current().play(.success)
                                }

                                self.ThePomoshTimer.isActive.toggle()
                            }
                    }
                }.navigationBarTitle("Time Arrange")
                    .onReceive(timer) { _ in
                        guard self.ThePomoshTimer.isActive else { return }

                        if self.ThePomoshTimer.timeRemaining > 0 {
                            self.ThePomoshTimer.timeRemaining -= 1
                        }

                        //  if self.ThePomoshTimer.playSound && self.ThePomoshTimer.timeRemaining == 7 && self.ThePomoshTimer.round > 0 {
                        //      NSSound(named: "before")?.play()
                        //  }
                        if self.ThePomoshTimer.timeRemaining == 1 && self.ThePomoshTimer.round > 0 {
                            WKInterfaceDevice.current().play(.success)

                            // Break time or working time switcher 🎛
                            self.ThePomoshTimer.isBreakActive.toggle()

                            if self.ThePomoshTimer.isBreakActive == true {
                                if self.ThePomoshTimer.round == 1 {
                                    self.ThePomoshTimer.timeRemaining = 0
                                    self.ThePomoshTimer.isBreakActive = false
                                } else {
                                    // Adds time for break
                                    //        print("It's break time 😴")
                                    self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "fullBreakTime") ?? 600
                                    self.ThePomoshTimer.fulltime = UserDefaults.standard.optionalInt(forKey: "fullBreakTime") ?? 600
                                }
                                // Removes 1 from total remaining round
                                self.ThePomoshTimer.round -= 1
                            } else {
                                self.ThePomoshTimer.fulltime = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                                self.ThePomoshTimer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                            }

                        } else if self.ThePomoshTimer.timeRemaining == 0 {
                            WKInterfaceDevice.current().play(.notification)
                            self.ThePomoshTimer.isActive = false
                        }
                    }

                VStack {
                    ScrollView {
                        Spacer()
                        Text("Working Time:  \(self.ThePomoshTimer.fulltime / 60) minute")
                            .font(Font.system(size: 12).monospacedDigit())
                            .animation(nil)

                        Slider(value: Binding(
                            get: {
                                Double(UserDefaults.standard.integer(forKey: "time"))
                            },
                            set: { newValue in
                                settings.set(newValue, forKey: "time")
                                self.ThePomoshTimer.fulltime = Int(newValue)
                            }
                            //    ),in: 10...3600, step: 10)
                        ), in: 1200 ... 3600, step: 300)

                        Text("Break Time:  \(self.ThePomoshTimer.fullBreakTime / 60) minute")
                            .font(Font.system(size: 12).monospacedDigit())
                            .animation(nil)

                        Slider(value: Binding(
                            get: {
                                Double(self.ThePomoshTimer.fullBreakTime)
                            },
                            set: { newValue in
                                settings.set(newValue, forKey: "fullBreakTime")
                                self.ThePomoshTimer.fullBreakTime = Int(newValue)
                            }
                        ), in: 300 ... 600, step: 60)

                        Text("Total cycles in a session")
                            .font(Font.system(size: 12).monospacedDigit())
                            .animation(nil)
                        HStack {
                            ForEach(0 ..< self.ThePomoshTimer.fullround, id: \.self) { _ in

                                Text("P")
                                    .font(.system(size: 12))
                            }
                        }
                        Slider(value: Binding(
                            get: {
                                Double(UserDefaults.standard.integer(forKey: "fullround"))
                            },
                            set: { newValue in
                                settings.set(newValue, forKey: "fullround")
                                print(newValue)
                                self.ThePomoshTimer.fullround = Int(newValue)
                            }
                        ), in: 1 ... 6, step: 1)

                        Spacer()
                    }
                }
            }

            HStack {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPage == 1 ? Color.gray : Color.white)
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPage == 1 ? Color.white : Color.gray)
            }
        }
    }
}
