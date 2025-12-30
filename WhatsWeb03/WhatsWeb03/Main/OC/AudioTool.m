//
//  AudioTool.m
//  MessageBackup
//
//  Created by 朱威 on 2024/9/12.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import <FFmpegKit/FFmpegKit.h>

@implementation AudioTool

+ (instancetype)sharedInstance {
    static AudioTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)audioDurationForFileAtPath:(NSString *)filePath completion:(void(^)(NSTimeInterval duration))completion {
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:audioURL options:nil];
    
    // 异步计算音频时长
    [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"duration" error:&error];
        
        if (status == AVKeyValueStatusLoaded) {
            CMTime audioDuration = asset.duration;
            NSTimeInterval durationInSeconds = CMTimeGetSeconds(audioDuration);
            if (completion) {
                completion(durationInSeconds);
            }
        } else {
            if (completion) {
                completion(0); // 返回 0 代表出错或无法获取
            }
        }
    }];
}
// 将 Opus 文件转换为 MP3 文件
- (void)convertOpusToMp3:(NSString *)opusFilePath completion:(void (^)(BOOL success,NSString *filePath, NSError *error))completion {
    NSString *fileName = [[opusFilePath lastPathComponent] stringByDeletingPathExtension];
    NSString *outputMp3Path = [[opusFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", fileName]];
    self.mp3FilePath = outputMp3Path;

    if ([[NSFileManager defaultManager] fileExistsAtPath:outputMp3Path]) {
        NSLog(@"MP3 file already exists, skipping conversion.");
        if (completion) {
            completion(YES,outputMp3Path, nil);
        }
        return;
    }

    // FFmpeg 转换命令
    NSString *ffmpegCommand = [NSString stringWithFormat:@"-i %@ -acodec libmp3lame -q:a 2 %@", opusFilePath, outputMp3Path];

    // 异步执行 FFmpeg 命令
    [FFmpegKit executeAsync:ffmpegCommand withCompleteCallback:^(FFmpegSession *session) {
        ReturnCode *returnCode = [session getReturnCode];
        if ([returnCode isValueSuccess]) {
            NSLog(@"Opus to MP3 conversion completed successfully.");
            if (completion) {
                completion(YES,outputMp3Path, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"com.tool.AudioTool"
                                                 code:[returnCode getValue]
                                             userInfo:@{NSLocalizedDescriptionKey: @"Conversion failed"}];
            if (completion) {
                completion(NO,@"", error);
            }
        }
    }];
}

// 播放 Opus 文件，若存在对应 MP3 则播放 MP3，若不存在则转换后播放
- (void)playOpusFileAtPath:(NSString *)opusFilePath
              playProgress:(AudioPlayProgressBlock)playProgressBlock {
    
    // 暂停正在播放的音频
    if (self.audioPlayer && self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
    }
    
    NSString *fileName = [[opusFilePath lastPathComponent] stringByDeletingPathExtension];
    NSString *mp3FilePath = [[opusFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", fileName]];
    self.mp3FilePath = mp3FilePath;

    if ([[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath]) {
        NSLog(@"MP3 file already exists, playing it.");
        [self playWithProgressBlock:playProgressBlock];
    } else {
        NSLog(@"MP3 file not found, converting Opus to MP3.");
        [self convertOpusToMp3:opusFilePath completion:^(BOOL success,NSString *filePath, NSError *error) {
            if (success) {
                [self playWithProgressBlock:playProgressBlock];
            } else {
                NSLog(@"Error during conversion: %@", error.localizedDescription);
            }
        }];
    }
}

// 播放 MP3 文件并返回播放状态和进度
- (void)playWithProgressBlock:(AudioPlayProgressBlock)playProgressBlock {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;

    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:&sessionError];

    [session setActive:YES error:&sessionError];

    if (sessionError) {
        NSLog(@"AudioSession error: %@", sessionError);
    }
    
    if (!self.audioPlayer) {
        NSURL *mp3URL = [NSURL fileURLWithPath:self.mp3FilePath];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:&error];
        if (error) {
            NSLog(@"Error initializing audio player: %@", error.localizedDescription);
            return;
        }
        [self.audioPlayer prepareToPlay];
    }
    
    [self.audioPlayer play];

    if (playProgressBlock) {
        playProgressBlock(YES, NO, 0,self.audioPlayer.currentTime);
    }

    // 使用定时器更新播放进度
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.audioPlayer.isPlaying) {
            if (playProgressBlock) {
                float progress = weakSelf.audioPlayer.currentTime / weakSelf.audioPlayer.duration;
                playProgressBlock(YES, NO, progress,weakSelf.audioPlayer.currentTime);
            }
        } else {
            if (playProgressBlock) {
                playProgressBlock(NO, YES, 1.0,weakSelf.audioPlayer.currentTime);
            }
            [timer invalidate];
        }
    }];
}

// 提供一个单独的转换方法，提前转换
- (void)convertOpusFileAtPath:(NSString *)opusFilePath completion:(void (^)(BOOL success,NSString *filePath, NSError *error))completion {
    [self convertOpusToMp3:opusFilePath completion:completion];
}

// 暂停播放
- (void)pause {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
    }
}

// 停止播放
- (void)stop {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0;
    }
}

#pragma mark - Prepare MP3 Only (No Playback)

- (void)prepareMp3ForOpusAtPath:(NSString *)opusFilePath
                     completion:(void (^)(BOOL success, NSString *mp3FileName, NSError *error))completion {

    if (opusFilePath.length == 0) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"com.tool.AudioTool"
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey:@"Opus file path is empty"}];
            completion(NO, @"", error);
        }
        return;
    }

    NSString *fileName = [[opusFilePath lastPathComponent] stringByDeletingPathExtension];
    NSString *mp3FileName = [NSString stringWithFormat:@"%@.mp3", fileName];
    NSString *mp3FilePath = [[opusFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:mp3FileName];

    // 如果 MP3 已存在，直接返回文件名
    if ([[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath]) {
        if (completion) {
            completion(YES, mp3FileName, nil);
        }
        return;
    }

    // 不存在则先转换
    [self convertOpusToMp3:opusFilePath completion:^(BOOL success, NSString *filePath, NSError *error) {
        if (success) {
            if (completion) {
                completion(YES, mp3FileName, nil);
            }
        } else {
            if (completion) {
                completion(NO, @"", error);
            }
        }
    }];
}




@end


