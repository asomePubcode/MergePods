//
//  AppDelegate.m
//  Example
//
//  Created by 廖亚雄 on 1/8/21.
//

#import "AppDelegate.h"

#import "LdsLogger.h"
#import "LdsHttpRequest.h"

#if __has_include(</MergePodsSDK/MergePodsSDK.h>)
#import "LdsDebug.h"
#import "MergePodsSDK.h"
#endif

#if __has_include(<MergePodsSDK2/MergePodsSDK2.h>)
#import "MergePodsSDK2.h"
#endif
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if __has_include(<MergePodsSDK/MergePodsSDK.h>)
    [LdsDebug debug];
    NSLog(@"[MergePods] %@",[MergePodsSDK new]);
#endif

#if __has_include(<MergePodsSDK2/MergePodsSDK2.h>)
    NSLog(@"[MergePods] %@",[MergePodsSDK2 new]);
#endif
    
//    [self debug];
    return YES;
}

- (void)debug {
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

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
