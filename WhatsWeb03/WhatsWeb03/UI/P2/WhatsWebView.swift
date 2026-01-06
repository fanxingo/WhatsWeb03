//
//  WhatsWebView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2026/1/4.
//

import SwiftUI
import WebKit

struct WhatsWebView:View {
    
    @Environment(\.dismiss) var dismiss
    
    let ids : String
    
    var body: some View {
        ZStack {
            if let url = URL(string: "https://web.whatsapp.com") {
                WhatsWeb(url: url, ids: ids)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Invalid URL".localized())
            }
        }
        .navigationModifiersWithCustomCenterAndRightImage(onBack: {
            dismiss()
        }, rightButtonImage: "web_icon_1") {
            PopManager.shared.show(WenMenuPopView(),style: .bottom)
        } centerView: {
            WebNavView(titleString: "WhatsApp") {
                NotificationCenter.default.post(name: Notification.Name("RefreshWebView"), object: nil)
            }
        }
    }
}

private struct WhatsWeb: UIViewRepresentable {
    
    let url: URL
    let ids : String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(ids: ids)
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
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1.1 Safari/605.1.15"
        
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
        
        let ids: String
        
        weak var webView: WKWebView?
        
        init(ids: String) {
            self.ids = ids
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
            addLoginPost()
            
            //延迟1秒执行保存用户数据
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.saveDefData()
            }
        }
        
        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            print("网页加载失败: \(error.localizedDescription)")
        }
        
        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            
            print("JS Message:", message.name, "body:", message.body)
            
            guard message.name == "elementObserver" else { return }
            
            if let body = message.body as? String {
                
                if body == "sideAppear" {
                    addElement()
                    addUserIconJS()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                        self?.saveUserData()
                    }
                } else if body == "event_TouchClick1" {
                    scrollToRight()
                }
            }
            
            if let body = message.body as? [String: Any] {
                if let type = body["type"] as? String,
                   type == "userImageBase64",
                   let base64Raw = body["text"] as? String,
                   let recalledText = body["recalledText"] as? String {
                    
                    // 去掉前缀 "data:image/jpeg;base64," 或 "data:image/png;base64,"
                    var base64 = base64Raw
                    if base64.hasPrefix("data:image/jpeg;base64,") {
                        base64 = String(base64.dropFirst("data:image/jpeg;base64,".count))
                    } else if base64.hasPrefix("data:image/png;base64,") {
                        base64 = String(base64.dropFirst("data:image/png;base64,".count))
                    }
                    
                    if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
                       let image = UIImage(data: data) {
                        // 保存图片到 Documents 目录
                        if let pngData = image.pngData() {
                            let fileManager = FileManager.default
                            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                            if let documentsURL = urls.first {
                                let fileURL = documentsURL.appendingPathComponent("\(self.ids).png")
                                do {
                                    try pngData.write(to: fileURL, options: .atomic)
                                    print("头像已保存到: \(fileURL.path)")
                                    RecentCacheManager.shared.reloadRecentItems()
                                } catch {
                                    print("保存头像失败: \(error)")
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                print("监听--：\(url.absoluteString)")
            }
            decisionHandler(.allow)
        }
        
        ///保存默认数据
        private func saveDefData(){
            MbDoubleOpenManager.shared().saveDef("WhatsApp", isDel: false)
        }
        ///保存用户数据
        private func saveUserData(){
            MbDoubleOpenManager.shared().saveCurrentWebKitData(withIdentifier: ids) { success in
                if success {
                    print("用户数据保存成功")
                    RecentCacheManager.shared.reloadRecentItems()
                }
            }
        }
        
        private func scrollToRight() {
            DispatchQueue.main.async { [weak self] in
                guard
                    let self = self,
                    let rootScrollView = self.webView?.scrollView
                else { return }
                
                if let childScrollView = self.findChildScrollView(in: rootScrollView) {
                    let offsetX = childScrollView.contentSize.width - childScrollView.bounds.width
                    let rightOffset = CGPoint(x: max(0, offsetX),
                                              y: childScrollView.contentOffset.y)
                    childScrollView.setContentOffset(rightOffset, animated: true)
                } else {
                    print("No child scrollView found")
                }
            }
        }
        
        private func findChildScrollView(in view: UIView) -> UIScrollView? {
            for subview in view.subviews {
                if let scrollView = subview as? UIScrollView {
                    return scrollView
                }
                if let found = findChildScrollView(in: subview) {
                    return found
                }
            }
            return nil
        }
        private func addLoginPost() {
            let js = """
            const observer = new MutationObserver(mutations => {
                for (const mutation of mutations) {
                    if (mutation.type === 'childList' || mutation.type === 'attributes') {
                        var button = document.getElementById('side');
                        if (button) {
                            window.webkit.messageHandlers.elementObserver.postMessage('sideAppear');
                            observer.disconnect();
                            break;
                        }
                    }
                }
            });
            observer.observe(document.body, {
                attributes: true,
                childList: true,
                subtree: true
            });
            """
            
            webView?.evaluateJavaScript(js) { result, error in
                if let error = error {
                    print("出现监听 注入失败: \(error.localizedDescription)")
                } else {
                    print("出现监听 注入成功 -- 登录状态获取")
                }
            }
        }
        
        private func addElement() {
            let js = """
            (function() {
                window.webkit.messageHandlers.elementObserver.postMessage('准备开始创建经过监听');
                window.webkit.messageHandlers.elementObserver.postMessage('开始创建经过监听');
            
                const targetElement = document.getElementById('pane-side');
                if (targetElement) {
                    targetElement.addEventListener('mouseover', event => {
                        const target = event.target;
                        const mouseX = event.clientX;
                        const mouseY = event.clientY;
            
                        var element = document.elementFromPoint(mouseX, mouseY);
                        if (element) {
                            let mouseDownEvent = new MouseEvent('mousedown', {
                                view: window,
                                bubbles: true,
                                cancelable: true,
                                clientX: mouseX,
                                clientY: mouseY
                            });
                            element.dispatchEvent(mouseDownEvent);
            
                            let mouseUpEvent = new MouseEvent('mouseup', {
                                view: window,
                                bubbles: true,
                                cancelable: true,
                                clientX: mouseX,
                                clientY: mouseY
                            });
                            element.dispatchEvent(mouseUpEvent);
            
                            let clickEvent = new MouseEvent('touchstart', {
                                view: window,
                                bubbles: true,
                                cancelable: true,
                                clientX: mouseX,
                                clientY: mouseY
                            });
                            element.dispatchEvent(clickEvent);
            
                            window.webkit.messageHandlers.elementObserver.postMessage('event_TouchClick1');
                        }
            
                        window.webkit.messageHandlers.elementObserver.postMessage('event_TouchClick2');
                    });
            
                    window.webkit.messageHandlers.elementObserver.postMessage('创建经过监听完成');
                } else {
                    window.webkit.messageHandlers.elementObserver.postMessage('创建经过监听失败未找到控件');
                }
            })();
            """
            
            webView?.evaluateJavaScript(js) { _, error in
                if let error = error {
                    print("出现监听 注入失败: \(error.localizedDescription)")
                } else {
                    print("出现监听 注入成功 -- 页面状态获取")
                }
            }
        }
        
        private func addUserIconJS() {
            let js = """
                (function () {
                
                  function svgToBase64(svg) {
                    const xml = new XMLSerializer().serializeToString(svg);
                    const encoded = btoa(unescape(encodeURIComponent(xml)));
                    return `data:image/svg+xml;base64,${encoded}`;
                  }
                
                  async function fetchImageToBase64(url) {
                    const res = await fetch(url, { credentials: 'omit' });
                    const blob = await res.blob();
                
                    return await new Promise(resolve => {
                      const reader = new FileReader();
                      reader.onloadend = () => resolve(reader.result);
                      reader.readAsDataURL(blob);
                    });
                  }
                
                  let lastSent = null; // 防止重复发送
                
                  async function processTarget() {
                    const items = Array.from(document.querySelectorAll('[data-navbar-item-index]'));
                    if (!items.length) return;
                
                    const target = items.reduce((a, b) =>
                      parseInt(b.dataset.navbarItemIndex) > parseInt(a.dataset.navbarItemIndex) ? b : a
                    );
                
                    // 1️⃣ 优先 img
                    const imgEl = target.querySelector('img');
                    if (imgEl && imgEl.src) {
                      if (imgEl.src === lastSent) return;
                      lastSent = imgEl.src;
                
                      const base64 = await fetchImageToBase64(imgEl.src);
                      window.webkit?.messageHandlers?.elementObserver?.postMessage({
                        type: 'userImageBase64',
                        text: base64,
                        recalledText: 'img'
                      });
                      return;
                    }
                
                    // 2️⃣ 再 SVG
                    const svg = target.querySelector('span[data-icon="default-contact-refreshed"] svg');
                    if (svg) {
                      const key = svg.outerHTML;
                      if (key === lastSent) return;
                      lastSent = key;
                
                      window.webkit?.messageHandlers?.elementObserver?.postMessage({
                        type: 'userImageBase64',
                        text: svgToBase64(svg),
                        recalledText: 'svg'
                      });
                    }
                  }
                
                  // 🚀 初次执行
                  processTarget();
                
                  // 👀 监听变化
                  const observer = new MutationObserver(() => {
                    processTarget();
                  });
                
                  observer.observe(document.body, {
                    childList: true,
                    subtree: true,
                    attributes: true
                  });
                
                })();
                
                """
            
            webView?.evaluateJavaScript(js) { _, error in
                if let error = error {
                    print("出现监听 注入失败: \(error.localizedDescription)")
                } else {
                    print("出现监听 注入成功 --- 用户头像获取")
                }
            }
        }
    }
}
