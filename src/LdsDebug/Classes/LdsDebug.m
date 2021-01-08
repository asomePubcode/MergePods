//
//  LdsDebug.m
//  MergePodsSDK
//
//  Created by 廖亚雄 on 1/8/21.
//

#import "LdsDebug.h"
#import "LdsLogger.h"
#import "LdsHttpRequest.h"
@implementation LdsDebug
+ (void)debug {
    [LdsLog setLevel:LdsLogLevelAll logger:LdsLoggerType_DDLog];
    LdsLogInfo(@"这里是demo");
    LdsHttpRequest *req = [LdsHttpRequest new];
    req.url = @"https://www.baidu.com";
    req.method = @"GET";
    [req requestOnProgress:nil onSuccess:^(id _Nullable res) {
        LdsLogInfo(@"%@",res);
    } onError:^(NSError * _Nullable e) {
        LdsLogInfo(@"%@",e);
    }];
}
@end
