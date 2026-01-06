//
//  VideoScreen.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI
import AVFoundation
import Combine
import Photos

struct VideoScreenView : View {
    
    @Environment(\.dismiss) var dismiss
    
    let selectModel: ChatMessageModel
    let pathName: String
    var onComplete: (() -> Void)? = nil
    
    // 视频播放器状态管理
    @StateObject private var playerManager = VideoPlayerManager()
    @State private var controlsTimer: Timer?
    
    var body: some View {
        VStack(spacing: 16) {
            // 顶部导航
            HStack {
                Button(action: { dismiss() }) {
                    Image("select_view_icon1")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
                Spacer()
                CustomText(
                    text: selectModel.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 16,
                    colorHex: "#FFFFFF"
                )
                Spacer()
                Button(action: {
                    saveVideoToAlbum()
                }) {
                    Image("select_view_icon2")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            
            Spacer()
            if playerManager.isLoading {
                // 加载状态显示
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    CustomText(
                        text: "Loading video...".localized(),
                        fontName: Constants.FontString.medium,
                        fontSize: 16,
                        colorHex: "#FFFFFF"
                    )
                    .padding(.top, 16)
                }
                .frame(height: 300)
                
            } else {
                if let player = playerManager.player {
                    VideoPlayerView(player: player)
                        .frame(height: 400)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                }
            }
            Spacer()
            
            HStack{
                Spacer()
                Button(action: {
                    onComplete?()
                }) {
                    Image("select_view_icon3")
                        .resizable()
                        .frame(width: 34, height: 34)
                }
            }
            .padding(.horizontal,16)
            
            HStack{
                Button(action: togglePlayPause) {
                    Image(playerManager.isPlaying ? "video_icon1" : "video_icon2")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                .disabled(playerManager.player == nil)
                
                VStack(spacing:0){
                    HStack{
                        CustomText(
                            text: formatTime(playerManager.currentTime) + "/" + formatTime(playerManager.duration),
                            fontName: Constants.FontString.regular,
                            fontSize: 12,
                            colorHex: "#FFFFFF"
                        )
                        Spacer()
                    }
                    ProgressSlider(
                        value: $playerManager.currentTime,
                        range: 0...max(playerManager.duration, 0.1),
                        isSeeking: $playerManager.isSeeking,
                        onSeek: { time in
                            playerManager.seek(to: time)
                        }
                    )
                }
            }
            .padding(.leading,20)
            .padding(.trailing,50)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .modifier(ToastModifier())
        .onAppear {
            loadVideo()
        }
        .onDisappear {
            playerManager.cleanup()
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            controlsTimer?.invalidate()
            controlsTimer = nil
        }
    }
    
    // MARK: - 视频加载
    private func loadVideo() {
        playerManager.isLoading = true

        let filePath = FileDefManager.getFileName(contentName: selectModel.content, dicName: pathName)
        
        // 检查文件是否存在
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath) {
            showError(message: "Video file does not exist".localized())
            return
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        // 检查文件是否可读
        do {
            let readable = try fileURL.checkResourceIsReachable()
            if !readable {
                showError(message: "The video file is unreadable.".localized())
                return
            }
        } catch {
            showError(message: "Video file inaccessible".localized())
            return
        }
        
        // 初始化播放器
        playerManager.initializePlayer(with: fileURL) { success, error in
            DispatchQueue.main.async {
                playerManager.isLoading = false
                if !success {
                    if let error = error {
                        showError(message: "Playback failed".localized())
                    } else {
                        showError(message: "Unable to play video format".localized())
                    }
                }
            }
        }
    }
    
    // MARK: - 播放控制
    private func togglePlayPause() {
        playerManager.togglePlayPause()
    }
    
    // MARK: - 错误处理
    private func showError(message: String) {
        playerManager.isLoading = false
        ToastManager.shared.showToast(message: message)
    }
    
    // MARK: - 清理资源
    private func cleanup() {
        playerManager.cleanup()
        controlsTimer?.invalidate()
        controlsTimer = nil
    }
    
    // MARK: - 时间格式化
    private func formatTime(_ time: Double) -> String {
        guard !time.isNaN, !time.isInfinite, time >= 0 else { return "00:00" }
        
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - 保存视频到相册
    private func saveVideoToAlbum() {
        let filePath = FileDefManager.getFileName(
            contentName: selectModel.content,
            dicName: pathName
        )

        guard FileManager.default.fileExists(atPath: filePath) else {
            ToastManager.shared.showToast(message: "Video file does not exist".localized())
            return
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    ToastManager.shared.showToast(message: "No photo album access".localized())
                }
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        ToastManager.shared.showToast(message: "Saved to album".localized())
                    } else {
                        ToastManager.shared.showToast(
                            message: "Save failed".localized()
                        )
                    }
                }
            }
        }
    }
}

// MARK: - 视频播放器管理器
class VideoPlayerManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isSeeking = false
    @Published var isLoading = false
    
    private var timeObserver: Any?
    private var playerItem: AVPlayerItem?
    
    func initializePlayer(with url: URL, completion: @escaping (Bool, Error?) -> Void) {
        cleanup()
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.playerItem = playerItem
        
        // 检查视频是否可播放
        asset.loadValuesAsynchronously(forKeys: ["playable", "duration"]) { [weak self] in
            guard let self = self else { return }
            
            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            
            DispatchQueue.main.async {
                if status == .loaded {
                    // 获取视频时长
                    let duration = asset.duration
                    self.duration = duration.seconds
                    
                    // 创建播放器
                    self.player = AVPlayer(playerItem: playerItem)
                    
                    // 添加时间观察者
                    self.addTimeObserver()
                    
                    // 添加播放结束观察者
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(self.playerDidFinishPlaying),
                        name: .AVPlayerItemDidPlayToEndTime,
                        object: playerItem
                    )
                    
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        }
    }
    
    private func addTimeObserver() {
        guard let player = player else { return }
        
        // 移除已有的观察者
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        // 添加新的观察者
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, !self.isSeeking else { return }
            self.currentTime = time.seconds
        }
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func seek(to time: Double) {
        guard let player = player else { return }
        let targetTime = CMTime(seconds: min(max(time, 0), duration), preferredTimescale: 600)
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentTime = targetTime.seconds
    }
    
    func seek(seconds: Double) {
        guard let player = player else { return }
        let newTime = currentTime + seconds
        seek(to: newTime)
    }
    
    @objc private func playerDidFinishPlaying() {
        isPlaying = false
        seek(to: 0)
    }
    
    func cleanup() {
        if let observer = timeObserver, let player = player {
            player.removeTimeObserver(observer)
        }
        player?.pause()
        player = nil
        // 只移除针对 playerItem 的通知观察者
        if let item = playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
        }
        playerItem = nil
        timeObserver = nil
        currentTime = 0
        duration = 0
        isPlaying = false
        isSeeking = false
    }
}

// MARK: - 自定义视频播放器视图
struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = player
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) {
        // 更新播放器
        if uiView.player !== player {
            uiView.player = player
        }
    }
    
    static func dismantleUIView(_ uiView: PlayerView, coordinator: ()) {
        if let player = uiView.player {
            player.pause()
        }
        // 确保 AVPlayerLayer 也被清空
        uiView.player = nil
    }
}

class PlayerView: UIView {
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

// MARK: - 自定义进度条滑块
struct ProgressSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    @Binding var isSeeking: Bool
    let onSeek: (Double) -> Void
    
    @State private var lastValue: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景轨道
                Rectangle()
                    .fill(Color(hex: "#A9A9A9"))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                // 进度轨道
                Rectangle()
                    .fill(Color(hex: "#71FF89"))
                    .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, height: 3)
                    .cornerRadius(2)
                
                // 拖动按钮
                Circle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
                    .position(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, y: 8)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        if !isSeeking {
                            isSeeking = true
                            lastValue = value
                        }
                        
                        let locationX = max(0, min(gesture.location.x, geometry.size.width))
                        let percentage = locationX / geometry.size.width
                        let newValue = range.lowerBound + Double(percentage) * (range.upperBound - range.lowerBound)
                        value = min(max(newValue, range.lowerBound), range.upperBound)
                    }
                    .onEnded { _ in
                        onSeek(value)
                        isSeeking = false
                    }
            )
        }
        .frame(height: 20)
    }
}

    
