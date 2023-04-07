//
//  HURequestConst.h
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#ifndef HURequestConst_h
#define HURequestConst_h
@class HUURLRequest,HUBatchRequest;

/**
 用于标识不同类型的请求
 默认为重新请求.  default:HURequestTypeRefresh
 */
typedef NS_ENUM(NSInteger,HUApiType) {
    /**
     重新请求:  不读取缓存，不存储缓存
     没有缓存需求的，单独使用
     */
    HURequestTypeRefresh,
    /**
     重新请求:  不读取缓存，但存储缓存
     可以与 HURequestTypeCache 配合使用
     */
    HURequestTypeRefreshAndCache,
    /**
     读取缓存:  有缓存,读取缓存--无缓存，重新请求并存储缓存
     可以与HURequestTypeRefreshAndCache 配合使用
     */
    HURequestTypeCache,
    /**
     重新请求： 上拉加载更多业务，不读取缓存，不存储缓存
     用于区分业务 可以不用
     */
    HURequestTypeRefreshMore,
    /**
     重新请求:  不读取缓存，不存储缓存.同一请求重复请求，请求结果没有响应的时候，使用第一次请求结果
     如果请求结果响应了，会终止此过程
     */
    HURequestTypeKeepFirst,
    /**
     重新请求:   不读取缓存，不存储缓存.同一请求重复请求，请求结果没有响应的时候，使用最后一次请求结果
     如果请求结果响应了，会终止此过程
     */
    HURequestTypeKeepLast,
};
/**
 HTTP 请求类型.
 默认为GET请求.   default:HUMethodTypeGET
 */
typedef NS_ENUM(NSInteger,HUMethodType) {
    /**GET请求*/
    HUMethodTypeGET,
    /**POST请求*/
    HUMethodTypePOST,
    /**Upload请求*/
    HUMethodTypeUpload,
    /**DownLoad请求*/
    HUMethodTypeDownLoad,
    /**PUT请求*/
    HUMethodTypePUT,
    /**PATCH请求*/
    HUMethodTypePATCH,
    /**DELETE请求*/
    HUMethodTypeDELETE
};
/**
 请求参数的格式.
 默认为JSON.   default:HUJSONRequestSerializer
 */
typedef NS_ENUM(NSUInteger, HURequestSerializerType) {
    /** 设置请求参数为JSON格式*/
    HUJSONRequestSerializer,
    /** 设置请求参数为二进制格式*/
    HUHTTPRequestSerializer,
};
/**
 返回响应数据的格式.
 默认为JSON.  default:HUJSONResponseSerializer
 */
typedef NS_ENUM(NSUInteger, HUResponseSerializerType) {
    /** 设置响应数据为JSON格式*/
    HUJSONResponseSerializer,
    /** 设置响应数据为二进制格式*/
    HUHTTPResponseSerializer
};
/**
 操作状态
 */
typedef NS_ENUM(NSUInteger, HUDownloadState) {
    /** 开始请求*/
    HUDownloadStateStart,
    /** 暂停请求*/
    HUDownloadStateStop,
};
/**
 *  当前网络的状态值，
 */
typedef NS_ENUM(NSInteger, HUNetworkReachabilityStatus) {
    /** Unknown*/
    HUNetworkReachabilityStatusUnknown          = -1,
    /** NotReachable*/
    HUNetworkReachabilityStatusNotReachable     = 0,
    /** WWAN*/
    HUNetworkReachabilityStatusViaWWAN          = 1,
    /** WiFi*/
    HUNetworkReachabilityStatusViaWiFi          = 2,
};

//==================================================
/** 请求配置的Block */
typedef void (^HURequestConfigBlock)(HUURLRequest * _Nullable request);
/** 请求成功的Block */
typedef void (^HURequestSuccessBlock)(id _Nullable responseObject,HUURLRequest * _Nullable request);
/** 请求失败的Block */
typedef void (^HURequestFailureBlock)(NSError * _Nullable error);
/** 请求进度的Block */
typedef void (^HURequestProgressBlock)(NSProgress * _Nullable progress);
/** 请求完成的Block 无论成功和失败**/
typedef void (^HURequestFinishedBlock)(id _Nullable responseObject,NSError * _Nullable error,HUURLRequest * _Nullable request);
//==================================================
/** 批量请求配置的Block */
typedef void (^HUBatchRequestConfigBlock)(HUBatchRequest * _Nonnull batchRequest);
/** 批量请求 全部完成的Block 无论成功和失败*/
typedef void (^HUBatchRequestFinishedBlock)(NSArray * _Nullable responseObjects,NSArray<NSError *> * _Nullable errors,NSArray<HUURLRequest *> *_Nullable requests);
//==================================================
/** 请求 处理逻辑的方法 Block */
typedef void (^HURequestProcessBlock)(HUURLRequest * _Nullable request,id _Nullable __autoreleasing * _Nullable setObject);
/** 响应 处理逻辑的方法 Block */
typedef id _Nullable (^HUResponseProcessBlock)(HUURLRequest * _Nullable request, id _Nullable responseObject, NSError * _Nullable __autoreleasing * _Nullable error);
/** 错误 处理逻辑的方法 Block */
typedef void (^HUErrorProcessBlock)(HUURLRequest * _Nullable request, NSError * _Nullable error);
//==================================================
/** Request协议*/
@protocol HUURLRequestDelegate <NSObject>
@required
/** 请求成功的 代理方法*/
- (void)requestSuccess:(HUURLRequest *_Nullable)request responseObject:(id _Nullable)responseObject ;
@optional
/** 请求失败的 代理方法*/
- (void)requestFailed:(HUURLRequest *_Nullable)request error:(NSError *_Nullable)error;
/** 请求进度的 代理方法*/
- (void)requestProgress:(NSProgress * _Nullable)progress;
/** 请求完成的 代理方法 无论成功和失败**/
- (void)requestFinished:(HUURLRequest *_Nullable)request responseObject:(id _Nullable)responseObject error:(NSError *_Nullable)error;
/** 批量请求 全部完成的 代理方法，无论成功和失败*/
- (void)requestBatchFinished:(NSArray<HUURLRequest *> *_Nullable)requests responseObjects:(NSArray * _Nullable) responseObjects errors:(NSArray<NSError *> * _Nullable)errors;
@end

#endif /* HURequestConst_h */
