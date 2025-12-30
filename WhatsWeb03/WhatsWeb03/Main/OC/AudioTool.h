//
//  AudioTool.h
//  MessageBackup
//
//  Created by 朱威 on 2024/9/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface AudioTool : NSObject
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSString *mp3FilePath;


// 用于播放状态和进度的 Block
typedef void(^AudioPlayProgressBlock)(BOOL isPlaying, BOOL didFinishPlaying, float playProgress, NSTimeInterval currentTime);

// 单例实例
+ (instancetype)sharedInstance;

// 转换 Opus 到 MP3 文件
- (void)convertOpusToMp3:(NSString *)opusFilePath completion:(void (^)(BOOL success,NSString *filePath, NSError *error))completion;

// 播放 Opus 文件，若存在对应 MP3，则播放 MP3，若不存在则转换再播放
- (void)playOpusFileAtPath:(NSString *)opusFilePath
              playProgress:(AudioPlayProgressBlock)playProgressBlock;
- (void)audioDurationForFileAtPath:(NSString *)filePath completion:(void(^)(NSTimeInterval duration))completion;
// 控制暂停、停止等操作
- (void)pause;
- (void)stop;

- (void)prepareMp3ForOpusAtPath:(NSString *)opusFilePath
                     completion:(void (^)(BOOL success, NSString *mp3Path, NSError *error))completion;
@end
NS_ASSUME_NONNULL_END
