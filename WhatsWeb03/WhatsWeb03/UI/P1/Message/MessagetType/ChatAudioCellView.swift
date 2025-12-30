//
//  ChatAudioCellView.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI
import Combine
import AVFoundation

struct ChatAudioCellView: View {
    let message: ChatMessageModel
    let pathName: String
    let isSelf: Bool

    @ObservedObject private var audioManager = AudioPlayerManager.shared
    @State private var localDuration: Double = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSelf {
                Spacer()
                // 时间在气泡左侧
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
            }

            // 音频气泡
            HStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    // 背景图片
                    Image(isSelf ? "message_icon13" : "message_icon12")
                        .resizable()
                        .frame(width: 90, height: 24)

                    // 前景进度条图片，宽度随进度变化，使用mask实现逐渐显示（从左到右）
                    Image("message_icon11")
                        .resizable()
                        .frame(width: 90, height: 24)
                        .mask(
                            HStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: CGFloat(progressWidth), height: 24)
                                    .animation(.linear(duration: 0.1), value: audioManager.currentTime)
                                Spacer(minLength: 0)
                            }
                        )
                }

                // 剩余时间
                Text(remainingTime)
                    .font(.caption)
                    .foregroundColor(isSelf ? .white : .gray)
            }
            .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
            .background(isSelf ? Color(hex: "#71FF89FF") : Color(hex: "#FFFFFFFF"))
            .cornerRadius(10)
            .fixedSize(horizontal: false, vertical: true)
            .onTapGesture {
                let audioPath = FileDefManager.getFileName(
                    contentName: message.content,
                    dicName: pathName
                )
                let url = URL(fileURLWithPath: audioPath)

                if audioManager.currentPlayingId == message.id {
                    // 点击同一条音频：切换暂停/播放
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play(url: url, id: message.id)
                    }
                } else {
                    // 点击不同音频：停止之前播放，播放当前
                    audioManager.play(url: url, id: message.id)
                }
            }
            .onAppear {
                // 只在未播放时初始化时长
                let audioPath = FileDefManager.getFileName(
                    contentName: message.content,
                    dicName: pathName
                )
                let url = URL(fileURLWithPath: audioPath)
                // 只在第一次出现时读取
                if localDuration == 0 {
                    let asset = AVURLAsset(url: url)
                    let durationSec = CMTimeGetSeconds(asset.duration)
                    if durationSec.isFinite && durationSec > 0 {
                        localDuration = durationSec
                        // 如果当前没有播放任何音频，则设置共享 manager 的 duration
                        if audioManager.currentPlayingId != message.id {
                            audioManager.duration = durationSec
                        }
                    }
                }
            }

            if !isSelf {
                // 时间在气泡右侧
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
                Spacer()
            }
        }
    }

    // 进度条宽度 (图片宽度 90 为满格)
    private var progressWidth: CGFloat {
        guard audioManager.currentPlayingId == message.id, audioManager.duration > 0 else { return 0 }
        // 保证进度条不会超过最大宽度，且播放结束时为90
        let progress = min(max(audioManager.currentTime, 0), audioManager.duration)
        return CGFloat(progress / audioManager.duration) * 90
    }

    // 剩余时间显示（总长度，格式 01'、02'，随播放进度减少）
    private var remainingTime: String {
        // 如果当前音频正在播放，且有有效时长
        if audioManager.currentPlayingId == message.id, audioManager.duration > 0 {
            // 保证currentTime不会超过duration，剩余时间四舍五入到0
            let remaining = max(0, Int(round(audioManager.duration - min(max(audioManager.currentTime, 0), audioManager.duration))))
            let minutes = remaining / 60
            let seconds = remaining % 60
            if minutes > 0 {
                // 只显示分钟，不显示秒
                return String(format: "%02d'", minutes)
            } else {
                // 显示秒
                return String(format: "%02d'", seconds)
            }
        }
        // 未播放时显示音频总长度（优先用本地读取的时长）
        let total = Int(round(localDuration > 0 ? localDuration : audioManager.duration))
        let minutes = total / 60
        let seconds = total % 60
        if total > 0 {
            if minutes > 0 {
                return String(format: "%02d'", minutes)
            } else {
                return String(format: "%02d'", seconds)
            }
        }
        // 默认显示 00'
        return "00'"
    }
}


class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    
    @Published var currentPlayingId: UUID? = nil   // 当前播放音频ID
    @Published var currentTime: Double = 0         // 播放进度
    @Published var duration: Double = 0            // 总时长
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var playerStatusObserver: NSKeyValueObservation?
    
    private init() {}
    
    func play(url: URL, id: UUID) {
        // 如果正在播放别的音频，先停止
        if currentPlayingId != id {
            stop()
        }
        
        currentPlayingId = id

        // 在播放前初始化 duration
        let asset = AVURLAsset(url: url)
        let assetDuration = CMTimeGetSeconds(asset.duration)
        if assetDuration.isFinite && assetDuration > 0 {
            duration = assetDuration
        }
        
        // AVAudioSession
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("AVAudioSession 配置失败: \(error)")
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0

        // 监听播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

        // 监听 playerItem 状态，确保 asset 准备好再添加 timeObserver
        // 保存 observe 返回值，防止其被释放
        playerStatusObserver = playerItem.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            guard let self = self else { return }
            if item.status == .readyToPlay {
                // 再次确保 duration
                let readyDuration = CMTimeGetSeconds(item.asset.duration)
                if readyDuration.isFinite && readyDuration > 0 {
                    self.duration = readyDuration
                }

                // 添加播放进度观察，preferredTimescale: 600
                let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
                self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                    self.currentTime = CMTimeGetSeconds(time)
                }

                self.player?.play()
            }
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        playerStatusObserver = nil
        // 移除播放结束通知
        if let playerItem = player?.currentItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        player = nil
        currentPlayingId = nil
        currentTime = 0
        duration = 0
    }

    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        // 播放结束时精确显示到最后
        if let _ = notification.object as? AVPlayerItem {
            currentTime = duration
            // 延迟一点点再清理currentPlayingId，确保UI看到0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.currentPlayingId = nil
                self.currentTime = 0
                self.duration = 0
            }
        }
    }
    
    var isPlaying: Bool {
        player != nil && player?.timeControlStatus == .playing
    }
}
