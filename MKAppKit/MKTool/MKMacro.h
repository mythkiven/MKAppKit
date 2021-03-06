
/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/27.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#ifndef MKMacro_h
#define MKMacro_h

// debug
#ifdef DEBUG
#define MKDEBUG  true
#else
#define MKDEBUG  false
#endif


#ifndef mk_dispatch_main_async_safe
#define mk_dispatch_main_async_safe(block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif




#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)// 需要解两次才解开的宏
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__) // 为warning增加更多信息
#define KEYWORDIFY try {} @catch (...) {} // 使宏前面可以加@
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG)) // 最终使用的宏



#define MK_BASE_DIR [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"MKMonitor"]
#define MK_CRASH_DIR [MK_BASE_DIR stringByAppendingPathComponent:@"MKCrashLog"]
#define MK_LOG_DIR [MK_BASE_DIR stringByAppendingPathComponent:@"MKLog"]
#define MK_RENDER_DIR  [MK_BASE_DIR stringByAppendingPathComponent:@"MKRenderLog"]

#define MK_FILE_NAME_TAG MKDEBUG?@"debug_":@"release_"

#define MKDeviceVersion  [UIDevice currentDevice].systemVersion.doubleValue





//#define MKLog(FORMAT, ...)      MKDEBUG ? fprintf(stderr,"MKLog>> %s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]) : printf("")
#define MKPrintf(fmt, ...)        MKDEBUG ? fprintf(stderr,"%s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]) : printf("")
#define MKDLog(fmt, ...)        MKDEBUG ? fprintf(stderr,"MKLog >>> %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]) : printf("")

#define MKLog(fmt, ...)         MKDEBUG ? NSLog((@"MKDLog >>> %s%s "           fmt), "", "", ##__VA_ARGS__) : printf("")
#define MKErrorLog(fmt, ...)    MKDEBUG ? NSLog((@"MKDLog >>> Error!! %s:%d "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) : printf("")
#define MKWarningLog(fmt, ...)  MKDEBUG ? NSLog((@"MKDLog >>> Warning!! %s%s " fmt), "", "", ##__VA_ARGS__) : printf("")




#define MKClassName(interface) NSStringFromClass([interface class])

#define MKAssert NSAssert
#define MKAssertParameter(condition) NSAssert(condition, @"%s: Invalid parameter '%s'", __PRETTY_FUNCTION__, #condition)
#define MKAssertNonNil(object) NSAssert(object != nil, @"'%s' is nil.", #object)
#define MKAssertNil(object) NSAssert(object == nil, @"'%s' is nil.", #object)
#define MKAssertType(object, type) NSAssert([object isKindOfClass:type.class], @"'%s'#%@ is not type #%@.", #object, NSStringFromClass([object class]), NSStringFromClass(type.class))
#define MKAssertClass(object, class) NSAssert([object isKindOfClass:class], @"'%s'#%@ is not type #%@.", #object, NSStringFromClass([object class]), NSStringFromClass(class))
#define MKAssertEqualString(string1, string2) NSAssert([string1 isEqualToString:string2], @"%@ is not equal %@.",string1,string2)
#define MKAssertEqualArray(array1, array2) NSAssert([array1 isEqualToArray:array2], @"array is not equal")
#define MKAssertMustOverride() NSAssert(NO, @"%s: Must override selector.", __PRETTY_FUNCTION__)
#define MKAssertBadConstructor() NSAssert(NO, @"%s: This constructor can't use.", __PRETTY_FUNCTION__)
#define MKAssertFailed(...) NSAssert(NO, ##__VA_ARGS__)

#endif /* MKMacro_h */
