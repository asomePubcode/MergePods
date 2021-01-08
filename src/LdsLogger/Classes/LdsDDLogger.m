//
//  LdsDDLogger.m
//  Pods
//
//  Created by 廖亚雄 on 2020/5/12.
//

#import "LdsDDLogger.h"
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "LogFormatter.h"
DDLogLevel ddLogLevel = DDLogLevelAll;

#endif
@implementation LdsDDLogger
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)

 - (void)log:(BOOL)asynchronous
    level:(LdsLogLevel)level
     flag:(LdsLogFlag)flag
  context:(NSInteger)context
     file:(const char *)file
 function:(nullable const char *)function
     line:(NSUInteger)line
      tag:(nullable id)tag
      format:(NSString *)format args:(va_list)args {
     [DDLog log:asynchronous level:(DDLogLevel)level flag:(DDLogFlag)flag context:context file:file function:function line:line tag:tag format:format args:args];
}
- (instancetype)initWithLevel:(LdsLogLevel)level {
    if (self == [super init]) {
        ddLogLevel = (DDLogLevel)level;
        if (@available(iOS 10.0, *)) {
            [[DDOSLogger sharedInstance] setLogFormatter:[LogFormatter new]];
            [DDLog addLogger:[DDOSLogger sharedInstance]];
        }else {
            [[DDASLLogger sharedInstance] setLogFormatter:[LogFormatter new]];
            [DDLog addLogger:[DDASLLogger sharedInstance]];
        }
    }
    return self;
}
#endif

@end
//#else
//@implementation LdsDDLogger
//
//+ (void)log:(BOOL)asynchronous level:(LdsLogLevel)level flag:(LdsLogFlag)flag context:(NSInteger)context file:(const char *)file function:(const char *)function line:(NSUInteger)line tag:(id)tag format:(NSString *)format, ... {
//
//}
//
//@end
//#endif

