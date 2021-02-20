//
//  SettingsView.swift
//  Pomosh
//
//  Created by Steven Jason Wang on 2.06.2020.
//  Copyright © 2020 Steven Jason Wang. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var ThePomoshTimer = PomoshTimer()
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pomodoro Settings")) {
                    VStack(alignment: .leading, spacing: 20.0) {
                        Spacer()
                        Stepper("Working Time:  \(self.ThePomoshTimer.fulltime / 60) minute", value: self.$ThePomoshTimer.fulltime, in: 1200 ... 3600, step: 300)
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))

                        Stepper("Break Time:  \(self.ThePomoshTimer.fullBreakTime / 60) minute", value: self.$ThePomoshTimer.fullBreakTime, in: 300 ... 900, step: 60)
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))

                        Stepper("Long Break Time:  \(self.ThePomoshTimer.fullLongBreakTime / 60) minute", value: self.$ThePomoshTimer.fullLongBreakTime, in: 300 ... 1800, step: 300)
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))

                        Stepper("Trigger Long Break:\n Every \(self.ThePomoshTimer.longBreakRound)th round", value: self.$ThePomoshTimer.longBreakRound, in: 2 ... 6, step: 1)
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))

                        VStack(alignment: .leading) {
                            Text("Total cycles in a session")
                                .foregroundColor(Color("Text"))
                                .font(.custom("Silka Regular", size: 14))
                                .padding(.bottom, 10.0)
                            HStack {
                                ForEach(0 ..< self.ThePomoshTimer.fullround, id: \.self) { _ in
                                    Text("P ")
                                        .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)).combined(with: .opacity))
                                }
                            }
                            Slider(value: Binding(
                                get: {
                                    Double(self.ThePomoshTimer.fullround)

                                },
                                set: { newValue in
                                    withAnimation(.interpolatingSpring(mass: 1.0,
                                                                       stiffness: 100.0,
                                                                       damping: 10,
                                                                       initialVelocity: 0)) {
                                        generator.impactOccurred()
                                        Settings.set(newValue, forKey: "fullround")
                                        self.ThePomoshTimer.fullround = Int(newValue)
                                    }
                                }
                            ), in: 1 ... 12)
                            Spacer()
                        }
                    }
                }
                Section(header: Text("App Settings")) {
                    VStack {
                        Toggle(isOn: self.$ThePomoshTimer.playSound) {
                            Text("Sound effects")
                                .foregroundColor(Color("Text"))
                                .font(.custom("Silka Regular", size: 14))
                        }.padding(.vertical, 5.0)
                    }
                }
                Section(header: Text("About Pomosh")) {
                    HStack {
                        Text("Do you like Pomosh?")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))
                        Spacer()
                        Text("Give 5 X ⭐️")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))
                    }
                    .onTapGesture {
                        requestReviewManually()
                    }

                    HStack {
                        Text("🐛 Found bug?")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))

                        Spacer()
                        Text("Open an issue")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))
                    }
                    .onTapGesture {
                        let repoURL = URL(string: "https://github.com/stevenselcuk/Pomosh-iOS-watchOS")!
                        UIApplication.shared.open(repoURL)
                        generator.impactOccurred()
                    }
                    HStack {
                        Text("Follow us on Twitter")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))
                        Spacer()
                        Text("© Tabby Cat, LLC")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: 14))
                    }
                    .onTapGesture {
                        let screenName = "hevalandsteven"
                        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
                        let webURL = URL(string: "https://twitter.com/\(screenName)")!
                        generator.impactOccurred()
                        if UIApplication.shared.canOpenURL(appURL as URL) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(appURL)
                            } else {
                                UIApplication.shared.openURL(appURL)
                            }
                        } else {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(webURL)
                            } else {
                                UIApplication.shared.openURL(webURL)
                            }
                        }
                    }
                }

            }.navigationBarTitle("Preferences")
        }
    }

    func requestReviewManually() {
        generator.impactOccurred()
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1515791898?action=write-review")
        else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}
