//
//  LogFormatter.h
//  Logger
//
//  Created by 廖亚雄 on 2019/7/24.
//  Copyright © 2019 廖亚雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
#import <CocoaLumberjack/CocoaLumberjack.h>
#endif

@interface LogFormatter : NSObject
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
<DDLogFormatter>
#endif
+ (NSString *)format;
@end


