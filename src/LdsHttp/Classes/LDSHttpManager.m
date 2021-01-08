//
//  LDSHttpManager.m
//  SmartHome
//
//  Created by 廖亚雄 on 2018/3/2.
//  Copyright © 2018年 廖亚雄. All rights reserved.
//

#import "LDSHttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>
#import "LdsLogger.h"

NSString * const kResonpeErrorInfoData = @"com.alamofire.serialization.response.error.data";

@interface LDSHttpManager ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end
@implementation LDSHttpManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LDSHttpManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];//AFJSONRequestSerializer
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 30;
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        __weak typeof(self) weakSelf = self;
        //自定义服务端证书校验
        [_manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
            
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        
            weakSelf.manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                //校验CA机构证书
                if ([weakSelf.manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust
                                                               forDomain:challenge.protectionSpace.host]) {
                    *_credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if (_credential) {
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    //校验自签证书
                }
            }else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
            return disposition;
        }];

    }
    return _manager;
}

+ (void)setHttpHeader:(NSDictionary *)header {
    AFHTTPSessionManager *m = [LDSHttpManager sharedInstance].manager;
    if (m.requestSerializer&&header.allKeys.count>0) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [m.requestSerializer setValue:obj forHTTPHeaderField:key];
            } else {
                [m.requestSerializer setValue:[NSString stringWithFormat:@"%@",obj] forHTTPHeaderField:key];
            }
        }];
    }
}

+(void)requestWithURL:(NSString *)urlString
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)httpMethod
       completedBlock:(void (^ _Nullable)(id _Nullable))completedblock
          failedBlock:(void (^ _Nullable)(NSError * _Nullable))failedBlock
{
    LdsHttpRequest *req = [LdsHttpRequest new];
    req.method = httpMethod.uppercaseString;
    req.url = urlString;
    req.body = params;
    [req requestOnProgress:nil onSuccess:completedblock onError:failedBlock];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (LdsHttpRequest *)safeRequstWithConfig:(LdsHttpRequest *)config {
    if (!config) {
        NSAssert(config, @"[http error] requset config not exsit");;
        return nil;
    }
    if (!config.url) {
        NSAssert(config.url, @"[http error] requset config.url not exsit");;
        return nil;
    }
    NSString *urlString = config.url;
    if (config.parameters && config.parameters.count > 0) {//拼接URL
        NSDictionary *parameters = config.parameters;
        NSMutableArray *parametersStringArray = [NSMutableArray arrayWithCapacity:parameters.count];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [parametersStringArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        NSString *parametersString = [parametersStringArray componentsJoinedByString:@"&"];
        urlString = [urlString stringByAppendingFormat:@"?%@",parametersString];
    }
    NSDictionary *header = config.header;
    if (!header) {//获取请求头
        header = self.manager.requestSerializer.HTTPRequestHeaders;
    }
    //设置超时时间
    self.manager.requestSerializer.timeoutInterval = config.timeoutInterval;
    
    config.header = header;
    config.url = urlString;
    return config;
}
- (void)request:(LdsHttpRequest *)config uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgress downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nullable))failure {
    
    LdsHttpRequest *req = [self safeRequstWithConfig:config];

    __block NSURLSessionTask * afReqOperation = nil;
    LdsLogDebug(@"start request %@",req.description);
    afReqOperation = [self handleGenericRequset:req uploadProgress:uploadProgress downloadProgress:downloadProgress success:success failure:failure];
    NSNumber *reqId = @([afReqOperation taskIdentifier]);
    self.dispatchTable[reqId] = afReqOperation;
    [afReqOperation resume];
}

- (NSURLSessionTask *) handleGenericRequset:(LdsHttpRequest *)config uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgress downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nullable))failure {
    NSURLSessionTask *afReqOperation = [self.manager dataTaskWithHTTPMethod:config.method URLString:config.url parameters:config.body headers:config.header uploadProgress:uploadProgress downloadProgress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:task config:config response:responseObject onSuccess:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:task error:error onError:failure];
    }];
    return afReqOperation;
}

- (void)download:(LdsHttpRequest *)config downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nullable))failure {
    LdsHttpDownloadRequest *req = (LdsHttpDownloadRequest *)[self safeRequstWithConfig:config];
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:config.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:req.timeoutInterval];
    LdsLogDebug(@"start download %@",req.description);
    NSURLSessionTask *afReqOperation = [self.manager downloadTaskWithRequest:requset progress:downloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:req.destination];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (success && !error) success(response);
        
        if (failure && error) failure(error);
        
    }];
    [afReqOperation resume];
}

- (void)upload:(LdsHttpRequest *)config uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nullable))failure {
    LdsHttpUploadRequest *req = (LdsHttpUploadRequest *)[self safeRequstWithConfig:config];
    NSArray<LdsHttpUploadFileInfo *> *fileInfos = req.fileInfos;
    LdsLogDebug(@"start upload %@",req.description);
    id constructingBodyWithBlock = ^(id<AFMultipartFormData>  _Nonnull formData) {
        [fileInfos enumerateObjectsUsingBlock:^(LdsHttpUploadFileInfo * _Nonnull fileInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!fileInfo.fileData) {
                [formData appendPartWithFileData:[NSData dataWithContentsOfFile:fileInfo.filePath] name:fileInfo.name fileName:fileInfo.fileName mimeType:fileInfo.mimeType];
            }else {
                [formData appendPartWithFileData:fileInfo.fileData name:fileInfo.name fileName:fileInfo.fileName mimeType:fileInfo.mimeType];
            }
        }];
    };
    
    id successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:task config:config response:responseObject onSuccess:success];
    };
    
    id failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:task error:error onError:failure];
    };
    
    NSURLSessionTask *afReqOperation = nil;
    
    
    if([req.method isEqualToString:@"PUT"] && req.fileInfos.count == 1){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:req.url]];
        request.HTTPMethod = @"PUT";
        
        if(req.header){
            for (NSString *headerField in req.header.keyEnumerator) {
               [request setValue:req.header[headerField] forHTTPHeaderField:headerField];
            }
        }
        
        NSData *fileData = req.fileInfos[0].fileData;
        afReqOperation = [self.manager uploadTaskWithRequest:request fromData:fileData progress:uploadProgress completionHandler:successBlock];
    }else{
        afReqOperation = [self.manager POST:req.url parameters:req.body headers:req.header constructingBodyWithBlock:constructingBodyWithBlock progress:uploadProgress success:successBlock failure:failureBlock];
    }
    
    NSNumber *reqId = @([afReqOperation taskIdentifier]);
    self.dispatchTable[reqId] = afReqOperation;
    [afReqOperation resume];
}

- (void) handleSuccess:(NSURLSessionTask *)task config:(LdsHttpRequest *)config response:(id)responseObject onSuccess:(void (^)(id _Nullable))onSuccess {
    if(!onSuccess) {
        LdsLogError(@"[http error] 成功回调不存在");
        return;
    }
    NSNumber*reqID = @([task isKindOfClass:[NSURLSessionTask class]]?[task taskIdentifier]:0);
    [[LDSHttpManager sharedInstance].dispatchTable removeObjectForKey:reqID];
    NSData *reponseData = responseObject;
    NSDictionary* object;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
       object = responseObject;
    }else if(reponseData){
       object = [NSJSONSerialization JSONObjectWithData:reponseData options:NSJSONReadingMutableContainers error:nil];
    }
    // 接口返回的不是json，直接将内容返回
    if(object == nil){
        LdsLogDebug(@"[end request] %@",config);
       onSuccess([[NSString alloc] initWithData:reponseData encoding:NSUTF8StringEncoding]);
       return;
    }
    LdsLogDebug(@"[end request] %@",config);
    onSuccess(object);
}

- (void) handleError:(NSURLSessionTask *)task error:(NSError *)error onError:(void (^)(NSError * _Nullable))onError {
    if (!onError) {
        LdsLogError(@"[http error] 失败回调不存在");
        return;
    }
    NSNumber*reqID = @([task taskIdentifier]);
    [[LDSHttpManager sharedInstance].dispatchTable removeObjectForKey:reqID];
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)task.response;
    if (!resp) {
        onError(error);
        return;
    }
    NSError *newError = [NSError errorWithDomain:error.domain code:resp.statusCode userInfo:error.userInfo];
    onError(newError);
}

@end
