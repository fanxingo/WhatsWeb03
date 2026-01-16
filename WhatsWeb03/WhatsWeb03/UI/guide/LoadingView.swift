//
//  LoadingView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/11.
//

import SwiftUI

struct LoadingView: View {
    
    @EnvironmentObject var settings: SettingsManager
    
    let totalDuration: Double = 3.0
    let updateInterval: Double = 0.01
    
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    
    @State private var isActive = false
    @State private var guideFinished: Bool = false
    @State private var showReconfirm = false
    
    @State private var guideReconfirm: Bool = false
    
    var body: some View {
        VStack {
            if isActive {
                if settings.hasWhatsPayStatus {
                    routeToMain()
                } else if !guideFinished {
                    GuideView(onComplete: {
                        guideFinished = true
                    }, onPayCancelComplete: {
                        guideFinished = true
                        showReconfirm = true
                    })
                }else if showReconfirm {
                    routeToReconfirm()
                } else {
                    routeToMain()
                }
            } else {
                VStack {
                    Image("app_logo")
                        .frame(width: 120,height: 120)
                        .padding(.top,275)
                    Spacer()
                    Text("Loding")
                        .foregroundColor(Color(hex: "#00B81C"))
                        .font(.custom("PingFangSC-Medium", size: 12))
                        .padding(.bottom,10)
                    ProgressBarView(progress: progress)
                        .padding(.horizontal,60)
                        .padding(.bottom,80)
                    
                }
                .onAppear {
                    startProgress()
                }
            }
        }
        .fullScreenBackground("loding_bgimage", true)
        .loadingMask()
        .toast()
    }
    
    @ViewBuilder
    func routeToMain() -> some View {
        TabMainView()
    }
    @ViewBuilder
    func routeToReconfirm() -> some View {
        if guideReconfirm {
            routeToMain()
        } else {
            TipsAffirmView {
                guideReconfirm = true
            }
        }
    }
    private func startProgress() {
        let steps = totalDuration / updateInterval
        var currentStep = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { t in
            currentStep += 1
            progress = min(currentStep / steps, 1.0)
            
            if progress >= 1.0 {
                t.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct ProgressBarView: View {
    var progress: Double
    var height: CGFloat = 10
    var backgroundColor: Color = Color(hex: "#FFFFFF")
    var foregroundColor: Color = Color(hex: "#00B81C")
    var cornerRadius: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(foregroundColor)
                    .frame(width: CGFloat(self.progress) * geometry.size.width, height: height)
                    .animation(.easeInOut(duration: 0.25), value: progress)
            }
        }
        .frame(height: height)
    }
}
