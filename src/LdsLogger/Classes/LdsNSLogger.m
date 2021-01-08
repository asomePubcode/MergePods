//
//  LdsNSLogger.m
//  Pods
//
//  Created by 廖亚雄 on 2020/5/12.
//

#import "LdsNSLogger.h"
#import "LogFormatter.h"
@implementation LdsNSLogger
- (void)log:(BOOL)asynchronous level:(LdsLogLevel)level flag:(LdsLogFlag)flag context:(NSInteger)context file:(const char *)file function:(const char *)function line:(NSUInteger)line tag:(id)tag format:(NSString *)format args:(va_list)args {
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    message = [NSString stringWithFormat:@"[%@] [%@] | %@",[LogFormatter format],@(line),message];
    NSLog(@"%@",message);
}
@end
