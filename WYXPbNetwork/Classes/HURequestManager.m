//
//  HURequestManager.m
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import "HURequestManager.h"
#import "HUCacheManager.h"
#import "HUURLRequest.h"
#import "NSString+HUUTF8Encoding.h"
#import <WYXLanguageUtil/HULanguageUtils.h>

NSString *const _response =@"_response";
NSString *const _isCache =@"_isCache";
NSString *const _cacheKey =@"_cacheKey";
NSString *const _filePath =@"_filePath";
NSString *const hu_downloadTempPath =@"AppTempDownload";
NSString *const hu_downloadPath =@"AppDownload";

@implementation HURequestManager

#pragma mark - 插件
+ (void)setupBaseConfig:(void(^)(HUConfig *config))block{
    HUConfig *config=[[HUConfig alloc]init];
#ifdef DEBUG
    config.consoleLog = YES;
#else
    config.consoleLog = NO;
#endif
    block ? block(config) : nil;
    [[HURequestEngine defaultEngine] setupBaseConfig:config];
}

+ (void)setRequestProcessHandler:(HURequestProcessBlock)requestHandler{
    [HURequestEngine defaultEngine].requestProcessHandler=requestHandler;
}

+ (void)setResponseProcessHandler:(HUResponseProcessBlock)responseHandler{
    [HURequestEngine defaultEngine].responseProcessHandler = responseHandler;
}

+ (void)setErrorProcessHandler:(HUErrorProcessBlock)errorHandler{
    [HURequestEngine defaultEngine].errorProcessHandler=errorHandler;
}

#pragma mark - 配置请求
+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config target:(id<HUURLRequestDelegate>_Nonnull)target{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:nil target:target];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config success:(HURequestSuccessBlock)success{
    return [self requestWithConfig:config progress:nil success:success failure:nil finished:nil];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config failure:(HURequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:nil failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config finished:(HURequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:finished];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock _Nonnull )config  success:(HURequestSuccessBlock _Nullable )success failure:(HURequestFailureBlock _Nullable )failure finished:(HURequestFinishedBlock _Nullable )finished{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:finished];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HURequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:finished target:nil];
}

+ (NSUInteger)requestWithConfig:(HURequestConfigBlock)config progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HURequestFinishedBlock)finished target:(id<HUURLRequestDelegate>)target{
    HUURLRequest *request=[[HUURLRequest alloc]init];
    NSString *netType;
    switch ([HURequestManager networkReachability]) {
        case HUNetworkReachabilityStatusUnknown:
            netType = @"Unknown";
            break;
        case HUNetworkReachabilityStatusNotReachable:
            netType = @"NotReachable";
            break;
        case HUNetworkReachabilityStatusViaWWAN:
            netType = @"WWAN";
            break;
        case HUNetworkReachabilityStatusViaWiFi:
            netType = @"WiFi";
            break;
        default:
            break;
    }
    
    request.headers = @{
        @"country" : @"",
        @"lang" : [HULanguageUtils appleLanguage],
        @"appVersionName" : [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
        @"packageName" : [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"],
        @"appPlatform" : @"2",
        @"brand" : @"Apple",
        @"model":[[UIDevice currentDevice] model],
        @"deviceId":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
        @"sdkInt":[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]],
        @"netQuality":@"",
        @"netType":netType,
//        @"userId":[NSString stringWithFormat:@"%ld",[AMUserData getUserId]],
    };
    config ? config(request) : nil;
    return [self sendRequest:request progress:progress success:success failure:failure finished:finished target:target];
}

#pragma mark - 配置批量请求
+ (HUBatchRequest *)requestBatchWithConfig:(HUBatchRequestConfigBlock)config target:(id<HUURLRequestDelegate>_Nonnull)target{
    return [self requestBatchWithConfig:config progress:nil success:nil failure:nil finished:nil target:target];
}

+ (HUBatchRequest *)requestBatchWithConfig:(HUBatchRequestConfigBlock)config success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HUBatchRequestFinishedBlock)finished{
    return [self requestBatchWithConfig:config progress:nil success:success failure:failure finished:finished];
}

+ (HUBatchRequest *)requestBatchWithConfig:(HUBatchRequestConfigBlock)config progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HUBatchRequestFinishedBlock)finished{
    return [self requestBatchWithConfig:config progress:progress success:success failure:failure finished:finished target:nil];
}

+ (HUBatchRequest *)requestBatchWithConfig:(HUBatchRequestConfigBlock)config progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HUBatchRequestFinishedBlock)finished target:(id<HUURLRequestDelegate>)target{
    HUBatchRequest *batchRequest=[[HUBatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    if (batchRequest.requestArray.count==0)return nil;
    [batchRequest.responseArray removeAllObjects];
    [batchRequest.requestArray enumerateObjectsUsingBlock:^(HUURLRequest *request , NSUInteger idx, BOOL *stop) {
        [batchRequest.responseArray addObject:[NSNull null]];
        [self sendRequest:request progress:progress success:success failure:failure finished:^(id responseObject, NSError *error,HUURLRequest *request) {
            [batchRequest onFinishedRequest:request response:responseObject error:error finished:finished];
        }target:target];
    }];
    return batchRequest;
}

#pragma mark - 发起请求
+ (NSUInteger)sendRequest:(HUURLRequest *)request progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HURequestFinishedBlock)finished target:(id<HUURLRequestDelegate>)target{
    
    if ([request.url isEqualToString:@""]||request.url==nil)return 0;
    
    [self configBaseWithRequest:request progress:progress success:success failure:failure finished:finished target:target];
    
    id obj=nil;
    if ([HURequestEngine defaultEngine].requestProcessHandler) {
        [HURequestEngine defaultEngine].requestProcessHandler(request,&obj);
        if (obj) {
            [self successWithResponse:nil responseObject:obj request:request];
            return 0;
        }
    }
    
    NSURLSessionTask * task=[[HURequestEngine defaultEngine]objectRequestForkey:request.url];
    if (request.apiType==HURequestTypeKeepFirst&&task) {
        return 0;
    }
    if (request.apiType==HURequestTypeKeepLast&&task) {
        [self cancelRequest:task.taskIdentifier];
    }

    NSUInteger identifier=[self startSendRequest:request];
    [[HURequestEngine defaultEngine]setRequestObject:request.task forkey:request.url];
    return identifier;
}

+ (NSUInteger)startSendRequest:(HUURLRequest *)request{
    if (request.methodType==HUMethodTypeUpload) {
       return [self sendUploadRequest:request];
    }else if (request.methodType==HUMethodTypeDownLoad){
       return [self sendDownLoadRequest:request];
    }else{
       return [self sendHTTPRequest:request];
    }
}

+ (NSUInteger)sendUploadRequest:(HUURLRequest *)request{
    return [[HURequestEngine defaultEngine] uploadWithRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(requestProgress:)]) {
            [request.delegate requestProgress:uploadProgress];
        }
        request.progressBlock?request.progressBlock(uploadProgress):nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponse:task.response responseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (NSUInteger)sendHTTPRequest:(HUURLRequest *)request{
    if (request.apiType==HURequestTypeRefresh||request.apiType==HURequestTypeRefreshMore||request.apiType==HURequestTypeKeepFirst||request.apiType==HURequestTypeKeepLast) {
        return [self dataTaskWithHTTPRequest:request];
    }else{
        NSString *key = [self keyWithParameters:request];
        if ([[HUCacheManager sharedInstance]cacheExistsForKey:key]&&request.apiType==HURequestTypeCache){
            [self getCacheDataForKey:key request:request];
            return 0;
        }else{
            return [self dataTaskWithHTTPRequest:request];
        }
    }
}

+ (NSUInteger)dataTaskWithHTTPRequest:(HUURLRequest *)request{
    return [[HURequestEngine defaultEngine]dataTaskWithMethod:request progress:^(NSProgress * _Nonnull HU_progress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(requestProgress:)]) {
            [request.delegate requestProgress:HU_progress];
        }
        request.progressBlock ? request.progressBlock(HU_progress) : nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponse:task.response responseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (NSUInteger)sendDownLoadRequest:(HUURLRequest *)request{
    if (request.downloadState==HUDownloadStateStart) {
        [[HUCacheManager sharedInstance]createDirectoryAtPath:[self AppDownloadPath]];
        return [self downloadStartWithRequest:request];
    }else{
        return [self downloadStopWithRequest:request];
    }
}

+ (NSUInteger)downloadStartWithRequest:(HUURLRequest*)request{
    NSString *AppDownloadTempPath=[self AppDownloadTempPath];
    NSData *resumeData;
    if ([[HUCacheManager sharedInstance]cacheExistsForKey:request.url inPath:AppDownloadTempPath]) {
        resumeData=[[HUCacheManager sharedInstance]getCacheDataForKey:request.url inPath:AppDownloadTempPath];
    }
    return [[HURequestEngine defaultEngine] downloadWithRequest:request resumeData:resumeData savePath:[self AppDownloadPath] progress:^(NSProgress * _Nullable downloadProgress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(requestProgress:)]) {
            [request.delegate requestProgress:downloadProgress];
        }
        request.progressBlock?request.progressBlock(downloadProgress):nil;
    }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [self failureWithError:error request:request];
        }else{
            [self successWithResponse:response responseObject:[filePath path] request:request];
            if ([[HUCacheManager sharedInstance]cacheExistsForKey:request.url inPath:AppDownloadTempPath]) {
                [[HUCacheManager sharedInstance]clearCacheForkey:request.url inPath:AppDownloadTempPath completion:nil];
            }
        }
    }];
}

+ (NSUInteger)downloadStopWithRequest:(HUURLRequest*)request{
    NSURLSessionTask * task=[[HURequestEngine defaultEngine]objectRequestForkey:request.url];
    NSURLSessionDownloadTask *downloadTask=(NSURLSessionDownloadTask *)task;
    [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        NSString *AppDownloadTempPath=[self AppDownloadTempPath];
        [[HUCacheManager sharedInstance]createDirectoryAtPath:AppDownloadTempPath];
        [[HUCacheManager sharedInstance] storeContent:resumeData forKey:request.url inPath:AppDownloadTempPath isSuccess:^(BOOL isSuccess) {
            if (request.consoleLog==YES) {
                NSLog(@"\n------------HUNetworking------download info------begin------\n暂停下载请求，保存当前已下载文件进度\n-URLAddress-:%@\n-downloadFileDirectory-:%@\n------------HUNetworking------download info-------end-------",request.url,AppDownloadTempPath);
            }
        }];
    }];
    [request setTask:downloadTask];
    [request setIdentifier:downloadTask.taskIdentifier];
    return request.identifier;
}

#pragma mark - 取消请求
+ (void)cancelRequest:(NSUInteger)identifier{
    [[HURequestEngine defaultEngine]cancelRequestByIdentifier:identifier];
}

+ (void)cancelBatchRequest:(HUBatchRequest *)batchRequest{
    if (batchRequest.requestArray.count>0) {
        [batchRequest.requestArray enumerateObjectsUsingBlock:^(HUURLRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.identifier>0) {
                [self cancelRequest:obj.identifier];
            }
        }];
    }
}

+ (void)cancelAllRequest{
    [[HURequestEngine defaultEngine]cancelAllRequest];
}

#pragma mark - 其他配置
+ (void)configBaseWithRequest:(HUURLRequest *)request progress:(HURequestProgressBlock)progress success:(HURequestSuccessBlock)success failure:(HURequestFailureBlock)failure finished:(HURequestFinishedBlock)finished target:(id<HUURLRequestDelegate>)target{
    [[HURequestEngine defaultEngine] configBaseWithRequest:request progressBlock:progress successBlock:success failureBlock:failure finishedBlock:finished target:target];
}

+ (NSString *)keyWithParameters:(HUURLRequest *)request{
    id newParameters;
    if (request.filtrationCacheKey.count>0) {
        newParameters=[HURequestTool formaParameters:request.parameters filtrationCacheKey:request.filtrationCacheKey];
    }else{
        newParameters = request.parameters;
    }
    NSString *key=[NSString hu_stringUTF8Encoding:[NSString hu_urlString:request.url appendingParameters:newParameters]];
    [request setValue:key forKey:_cacheKey];
    return key;
}

+ (void)storeObject:(NSObject *)object request:(HUURLRequest *)request{
    [[HUCacheManager sharedInstance] storeContent:object forKey:request.cacheKey isSuccess:nil];
}

+ (id)responsetSerializerConfig:(HUURLRequest *)request responseObject:(id)responseObject{
    if (request.responseSerializer==HUHTTPResponseSerializer||request.methodType==HUMethodTypeDownLoad||![responseObject isKindOfClass:[NSData class]]) {
        
        NSLog(@"打印请求结果：%@",[NSString stringWithFormat:@"%@", responseObject]);
        return responseObject;
    }else{
        NSError *serializationError = nil;
        NSData *data = (NSData *)responseObject;
        // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
        // See https://github.com/rails/rails/issues/1742
        BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
        if (data.length > 0 && !isSpace) {
            id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            return result;
        } else {
            return nil;
        }
    }
}

+ (void)successWithResponse:(NSURLResponse *)response responseObject:(id)responseObject request:(HUURLRequest *)request{
    id result=[self responsetSerializerConfig:request responseObject:responseObject];
    if ([HURequestEngine defaultEngine].responseProcessHandler) {
        NSError *processError = nil;
        id newResult =[HURequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
        if (newResult) {
            result = newResult;
        }
        if (processError) {
            [self failureWithError:processError request:request];
            return;
        }
    }
    if (request.apiType == HURequestTypeRefreshAndCache||request.apiType == HURequestTypeCache) {
        [self storeObject:responseObject request:request];
    }
    [request setValue:response forKey:_response];
    [request setValue:@(NO) forKey:_isCache];
    [self successWithCacheCallbackForResult:result forRequest:request];
}

+ (void)failureWithError:(NSError *)error request:(HUURLRequest *)request{
    if (request.consoleLog==YES) {
        [self printfailureInfoWithError:error request:request];
    }
    if ([HURequestEngine defaultEngine].errorProcessHandler) {
        [HURequestEngine defaultEngine].errorProcessHandler(request, error);
    }
    if (request.retryCount > 0) {
        request.retryCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self startSendRequest:request];
        });
        return;
    }
    [self failureCallbackForError:error forRequest:request];
}

+ (void)getCacheDataForKey:(NSString *)key request:(HUURLRequest *)request{
    [[HUCacheManager sharedInstance]getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
        if (request.consoleLog==YES) {
            [self printCacheInfoWithkey:key filePath:filePath request:request];
        }
        id result=[self responsetSerializerConfig:request responseObject:data];
        if ([HURequestEngine defaultEngine].responseProcessHandler) {
            NSError *processError = nil;
            id newResult =[HURequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
            if (newResult) {
                result = newResult;
            }
        }
        [request setValue:filePath forKey:_filePath];
        [request setValue:@(YES) forKey:_isCache];
        [self successWithCacheCallbackForResult:result forRequest:request];
    }];
}

+ (void)successWithCacheCallbackForResult:(id)result forRequest:(HUURLRequest *)request{
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestSuccess:responseObject:)]) {
        [request.delegate requestSuccess:request responseObject:result];
    }
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestFinished:responseObject:error:)]) {
        [request.delegate requestFinished:request responseObject:result error:nil];
    }
    request.successBlock?request.successBlock(result, request):nil;
    request.finishedBlock?request.finishedBlock(result, nil,request):nil;
    [request cleanAllCallback];
    [[HURequestEngine defaultEngine] removeRequestForkey:request.url];
}

+ (void)failureCallbackForError:(NSError *)error forRequest:(HUURLRequest *)request{
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestFailed:error:)]) {
        [request.delegate requestFailed:request error:error];
    }
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestFinished:responseObject:error:)]) {
        [request.delegate requestFinished:request responseObject:nil error:error];
    }
    request.failureBlock?request.failureBlock(error):nil;
    request.finishedBlock?request.finishedBlock(nil,error,request):nil;
    [request cleanAllCallback];
    [[HURequestEngine defaultEngine] removeRequestForkey:request.url];
}

#pragma mark - 获取网络状态
+ (BOOL)isNetworkReachable{
    return [HURequestEngine defaultEngine].networkReachability != 0;
}

+ (BOOL)isNetworkWiFi{
    return [HURequestEngine defaultEngine].networkReachability == 2;
}

+ (HUNetworkReachabilityStatus)networkReachability{
    return [[HURequestEngine defaultEngine]networkReachability];
}

#pragma mark - 下载获取文件
+ (NSString *)getDownloadFileForKey:(NSString *)key{
    return [[HUCacheManager sharedInstance]getDiskFileForKey:[key lastPathComponent] inPath:[self AppDownloadPath]];
}

+ (NSString *)AppDownloadPath{
    return [[[HUCacheManager sharedInstance] HUKitPath]stringByAppendingPathComponent:hu_downloadPath];
}

+ (NSString *)AppDownloadTempPath{
    return [[[HUCacheManager sharedInstance] HUKitPath]stringByAppendingPathComponent:hu_downloadTempPath];
}

#pragma mark - 打印log
+ (void)printCacheInfoWithkey:(NSString *)key filePath:(NSString *)filePath request:(HUURLRequest *)request{
    NSString *responseStr=request.responseSerializer==HUHTTPResponseSerializer ?@"HTTP":@"JOSN";
    if ([filePath isEqualToString:@"memoryCache"]) {
        NSLog(@"\n------------HUNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-responseSerializer-:%@\n-filtrationCacheKey-:%@\n------------HUNetworking------cache info-------end-------",key,filePath,responseStr,request.filtrationCacheKey);
    }else{
        NSLog(@"\n------------HUNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-cacheFileInfo-:%@\n-responseSerializer-:%@\n-filtrationCacheKey-:%@\n------------HUNetworking------cache info-------end-------",key,filePath,[[HUCacheManager sharedInstance] getDiskFileAttributesWithFilePath:filePath],responseStr,request.filtrationCacheKey);
    }
}

+ (void)printfailureInfoWithError:(NSError *)error request:(HUURLRequest *)request{
    NSLog(@"\n------------HUNetworking------error info------begin------\n-URLAddress-:%@\n-retryCount-%ld\n-error code-:%ld\n-error info-:%@\n------------HUNetworking------error info-------end-------",request.url,request.retryCount,error.code,error.localizedDescription);
}

@end
