//
//  DefWebView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/4.
//

import SwiftUI
import WebKit

struct DefWebView: View {
    let urlString: String
    let titleString : String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            if let url = URL(string: urlString) {
                OtherWebView(url: url, titleString: titleString)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Invalid URL")
            }
        }
        .navigationModifiersWithCustomCenterAndRightImage(onBack: {
            dismiss()
        }, rightButtonImage: "web_icon_1") {
            PopManager.shared.show(WenMenuPopView(),style: .bottom)
        } centerView: {
            WebNavView(titleString: titleString) {
                NotificationCenter.default.post(name: Notification.Name("RefreshWebView"), object: nil)
            }
        }
        .onDisappear{
            MbDoubleOpenManager.shared().saveDef(titleString, isDel: true)
        }
    }
}

struct WebNavView:View {
    let titleString : String
    var rightAction : () -> (Void)
    var body: some View {
        ZStack {
            CustomText(
                text: titleString,
                fontName: Constants.FontString.medium,
                fontSize: 18,
                colorHex: "#101010"
            )
            HStack {
                Spacer()
                Button(action: {
                    rightAction()
                }) {
                    Image("web_icon_3")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.trailing, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(
            Image("web_icon2")
                .resizable()
        )
        .padding(.bottom, 4)
    }
}

private struct OtherWebView: UIViewRepresentable {

    let url: URL
    let titleString : String

    func makeCoordinator() -> Coordinator {
        Coordinator(titleString: titleString)
    }

    func makeUIView(context: Context) -> WKWebView {

        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "elementObserver")
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15"

        context.coordinator.webView = webView

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url?.absoluteString != url.absoluteString {
            webView.load(URLRequest(url: url))
        }
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject,
                             WKNavigationDelegate,
                             WKUIDelegate,
                             WKScriptMessageHandler,
                             UIScrollViewDelegate {

        let titleString: String
        weak var webView: WKWebView?

        init(titleString: String) {
            self.titleString = titleString
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(refreshWebView), name: Notification.Name("RefreshWebView"), object: nil)
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        @objc func refreshWebView() {
            DispatchQueue.main.async { [weak self] in
                self?.webView?.reload()
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("开始加载网页")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("网页加载完成")
            MbDoubleOpenManager.shared().saveDef(titleString, isDel: true)
        }

        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            print("网页加载失败: \(error.localizedDescription)")
        }

        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            print("JS Message:", message.name)
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                print("监听--：\(url.absoluteString)")
            }
            decisionHandler(.allow)
        }
    }
}
