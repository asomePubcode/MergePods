//
//  LdsHttpRequest.m
//  Pods
//
//  Created by 廖亚雄 on 2020/5/6.
//

#import "LdsHttpRequest.h"
#import "LDSHttpManager.h"

@implementation LdsHttpRequest
- (void)dealloc {
    
}
- (NSString *)description {
    return [NSString stringWithFormat:@"method:%@,url:%@,header:%@,body:%@",self.method,self.url,self.header,self.body];
}
- (instancetype)init {
    if (self == [super init]) {
        self.timeoutInterval = 60;
        self.method = @"GET";
    }
    return self;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    NSAssert([self isCorrectUrl:url], @"[http error] url not correct");
}

- (void)setHeader:(NSDictionary *)header {
    NSMutableDictionary *newHeader = [NSMutableDictionary dictionaryWithDictionary:header];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            NSString *objString = [NSString stringWithFormat:@"%@",obj];
            [newHeader setObject:objString forKey:key];
        }
    }];
    _header = newHeader.copy;
}
- (BOOL)isCorrectUrl:(NSString *)url
{
    if (!url || url.length < 5) { //http://
        return NO;
    }
    NSRange range = [url rangeOfString:@"://"];
    if (range.location == NSNotFound) {
        return NO;
    }
    NSString * scheme = [url substringWithRange:NSMakeRange(0, range.location)];
    
    if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
        || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
        return YES;
    }
    return NO;
}

- (void)requestOnProgress:(void (^)(NSProgress * _Nullable))progress onSuccess:(void (^)(id _Nullable))success onError:(void (^)(NSError * _Nullable))failure {
    [gLdsHttp request:self uploadProgress:nil downloadProgress:nil success:success failure:failure];
}

@end

@implementation LdsHttpUploadFileInfo
@end

@implementation LdsHttpUploadRequest
@synthesize fileInfos;
- (void)requestOnProgress:(void (^)(NSProgress * _Nullable))progress onSuccess:(void (^)(id _Nullable))success onError:(void (^)(NSError * _Nullable))failure {
    [gLdsHttp upload:self uploadProgress:progress success:success failure:failure];
}

@end
@implementation LdsHttpDownloadRequest
@synthesize destination;

- (void)requestOnProgress:(void (^)(NSProgress * _Nullable))progress onSuccess:(void (^)(id _Nullable))success onError:(void (^)(NSError * _Nullable))failure {
    [gLdsHttp download:self downloadProgress:progress success:success failure:failure];
}

@end
