//
//  LdsLogger.h
//  Pods
//
//  Created by 廖亚雄 on 2020/5/12.
//

#import <Foundation/Foundation.h>
/**
 * In order to provide fast and flexible logging, this project uses Cocoa Lumberjack.
 *
 * The Google Code page has a wealth of documentation if you have any questions.
 * https://github.com/robbiehanson/CocoaLumberjack
 *
 * Here's what you need to know concerning how logging is setup for CocoaHTTPServer:
 *
 * There are 4 log levels:
 * - Error
 * - Warning
 * - Info
 * - Verbose
 *
 * In addition to this, there is a Trace flag that can be enabled.
 * When tracing is enabled, it spits out the methods that are being called.
 *
 * Please note that tracing is separate from the log levels.
 * For example, one could set the log level to warning, and enable tracing.
 *
 * All logging is asynchronous, except errors.
 * To use logging within your own custom files, follow the steps below.
 *
 * Step 1:
 * Import this header in your implementation file:
 *
 * #import "LdsLogging.h"
 *
 * Step 2:
 * Define your logging level in your implementation file:
 *
 * // Log levels: off, error, warn, info, verbose
 * static const int ldsLogLevel = LDS_LOG_LEVEL_VERBOSE;
 *
 * If you wish to enable tracing, you could do something like this:
 *
 * // Debug levels: off, error, warn, info, verbose
 * static const int ldsLogLevel = LDS_LOG_LEVEL_INFO | LDS_LOG_FLAG_TRACE;
 *
 * Step 3:
 * Replace your NSLog statements with LdsLog statements according to the severity of the message.
 *
 * NSLog(@"Fatal error, no dohickey found!"); -> LdsLogError(@"Fatal error, no dohickey found!");
 *
 * LdsLog works exactly the same as NSLog.
 * This means you can pass it multiple variables just like NSLog.
**/

#import <CocoaLumberjack/DDLog.h>
/********************************************************
 step1 #import <CocoaLumberjack/CocoaLumberjack.h> in file LdsLogging.h
 Step2: replace all LDS_LOG_OBJC_MAYBE with LDS_LOG_OBJC_MAYBE and all LOG_C_MAYBE with LDS_LOG_C_MAYBE in file LdsLogging.h
 Step 3: add the following macro in file LdsLogging.h
 
 #define LDS_LOG_OBJC_MAYBE(async, lvl, flg, ctx, frmt, ...) \
 do{ if(LDS_LOG_ASYNC_ENABLED) LOG_MAYBE(async, lvl, flg, ctx, nil, sel_getName(_cmd), frmt, ##__VA_ARGS__); } while(0)
 
 #define LDS_LOG_C_MAYBE(async, lvl, flg, ctx, frmt, ...) \
 do{ if(LDS_LOG_ASYNC_ENABLED) LOG_MAYBE(async, lvl, flg, ctx, nil, __FUNCTION__, frmt, ##__VA_ARGS__); } while(0)
 *******************************************************/


#define LDS_LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
do { if(lvl & flg) LDS_LOG_MACRO(async, lvl, flg, ctx, tag, fnct, frmt, ##__VA_ARGS__); } while(0)

#define LDS_LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
[LdsLog log : isAsynchronous                                     \
     level : lvl                                                \
      flag : flg                                                \
   context : ctx                                                \
      file : __FILE__                                           \
  function : fnct                                               \
      line : __LINE__                                           \
       tag : atag                                               \
    format : (frmt), ## __VA_ARGS__]

#define LDS_LOG_OBJC_MAYBE(async, flg, lvl, ctx, frmt, ...) \
do{ if(LDS_LOG_ASYNC_ENABLED) LDS_LOG_MAYBE(async, lvl, flg, ctx, nil, sel_getName(_cmd), frmt, ##__VA_ARGS__); } while(0)

#define LDS_LOG_C_MAYBE(async, flg, lvl, ctx, frmt, ...) \
do{ if(LDS_LOG_ASYNC_ENABLED) LDS_LOG_MAYBE(async, lvl, flg, ctx, nil, __FUNCTION__, frmt, ##__VA_ARGS__); } while(0)


// Define logging context for every log message coming from the HTTP server.
// The logging context can be extracted from the DDLogMessage from within the logging framework,
// which gives loggers, formatters, and filters the ability to optionally process them differently.

#define LDS_LOG_CONTEXT 0

// Setup fine grained logging.
// The first 4 bits are being used by the standard log levels (0 - 3)
//
// We're going to add tracing, but NOT as a log level.
// Tracing can be turned on and off independently of log level.

#define LDS_LOG_FLAG_TRACE   (1 << 4) // 0...10000

// Setup the usual boolean macros.

//#define LDS_LOG_ERROR   (ldsLogLevel & LDS_LOG_FLAG_ERROR)
//#define LDS_LOG_WARN    (ldsLogLevel & LDS_LOG_FLAG_WARN)
//#define LDS_LOG_INFO    (ldsLogLevel & LDS_LOG_FLAG_INFO)
//#define LDS_LOG_VERBOSE (ldsLogLevel & LDS_LOG_FLAG_VERBOSE)
//#define LDS_LOG_TRACE   (ldsLogLevel & LDS_LOG_FLAG_TRACE)

// Configure asynchronous logging.
// We follow the default configuration,
// but we reserve a special macro to easily disable asynchronous logging for debugging purposes.

#define LDS_LOG_ASYNC_ENABLED   YES

//#define LDS_LOG_ASYNC_ERROR   ( NO && LDS_LOG_ASYNC_ENABLED)
//#define LDS_LOG_ASYNC_WARN    (YES && LDS_LOG_ASYNC_ENABLED)
//#define LDS_LOG_ASYNC_INFO    (YES && LDS_LOG_ASYNC_ENABLED)
//#define LDS_LOG_ASYNC_VERBOSE (YES && LDS_LOG_ASYNC_ENABLED)
//#define LDS_LOG_ASYNC_TRACE   (YES && LDS_LOG_ASYNC_ENABLED)

// Define logging primitives.

#define LdsLogError(frmt, ...)    LDS_LOG_OBJC_MAYBE(NO,  LdsLogFlagError,   ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogWarn(frmt, ...)     LDS_LOG_OBJC_MAYBE(async,  LdsLogFlagWarn,    ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogInfo(frmt, ...)     LDS_LOG_OBJC_MAYBE(async,  LdsLogFlagInfo,    ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogDebug(frmt, ...)     LDS_LOG_OBJC_MAYBE(async,  LdsLogFlagDebug,    ldsLogLevel,\
                                                    LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogVerbose(frmt, ...)  LDS_LOG_OBJC_MAYBE(async,  LdsLogFlagVerbose, ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogTrace()             LDS_LOG_OBJC_MAYBE(async,  LdsLogFlagTrace,   ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, @"%@[%p]: %@", THIS_FILE, self, THIS_METHOD)

#define LdsLogTrace2(frmt, ...)   LDS_LOG_OBJC_MAYBE(async,  LdsLogFlagTrace,   ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)


#define LdsLogCError(frmt, ...)      LDS_LOG_C_MAYBE(NO,  LdsLogFlagError,   ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogCWarn(frmt, ...)       LDS_LOG_C_MAYBE(async,  LdsLogFlagWarn,    ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogCInfo(frmt, ...)       LDS_LOG_C_MAYBE(async,  LdsLogFlagInfo,    ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogCDebug(frmt, ...)       LDS_LOG_C_MAYBE(async,  LdsLogFlagDebug,    ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogCVerbose(frmt, ...)    LDS_LOG_C_MAYBE(async,  LdsLogFlagVerbose, ldsLogLevel, \
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LdsLogCTrace()               LDS_LOG_C_MAYBE(async,  LdsLogFlagTrace,   ldsLogLevel,\
                                                  LDS_LOG_CONTEXT, @"%@[%p]: %@", THIS_FILE, self, __FUNCTION__)

#define LdsLogCTrace2(frmt, ...)     LDS_LOG_C_MAYBE(async,  LdsLogFlagTrace,   ldsLogLevel, \
                                                  LDS_LOG_CONTEXT, frmt, ##__VA_ARGS__)
NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSUInteger, LdsLogFlag){
    /**
     *  0...00001 LdsLogFlagError
     */
    LdsLogFlagError      = (1 << 0),

    /**
     *  0...00010 LdsLogFlagWarning
     */
    LdsLogFlagWarning    = (1 << 1),

    /**
     *  0...00100 LdsLogFlagInfo
     */
    LdsLogFlagInfo       = (1 << 2),

    /**
     *  0...01000 LdsLogFlagDebug
     */
    LdsLogFlagDebug      = (1 << 3),

    /**
     *  0...10000 LdsLogFlagVerbose
     */
    LdsLogFlagVerbose    = (1 << 4)
};

/**
 *  Log levels are used to filter out logs. Used together with flags.
 */
typedef NS_ENUM(NSUInteger, LdsLogLevel){
    /**
     *  No logs
     */
    LdsLogLevelOff       = 0,

    /**
     *  Error logs only
     */
    LdsLogLevelError     = (LdsLogFlagError),

    /**
     *  Error and warning logs
     */
    LdsLogLevelWarning   = (LdsLogLevelError   | LdsLogFlagWarning),

    /**
     *  Error, warning and info logs
     */
    LdsLogLevelInfo      = (LdsLogLevelWarning | LdsLogFlagInfo),

    /**
     *  Error, warning, info and debug logs
     */
    LdsLogLevelDebug     = (LdsLogLevelInfo    | LdsLogFlagDebug),

    /**
     *  Error, warning, info, debug and verbose logs
     */
    LdsLogLevelVerbose   = (LdsLogLevelDebug   | LdsLogFlagVerbose),

    /**
     *  All logs (1...11111)
     */
    LdsLogLevelAll       = NSUIntegerMax
};

extern LdsLogLevel ldsLogLevel;
static const BOOL async = YES;


@protocol LdsLogProtocol <NSObject>

- (void)log:(BOOL)asynchronous
   level:(LdsLogLevel)level
    flag:(LdsLogFlag)flag
 context:(NSInteger)context
    file:(const char *)file
function:(nullable const char *)function
    line:(NSUInteger)line
     tag:(nullable id)tag
     format:(NSString *)format args:(va_list)args;
@end

//@protocol LdsLogBuilder <LdsLogProtocol>
//- (id <LdsLogProtocol>)loggerBuilder;
//@end

@interface LdsLogger : NSObject <LdsLogProtocol>

@end

typedef enum : NSUInteger {
    LdsLoggerType_NSLog,
    LdsLoggerType_DDLog,
} LdsLoggerType;

@interface LdsLog : NSObject
+ (void) setLevel:(LdsLogLevel)level logger:(LdsLoggerType)type;
+ (void) setLogger:(id<LdsLogProtocol>)logger;

+ (void)log:(BOOL)asynchronous
   level:(LdsLogLevel)level
    flag:(LdsLogFlag)flag
 context:(NSInteger)context
    file:(const char *)file
function:(nullable const char *)function
    line:(NSUInteger)line
     tag:(nullable id)tag
  format:(NSString *)format, ... NS_FORMAT_FUNCTION(9,10);

@end





NS_ASSUME_NONNULL_END
