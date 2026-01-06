//
//  MbDoubleOpenManager.h
//  MessageBackup
//
//  Created by 朱威 on 2025/3/11.
//

#import <Foundation/Foundation.h>

#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self;

#define SANDBOX_WEBKIT_DIR [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"SavedWebKit"]
#define SANDBOX_WEBKIT_IMG [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"SavedWebKitImg"]

#define SANDBOX_WEBKIT_Whats_Def [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"DefData"]

NS_ASSUME_NONNULL_BEGIN

@interface MbDoubleOpenManager : NSObject

+ (instancetype)sharedManager;

/// 保存当前 WebKit 缓存数据到沙盒
- (void)saveCurrentWebKitDataWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion;
/// 从沙盒恢复指定的 WebKit 缓存数据
- (void)restoreWebKitDataWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion;
/// 获取已保存的 WebKit 缓存列表
- (NSArray<NSString *> *)getSavedCacheList;
/// 删除指定的 WebKit 缓存
- (void)deleteSavedWebKitDataWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion;
///清除缓存信息
- (void)clearWebKitDataWithAllData:(void(^)(BOOL success))completion;

- (void)clearWebKitAndCaches;

- (void)saveDef:(NSString *)defIds isDel:(BOOL)isDel;
- (void)delDef:(NSString *)defIds;
- (void)restoreDef:(NSString *)identifier completion:(void (^)(BOOL success))completion;
- (BOOL)checkIfFolderExists:(NSString *)folderName;
- (void)clearWebDataStore:(void (^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
