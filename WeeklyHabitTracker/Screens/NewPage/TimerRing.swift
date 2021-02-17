//
//  TimerRing.swift
//  Pomosh
//
//  Created by Steven J. Selcuk on 2.06.2020.
//  Copyright © 2020 Steven J. Selcuk. All rights reserved.
//

import SwiftUI

struct TimerRing: View {
    var color1 = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    var color2 = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    var color3 = #colorLiteral(red: 1, green: 0.003921568627, blue: 0.4588235294, alpha: 1)
    var color4 = #colorLiteral(red: 0.9921568627, green: 0.9294117647, blue: 0.1333333333, alpha: 1)
    var width: CGFloat = 300
    var height: CGFloat = 300
    var percent: CGFloat = 10
    @State private var morphing = false
    var isIpad = UIDevice.current.model.hasPrefix("iPad")
    var Timer: PomoshTimer
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        let multiplier = width / 1000
        let progress = 0 + (percent / 100)

        return HStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 3 * multiplier))
                    .frame(width: width, height: height)
                Circle()
                    .trim(from: true ? progress : 1, to: 1)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color(self.Timer.isBreakActive ? color3 : color1), Color(self.Timer.isBreakActive ? color4 : color2)]), startPoint: .topLeading, endPoint: .bottomLeading),
                        style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                    )
                    .frame(width: width, height: width)
                    .animation(.linear)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .scale).combined(with: .opacity))
                    .rotationEffect(Angle(degrees: 90))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                    .shadow(color: Color(#colorLiteral(red: 0.4666666667, green: 0.0862745098, blue: 0.9725490196, alpha: 1)).opacity(0.3), radius: 5 * multiplier, x: 0, y: 5 * multiplier)

                VStack(alignment: .center, spacing: 15) {
                    if self.Timer.isActive {
                        Text(self.Timer.isBreakActive ? "☕️ Break time" : "Priority X \(self.Timer.round)")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: isIpad ? 24 : 16))
                            .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)).combined(with: .opacity))
                    } else {
                        Text(self.Timer.round > 0 ? self.Timer.isBreakActive ? "Break stopped" : "Start" : "Create New Session")
                            .foregroundColor(Color("Text"))
                            .font(.custom("Silka Regular", size: isIpad ? 24 : 16))
                            .onTapGesture {
                                if self.Timer.round == 0 {
                                    if self.Timer.playSound {
                                        self.Timer.sessionSound()
                                        self.Timer.simpleSuccess()
                                    }
                                    self.Timer.round = UserDefaults.standard.optionalInt(forKey: "fullround") ?? 5
                                    self.Timer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                                }
                            }
                    }

                    Button(action: {
                        self.Timer.isActive.toggle()
                        if self.Timer.playSound {
                            self.Timer.toggleSound()
                        }
                        self.Timer.simpleSuccess()
                    }) {
                        if self.Timer.isActive && self.Timer.round > 0 {
                            Image("Pause")
                                .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: isIpad ? 128 : 64, maxHeight: isIpad ? 128 : 64, alignment: .center)

                        } else if self.Timer.isActive == false && self.Timer.round > 0 {
                            Image("Play")
                                .antialiased(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: isIpad ? 128 : 64, maxHeight: isIpad ? 128 : 64, alignment: .center)
                                .offset(x: 2, y: 0)
                        }
                    }
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .scale).combined(with: .opacity))

                    .buttonStyle(PomoshButtonStyle())
                    //        .padding(.vertical, 10.0)
                    .offset(x: 0, y: isIpad ? 20 : 5)

                    if self.Timer.round > 0 {
                        Text("\(self.Timer.textForPlaybackTime(time: TimeInterval(self.Timer.timeRemaining)))")
                            //    .font(.system(size: 28, design: .monospaced))
                            .font(.custom("Space Mono Regular", size: isIpad ? 64 : 28))
                            .shadow(color: Color("Green").opacity(0.1), radius: 5 * multiplier, x: 0, y: 5 * multiplier)
                            //      .fontWeight(.heavy)
                            .lineLimit(1)
                            .foregroundColor(Color("Neon"))
                            .offset(x: 0, y: isIpad ? 25 : 5)
                    }
                }
            }
        }
        .contentShape(Circle())
        .onTapGesture {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.interpolatingSpring(mass: 1.0,
                                                   stiffness: 100.0,
                                                   damping: 10,
                                                   initialVelocity: 0)) {
                    if self.Timer.round == 0 {
                        if self.Timer.playSound {
                            self.Timer.sessionSound()
                        }
                        self.Timer.round = UserDefaults.standard.optionalInt(forKey: "fullround") ?? 5
                        self.Timer.timeRemaining = UserDefaults.standard.optionalInt(forKey: "time") ?? 1200
                    }
                    self.Timer.isActive.toggle()
                    if self.Timer.playSound {
                        self.Timer.toggleSound()
                    }

                    self.Timer.simpleSuccess()
                    generator.impactOccurred()
                }
            }
        }
    }
}
