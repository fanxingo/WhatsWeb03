//
//  MbDoubleOpenManager.m
//  MessageBackup
//
//  Created by 朱威 on 2025/3/11.
//

#import "MbDoubleOpenManager.h"
#import <WebKit/WebKit.h>




@implementation MbDoubleOpenManager

+ (instancetype)sharedManager {
    static MbDoubleOpenManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [[NSFileManager defaultManager] createDirectoryAtPath:SANDBOX_WEBKIT_DIR
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    });
    return manager;
}

/// 获取 Library 目录下 WebKit 相关缓存路径
- (NSArray<NSString *> *)webKitCacheDirectories {
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    return @[
        [libraryPath stringByAppendingPathComponent:@"Cookies"],
        [libraryPath stringByAppendingPathComponent:@"Caches"],
        [libraryPath stringByAppendingPathComponent:@"WebKit"]
    ];
}


/// **保存当前 WebKit 数据**
- (void)saveCurrentWebKitDataWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *savePath = [SANDBOX_WEBKIT_DIR stringByAppendingPathComponent:identifier];
        if ([fileManager fileExistsAtPath:savePath]) {
            completion(NO);
            return;
        }
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        
        for (NSString *path in [self webKitCacheDirectories]) {
            NSString *destPath = [savePath stringByAppendingPathComponent:path.lastPathComponent];
            if ([fileManager fileExistsAtPath:path]) {
                [fileManager copyItemAtPath:path toPath:destPath error:nil];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(YES);
        });
    });
}

/// **恢复 WebKit 缓存**
- (void)restoreWebKitDataWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *savePath = [SANDBOX_WEBKIT_DIR stringByAppendingPathComponent:identifier];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:savePath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO);
            });
            return;
        }
        NSLog(@"恢复前目录：%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] error:nil]);
        for (NSString *path in [self webKitCacheDirectories]) {
            NSString *sourcePath = [savePath stringByAppendingPathComponent:path.lastPathComponent];
            if ([fileManager fileExistsAtPath:sourcePath]) {
                [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"恢复后目录：%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] error:nil]);
            if (completion) completion(YES);
        });
    });
}

/// **获取已保存的缓存列表**
- (NSArray<NSString *> *)getSavedCacheList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *savedFiles = [fileManager contentsOfDirectoryAtPath:SANDBOX_WEBKIT_DIR error:nil];
    return savedFiles ? savedFiles : @[];
}
/// **删除已保存的 WebKit 缓存**
- (void)deleteSavedWebKitDataWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *savePath = [SANDBOX_WEBKIT_DIR stringByAppendingPathComponent:identifier];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:savePath]) {
            [fileManager removeItemAtPath:savePath error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO);
            });
        }
    });
}

- (void)clearWebKitDataWithAllData:(void(^)(BOOL success))completion{
    WeakSelf(weakSelf);
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                 modifiedSince:dateFrom
                                             completionHandler:^{
        NSLog(@"%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] error:nil]);
        [weakSelf clearWebKitAndCaches];
        
        // 延迟 1 秒执行 completion(YES)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) {
                completion(YES);
            }
        });
    }];
}
- (void)clearWebKitAndCaches {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        // 需要清理的目录
        NSArray *directories = @[
            [libraryPath stringByAppendingPathComponent:@"Cookies"],
            [libraryPath stringByAppendingPathComponent:@"WebKit"],
            [libraryPath stringByAppendingPathComponent:@"Caches"]
        ];
        // 遍历目录删除
        for (NSString *path in directories) {
            if ([fileManager fileExistsAtPath:path]) {
                NSError *error = nil;
                if ([path.lastPathComponent isEqualToString:@"Caches"]) {
                    // 只删除 Caches 目录下的所有内容，不删除 Caches 目录本身
                    NSArray *subFiles = [fileManager contentsOfDirectoryAtPath:path error:nil];
                    for (NSString *subFile in subFiles) {
                        NSString *subFilePath = [path stringByAppendingPathComponent:subFile];
                        [fileManager removeItemAtPath:subFilePath error:nil];
                    }
                } else {
                    // 删除整个 Cookies 和 WebKit 目录
                    [fileManager removeItemAtPath:path error:&error];
                }
                if (error) {
                    NSLog(@"❌ 无法删除 %@，错误: %@", path, error.localizedDescription);
                } else {
                    NSLog(@"✅ 已删除 %@", path);
                }
            }
        }
        // 再次打印 Library 目录下的所有文件
        NSError *printError = nil;
        NSArray *libraryContents = [fileManager contentsOfDirectoryAtPath:libraryPath error:&printError];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (printError) {
                NSLog(@"❌ 获取 Library 目录失败: %@", printError.localizedDescription);
            } else {
                NSLog(@"📂 清理后 Library 目录内容: %@", libraryContents);
            }
        });
    });
}


- (void)saveDef:(NSString *)defIds isDel:(BOOL)isDel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *savePath = [SANDBOX_WEBKIT_Whats_Def stringByAppendingPathComponent:defIds];
        if ([fileManager fileExistsAtPath:savePath]) {
            if (isDel) {
                [fileManager removeItemAtPath:savePath error:nil];
            }else{
                return;
            }
        }
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        for (NSString *path in [self webKitCacheDirectories]) {
            NSString *destPath = [savePath stringByAppendingPathComponent:path.lastPathComponent];
            if ([fileManager fileExistsAtPath:path]) {
                [fileManager copyItemAtPath:path toPath:destPath error:nil];
            }
        }
    });
}
- (void)delDef:(NSString *)defIds{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *savePath = [SANDBOX_WEBKIT_Whats_Def stringByAppendingPathComponent:defIds];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:savePath]) {
            [fileManager removeItemAtPath:savePath error:nil];
        }
    });
}
- (void)restoreDef:(NSString *)identifier completion:(void (^)(BOOL success))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *savePath = [SANDBOX_WEBKIT_Whats_Def stringByAppendingPathComponent:identifier];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:savePath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO);
            });
            return;
        }
        NSLog(@"恢复前目录：%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] error:nil]);
        for (NSString *path in [self webKitCacheDirectories]) {
            NSString *sourcePath = [savePath stringByAppendingPathComponent:path.lastPathComponent];
            if ([fileManager fileExistsAtPath:sourcePath]) {
                [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"恢复后目录：%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] error:nil]);
            if (completion) completion(YES);
        });
    });
}

- (BOOL)checkIfFolderExists:(NSString *)folderName{
    // 获取 WKWebView 沙盒的 Library/Caches/WebKit 目录
    NSString *webKitFolderPath = SANDBOX_WEBKIT_Whats_Def;
    // 拼接目标文件夹路径
    NSString *targetFolderPath = [webKitFolderPath stringByAppendingPathComponent:folderName];
    // 检查文件夹是否存在
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:targetFolderPath isDirectory:&isDirectory];
    return exists && isDirectory;
}

- (void)clearWebDataStore:(void (^)(BOOL success))completion{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                 modifiedSince:dateFrom
                                             completionHandler:^{
        NSLog(@"%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] error:nil]);
        completion(YES);
    }];
}
@end
