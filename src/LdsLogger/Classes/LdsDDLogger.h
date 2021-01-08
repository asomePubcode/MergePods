//
//  LdsDDLog.h
//  Pods
//
//  Created by 廖亚雄 on 2020/5/12.
//

#import "LdsLog.h"
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
extern DDLogLevel ddLogLevel;
#endif
NS_ASSUME_NONNULL_BEGIN

@interface LdsDDLogger : NSObject <LdsLogProtocol>
- (instancetype)initWithLevel:(LdsLogLevel)level;
@end

NS_ASSUME_NONNULL_END
