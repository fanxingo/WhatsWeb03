import SwiftUI
import UIKit

struct CustomTimePicker: View {
    @Binding var selectedTime: String
    
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    
    private let itemHeight: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                HStack(spacing: 40) {
                    WheelPickerRepresentable(selection: $hour, items: Array(0...23), itemHeight: itemHeight, alignment: .right)
                    WheelPickerRepresentable(selection: $minute, items: Array(0...59), itemHeight: itemHeight, alignment: .left)
                }
            }
        }
        .frame(height: itemHeight * 5)
        .onAppear(perform: parseTime)
        .onChange(of: hour) { _, _ in updateTime() }
        .onChange(of: minute) { _, _ in updateTime() }
    }
    
    private func parseTime() {
        let parts = selectedTime.split(separator: ":").compactMap { Int($0) }
        if parts.count == 2 {
            hour = parts[0]
            minute = parts[1]
        }
    }
    
    private func updateTime() {
        let newTime = String(format: "%02d:%02d", hour, minute)
        if selectedTime != newTime {
            selectedTime = newTime
        }
    }
}

struct WheelPickerRepresentable: UIViewRepresentable {
    @Binding var selection: Int
    let items: [Int]
    let itemHeight: CGFloat
    let alignment: NSTextAlignment
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        
        let container = UIStackView()
        container.axis = .vertical
        container.distribution = .fillEqually
        container.spacing = 0
        
        // 顶部填充 (2个 itemHeight)
        addPadding(to: container)
        
        for item in items {
            let label = UILabel()
            label.text = String(format: "%02d", item)
            label.textAlignment = alignment
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.textColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
            container.addArrangedSubview(label)
            label.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        }
        
        // 底部填充
        addPadding(to: container)
        
        scrollView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 【核心修复】：延迟执行初始滚动，确保布局已完成
        DispatchQueue.main.async {
            let targetY = CGFloat(selection) * itemHeight
            scrollView.setContentOffset(CGPoint(x: 0, y: targetY), animated: false)
        }
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // 当外部 selection 改变时（例如 parseTime 被触发），同步滚动位置
        let targetY = CGFloat(selection) * itemHeight
        if abs(uiView.contentOffset.y - targetY) > 0.5 {
            uiView.setContentOffset(CGPoint(x: 0, y: targetY), animated: true)
        }
        
        // 更新高亮颜色逻辑
        if let stack = uiView.subviews.first as? UIStackView {
            for (index, view) in stack.arrangedSubviews.enumerated() {
                if let label = view as? UILabel {
                    let actualIndex = index - 2 // 减去顶部的 2 个 padding
                    if actualIndex == selection {
                        label.textColor = UIColor(red: 0, green: 184/255, blue: 28/255, alpha: 1)
                        label.font = .systemFont(ofSize: 18, weight: .bold)
                    } else {
                        label.textColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
                        label.font = .systemFont(ofSize: 16, weight: .regular)
                    }
                }
            }
        }
    }
    
    private func addPadding(to stack: UIStackView) {
        for _ in 0..<2 {
            let v = UIView()
            v.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
            stack.addArrangedSubview(v)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: WheelPickerRepresentable
        
        init(_ parent: WheelPickerRepresentable) {
            self.parent = parent
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate { scrollToNearestItem(scrollView) }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            scrollToNearestItem(scrollView)
        }
        
        private func scrollToNearestItem(_ scrollView: UIScrollView) {
            let index = Int(round(scrollView.contentOffset.y / parent.itemHeight))
            let safeIndex = max(0, min(parent.items.count - 1, index))
            let targetY = CGFloat(safeIndex) * parent.itemHeight
            
            // 确保吸附到正中心
            scrollView.setContentOffset(CGPoint(x: 0, y: targetY), animated: true)
            
            if parent.selection != parent.items[safeIndex] {
                DispatchQueue.main.async {
                    self.parent.selection = self.parent.items[safeIndex]
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
    }
}
