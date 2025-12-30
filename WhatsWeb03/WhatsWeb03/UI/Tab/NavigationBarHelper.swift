//
//  NavigationBarHelper.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/16.
//
import SwiftUI

struct NavigationBarHelper {
    static func setDarkAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        let width = UIScreen.main.bounds.width
        let window = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first

        let topInset = window?.safeAreaInsets.top ?? 44
        let height: CGFloat = topInset + 44

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 247/255.0, green: 246/255.0, blue: 255/255.0, alpha: 1.0).cgColor,
            UIColor(red: 230/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        let maskPath = UIBezierPath(
            roundedRect: gradientLayer.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        gradientLayer.mask = maskLayer

        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
        }
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        appearance.backgroundImage = gradientImage
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension View {
    func navigationModifiers(title: String, onBack: @escaping () -> Void) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image("nav_back_image")
                    }
                }
                ToolbarItem(placement: .principal) {
                    CustomText(text: title, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010FF")
                }
            }
            .onAppear {
                NavigationBarHelper.setDarkAppearance()
            }
            .enableSwipeBack()
    }
    func navigationModifiersWithRightButton(
        title: String,
        onBack: @escaping () -> Void,
        rightButtonImage: String,
        onRightButtonTap: @escaping () -> Void
    ) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image("nav_back_image")
                    }
                }
                ToolbarItem(placement: .principal) {
                    CustomText(text: title, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010FF")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onRightButtonTap) {
                        Image(rightButtonImage)
                    }
                }
            }
            .onAppear {
                NavigationBarHelper.setDarkAppearance()
            }
            .enableSwipeBack()
    }
    func navigationModifiersWithRightView<RightView: View>(
        title: String,
        onBack: @escaping () -> Void,
        @ViewBuilder rightView: @escaping () -> RightView
    ) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image("nav_back_image")
                    }
                }
                ToolbarItem(placement: .principal) {
                    CustomText(text: title, fontName: Constants.FontString.medium, fontSize: 16, colorHex: "#101010FF")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    rightView()
                }
            }
            .onAppear {
                NavigationBarHelper.setDarkAppearance()
            }
            .enableSwipeBack()
    }
    func navigationPlainStyle() -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
            }
            .onAppear {
                NavigationBarHelper.setDarkAppearance()
            }
            .enableSwipeBack()
    }
    func navigationHidden() -> some View {
        self
            .navigationBarHidden(true)
    }
}

struct SwipeBackHelper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            controller.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension View {
    func enableSwipeBack() -> some View {
        self.background(SwipeBackHelper())
    }
}
