//
//  LogFormatter.m
//  Logger
//
//  Created by 廖亚雄 on 2019/7/24.
//  Copyright © 2019 廖亚雄. All rights reserved.
//

#import "LogFormatter.h"

@implementation LogFormatter

- (NSString * _Nullable)formatLogMessage:(nonnull DDLogMessage *)logMessage {
    return [NSString stringWithFormat:@"[%@] [%@] | %@",logMessage->_fileName,@(logMessage->_line),logMessage->_message];
}
+ (NSString *)format {
    return [NSString stringWithUTF8String:__FILE__].lastPathComponent;
}
@end
