//
//  LdsLog.m
//  Pods
//
//  Created by 廖亚雄 on 2020/5/12.
//

#import "LdsLog.h"
#import "LdsDDLogger.h"
#import "LdsNSLogger.h"
LdsLogLevel ldsLogLevel = LdsLogLevelAll;
@interface LdsLog ()
@property(nonatomic, strong) id <LdsLogProtocol> logger;
@end

@implementation LdsLog

+ (void)setLogger:(id<LdsLogProtocol>)logger {
    LdsLog *log = [self sharedInstance];
    log.logger = logger;
}

+ (void)setLevel:(LdsLogLevel)level logger:(LdsLoggerType)type{
    LdsLogger *logger = nil;
    switch (type) {
        case LdsLoggerType_DDLog:
            logger = (LdsLogger *)[[LdsDDLogger alloc] initWithLevel:level];
            break;
            
        default:
            logger = (LdsLogger *)[LdsNSLogger new];
            break;
    }
    ldsLogLevel = level;
    if (logger) {
        [self setLogger:logger];
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LdsLog *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}
+ (void)log:(BOOL)asynchronous level:(LdsLogLevel)level flag:(LdsLogFlag)flag context:(NSInteger)context file:(const char *)file function:(const char *)function line:(NSUInteger)line tag:(id)tag format:(NSString *)format, ... {
    LdsLog *log = [self sharedInstance];
    va_list args;
    va_start(args, format);
    [log.logger log:asynchronous level:level flag:flag context:context file:file function:function line:line tag:tag format:format args:args];
    va_end(args);
}
@end

@implementation LdsLogger

- (void)log:(BOOL)asynchronous level:(LdsLogLevel)level flag:(LdsLogFlag)flag context:(NSInteger)context file:(nonnull const char *)file function:(nullable const char *)function line:(NSUInteger)line tag:(nullable id)tag format:(nonnull NSString *)format args:(va_list)args {
    
}

@end
