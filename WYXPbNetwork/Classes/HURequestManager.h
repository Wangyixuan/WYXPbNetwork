//
//  HURequestManager.h
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import <Foundation/Foundation.h>
#import "HURequestEngine.h"

@class ZBConfig;
NS_ASSUME_NONNULL_BEGIN

@interface HURequestManager : NSObject

/**
 *  公共配置方法
 *
 *  @param block           请求配置  Block
 */
+ (void)setupBaseConfig:(void(^_Nullable)(HUConfig * _Nullable config))block;

/**
 *  插件机制
 *
 *  自定义 请求 处理逻辑的方法
 *  @param requestHandler        处理请求前的逻辑 Block
 */
+ (void)setRequestProcessHandler:(HURequestProcessBlock _Nullable )requestHandler;
/**
 *  插件机制
 *
 *  自定义 响应 处理逻辑的方法
 *  @param responseHandler       处理响应结果的逻辑 Block
 */
+ (void)setResponseProcessHandler:(HUResponseProcessBlock _Nullable )responseHandler;
/**
 *  插件机制
 *
 *  自定义 错误 处理逻辑的方法
 *  @param errorHandler          处理响应结果的逻辑 Block
 */
+ (void)setErrorProcessHandler:(HUErrorProcessBlock _Nullable )errorHandler;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param target           执行代理的对象
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config target:(id<HUURLRequestDelegate>_Nonnull)target;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config success:(HURequestSuccessBlock _Nullable )success;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param failure          请求失败的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config failure:(HURequestFailureBlock _Nullable )failure;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param finished         请求完成的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config finished:(HURequestFinishedBlock _Nullable )finished;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config  success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         请求完成的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config  success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure finished:(HURequestFinishedBlock _Nullable )finished;

/**
 *  请求方法 进度
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config  progress:(HURequestProgressBlock _Nullable )progress success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure;

/**
 *  请求方法 进度
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         请求完成的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull)config progress:(HURequestProgressBlock _Nullable )progress success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure finished:(HURequestFinishedBlock _Nullable )finished;

/**
 *  批量请求方法
 *
 *  @param config           请求配置  Block
 *  @param target           执行代理的对象
 *  @return identifier      请求标识符
 */
+ (HUBatchRequest *_Nullable)requestBatchWithConfig:(HUBatchRequestConfigBlock _Nonnull )config target:(id<HUURLRequestDelegate>_Nonnull)target;

/**
 *  批量请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         批量请求完成的 Block
 *  @return BatchRequest    批量请求对象
 */
+ (HUBatchRequest *_Nullable)requestBatchWithConfig:(HUBatchRequestConfigBlock _Nonnull )config success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure finished:(HUBatchRequestFinishedBlock _Nullable )finished;

/**
 *  批量请求方法 进度
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         批量请求完成的 Block
 *  @return BatchRequest    批量请求对象
 */
+ (HUBatchRequest *_Nullable)requestBatchWithConfig:(HUBatchRequestConfigBlock _Nonnull )config progress:(HURequestProgressBlock _Nullable )progress success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure finished:(HUBatchRequestFinishedBlock _Nullable )finished;

/**
 *  取消单个请求任务
 *
 *  @param identifier         请求identifier
 */
+ (void)cancelRequest:(NSUInteger)identifier;

/**
 *  取消批量请求任务
 *
 *  @param batchRequest       批量请求对象
 */
+ (void)cancelBatchRequest:(HUBatchRequest *_Nullable)batchRequest;

/**
 *  取消所有请求任务 活跃的请求都会被取消
 */
+ (void)cancelAllRequest;

/**
 *  获取网络状态 是否可用
 */
+ (BOOL)isNetworkReachable;

/**
 *  是否为WiFi网络
 */
+ (BOOL)isNetworkWiFi;

/**
 *  当前网络的状态值，
 *  HUNetworkReachabilityStatusUnknown      表示 `Unknown`，
 *  HUNetworkReachabilityStatusNotReachable 表示 `NotReachable
 *  HUNetworkReachabilityStatusViaWWAN      表示 `WWAN`
 *  HUNetworkReachabilityStatusViaWiFi      表示 `WiFi`
 */
+ (HUNetworkReachabilityStatus)networkReachability;

/**
 *  获取下载文件
 *
 *  @param  key                 一般为请求地址
 *  @return 获取下载文件
 */
+ (NSString *_Nullable)getDownloadFileForKey:(NSString *_Nonnull)key;

/**
 *  获取沙盒默认创建的AppDownload目录
 *
 *  @return Library/Caches/HUKit/AppDownload路径
 */
+ (NSString *_Nonnull)AppDownloadPath;

@end

NS_ASSUME_NONNULL_END
