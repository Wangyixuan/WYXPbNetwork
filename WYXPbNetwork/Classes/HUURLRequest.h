//
//  HUURLRequest.h
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import <Foundation/Foundation.h>
#import "HURequestConst.h"
@class HUUploadData;

NS_ASSUME_NONNULL_BEGIN

@interface HUURLRequest : NSObject

#pragma mark - 配置请求
/**
 *  用于标识不同类型的request状态
 */
@property (nonatomic,assign) HUApiType apiType;

/**
 *  用于标识不同类型的request
 */
@property (nonatomic,assign) HUMethodType methodType;

/**
 *  操作状态
 */
@property (nonatomic,assign) HUDownloadState  downloadState;

/**
 *  请求参数的类型
 */
@property (nonatomic,assign) HURequestSerializerType requestSerializer;

/**
 *  响应数据的类型
 */
@property (nonatomic,assign) HUResponseSerializerType responseSerializer;

/**
 *  接口(服务器地址)
 *  server 优先级大于 baseServer
 */
@property (nonatomic,copy) NSString *server;

/**
 *  接口(路径)
 */
@property (nonatomic,copy) NSString *url;

/**
 *  提供给外部配置参数使用
 */
@property (nonatomic,strong,nullable) id parameters;

/**
 *  添加请求头
 */
@property (nonatomic,strong,nullable) NSDictionary *headers;

/**
 *  过滤parameters 里的随机参数
 */
@property (nonatomic,strong,nullable) NSArray *filtrationCacheKey;

/**
 *  设置超时时间
 */
@property (nonatomic,assign) NSTimeInterval timeoutInterval;

/**
 *  请求失败,设置自动重试 请求次数 默认是0.
 */
@property (nonatomic,assign) NSUInteger retryCount;

/**
 *  当前请求的信息，可以用来区分具有相同上下文的请求
 */
@property (nonatomic,strong,nullable) NSDictionary *userInfo;

/**
 *  是否使用 公共配置的 服务器 默认YES
 *  只在请求设置时生效
 */
@property (nonatomic,assign) BOOL isBaseServer;

/**
 *  是否使用 公共配置的 参数 默认YES
 *  只在请求设置时生效
 */
@property (nonatomic,assign) BOOL isBaseParameters;

/**
 *  是否使用 公共配置的  请求头 默认YES
 *  只在请求设置时生效
 */
@property (nonatomic,assign) BOOL isBaseHeaders;

#pragma mark - 获取信息
/**
 *  NSURLSessionTask对象
 */
@property (nonatomic,strong) NSURLSessionTask *_Nullable  task;

/**
 *  HUURLRequest对象唯一标识符
 */
@property (nonatomic,assign) NSUInteger identifier;

/**
 *  缓存key  读取缓存 返回
 */
@property (nonatomic,copy,readonly) NSString *cacheKey;

/**
 *  缓存路径文件 读取沙盒缓存返回，内存缓存无
 */
@property (nonatomic,copy,readonly) NSString *filePath;

/**
 *  是否使用了缓存 只有得到响应数据时 才是准确的
 */
@property (nonatomic,assign,readonly) BOOL isCache;

/**
 *  获取 服务器响应信息
 */
@property (nullable, copy,readonly) NSURLResponse *response;

#pragma mark - 内部调用
@property (nonatomic,assign) BOOL consoleLog;
@property (nonatomic,assign) BOOL isRequestSerializer;
@property (nonatomic,assign) BOOL isResponseSerializer;
/**
 *  为上传请求提供数据
 */
@property (nonatomic,strong,nullable) NSMutableArray<HUUploadData *> *uploadDatas;
@property (nonatomic, weak, readonly, nullable) id<HUURLRequestDelegate> delegate;

@property (nonatomic, copy, readonly, nullable) HURequestSuccessBlock successBlock;

@property (nonatomic, copy, readonly, nullable) HURequestFailureBlock failureBlock;

@property (nonatomic, copy, readonly, nullable) HURequestFinishedBlock finishedBlock;

@property (nonatomic, copy, readonly, nullable) HURequestProgressBlock progressBlock;

- (void)cleanAllCallback;

#pragma mark - 上传请求参数
//============================================================
- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;
@end

#pragma mark - HUBatchRequest

@interface HUBatchRequest : NSObject

/**
 *  请求url 列队容器
 */
@property (nonatomic, strong , nullable) NSMutableArray<HUURLRequest *> * requestArray;

/**
 *  响应内容 列队容器 （成功回调返回）
 */
@property (nonatomic, strong , readonly) NSMutableArray<id> *responseArray;

- (void)onFinishedRequest:(HUURLRequest*)request response:(id)responseObject error:(NSError *)error finished:(HUBatchRequestFinishedBlock _Nullable )finished;

@end

#pragma mark - HUUploadData
/**
 *  上传文件数据的类
 */
@interface HUUploadData : NSObject

/**
 *  文件对应服务器上的字段
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy, nullable) NSString *fileName;

/**
 *  图片文件的类型,例:png、jpeg....
 */
@property (nonatomic, copy, nullable) NSString *mimeType;

/**
 *  The data to be encoded and appended to the form data, and it is prior than `fileURL`.
 */
@property (nonatomic, strong, nullable) NSData *fileData;

/**
 *  The URL corresponding to the file whose content will be appended to the form, BUT, when the `fileData` is assigned，the `fileURL` will be ignored.
 */
@property (nonatomic, strong, nullable) NSURL *fileURL;

//注意:“fileData”和“fileURL”中的任何一个都不应该是“nil”，“fileName”和“mimeType”都必须是“nil”，或者同时被分配，

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData;
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;

@end

@interface HUConfig : NSObject

/**
 *  基础URL 域名
*/
@property (nonatomic, copy, nullable) NSString *baseServer;

/**
 *  参数
*/
@property (nonatomic, strong, nullable) NSDictionary *parameters;

/**
 *  请求头
*/
@property (nonatomic, strong, nullable) NSDictionary *headers;

/**
 *  请求的信息，可以用来本地注释和判断使用，不会传给服务器
*/
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

/**
 *  过滤parameters 里的随机参数
 */
@property (nonatomic, strong, nullable) NSArray *filtrationCacheKey;
/**
 *  超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 *  是否开启打印控制台log
 */
@property (nonatomic, assign) BOOL consoleLog;

/**
 *  请求参数的类型
 */
@property (nonatomic, assign) HURequestSerializerType requestSerializer;

/**
 *  响应数据的类型
 */
@property (nonatomic, assign) HUResponseSerializerType responseSerializer;

/**
 *  请求失败,设置自动重试 请求次数 默认是0.
 */
@property (nonatomic, assign) NSUInteger retryCount;

/**
 *  添加响应数据 内容类型
 */
@property (nonatomic, strong, nullable)NSArray *responseContentTypes;

//===========内部调用===============
@property (nonatomic, assign) BOOL isRequestSerializer;
@property (nonatomic, assign) BOOL isResponseSerializer;
@end

NS_ASSUME_NONNULL_END
