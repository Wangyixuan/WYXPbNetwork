//
//  HUURLRequest.m
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import "HUURLRequest.h"

@implementation HUURLRequest
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _requestSerializer=HUJSONRequestSerializer;
    _responseSerializer=HUJSONResponseSerializer;
    _methodType=HUMethodTypePOST;
    _apiType=HURequestTypeRefresh;
    _retryCount=0;
    _identifier = 0;
    
    _isBaseServer=YES;
    _isBaseParameters=YES;
    _isBaseHeaders=YES;
    return self;
}

- (void)setRequestSerializer:(HURequestSerializerType)requestSerializer{
    _requestSerializer=requestSerializer;
    _isRequestSerializer=YES;
}

- (void)setResponseSerializer:(HUResponseSerializerType)responseSerializer{
    _responseSerializer=responseSerializer;
    _isResponseSerializer=YES;
}

- (void)cleanAllCallback{
    _successBlock = nil;
    _failureBlock = nil;
    _finishedBlock = nil;
    _progressBlock = nil;
    _delegate=nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //  NSLog(@"undefinedKey:%@",key);
}

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

#pragma mark - 上传请求参数
- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData {
    HUUploadData *formData = [HUUploadData formDataWithName:name fileData:fileData];
    [self.uploadDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    HUUploadData *formData = [HUUploadData formDataWithName:name fileName:fileName mimeType:mimeType fileData:fileData];
    [self.uploadDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    HUUploadData *formData = [HUUploadData formDataWithName:name fileURL:fileURL];
    [self.uploadDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    HUUploadData *formData = [HUUploadData formDataWithName:name fileName:fileName mimeType:mimeType fileURL:fileURL];
    [self.uploadDatas addObject:formData];
}

#pragma mark - 懒加载

- (NSMutableArray<HUUploadData *> *)uploadDatas {
    if (!_uploadDatas) {
        _uploadDatas = [[NSMutableArray alloc]init];
    }
    return _uploadDatas;
}

@end

#pragma mark - HUBatchRequest
@interface HUBatchRequest () {
    NSUInteger _batchRequestCount;
    BOOL _failed;
}
@end

@implementation HUBatchRequest
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _batchRequestCount = 0;
    _requestArray = [NSMutableArray array];
    _responseArray = [NSMutableArray array];
    return self;
}
- (void)onFinishedRequest:(HUURLRequest*)request response:(id)responseObject error:(NSError *)error finished:(HUBatchRequestFinishedBlock _Nullable )finished{
    NSUInteger index = [_requestArray indexOfObject:request];
    if (responseObject) {
         [_responseArray replaceObjectAtIndex:index withObject:responseObject];
    }else{
         _failed = YES;
         if (error) {
             [_responseArray replaceObjectAtIndex:index withObject:error];
         }
    }
    _batchRequestCount++;
    if (_batchRequestCount == _requestArray.count) {
        if (!_failed) {
            if (request.delegate&&[request.delegate respondsToSelector:@selector(requestBatchFinished:responseObjects:errors:)]) {
                [request.delegate requestBatchFinished:_requestArray responseObjects:_responseArray errors:nil];
            }
            if (finished) {
                finished(_responseArray,nil,_requestArray);
            }
        }else{
            if (request.delegate&&[request.delegate respondsToSelector:@selector(requestBatchFinished:responseObjects:errors:)]) {
                [request.delegate requestBatchFinished:_requestArray responseObjects:nil errors:_responseArray];
            }
            if (finished) {
                finished(nil,_responseArray,_requestArray);
            }
        }
    }
}

@end

#pragma mark - HUUploadData

@implementation HUUploadData

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData {
    HUUploadData *formData = [[HUUploadData alloc] init];
    formData.name = name;
    formData.fileData = fileData;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    HUUploadData *formData = [[HUUploadData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileData = fileData;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    HUUploadData *formData = [[HUUploadData alloc] init];
    formData.name = name;
    formData.fileURL = fileURL;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    HUUploadData *formData = [[HUUploadData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileURL = fileURL;
    return formData;
}
@end

#pragma mark - HUConfig

@implementation HUConfig
- (void)setRequestSerializer:(HURequestSerializerType)requestSerializer{
    _requestSerializer=requestSerializer;
    _isRequestSerializer=YES;
}

- (void)setResponseSerializer:(HUResponseSerializerType)responseSerializer{
    _responseSerializer=responseSerializer;
    _isResponseSerializer=YES;
}

@end
