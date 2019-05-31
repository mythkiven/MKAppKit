/**
 *
 * Created by https://github.com/mythkiven/ on 19/04/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKJSON : NSObject

/**
 * 初始化的 JSON 对象
 */
@property (nonatomic, copy, readonly, nullable) id JSONObject;
/**
 * 实例的 NSDictionary 形式
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary* dictionary;
/**
 * 实例的 NSArray 形式
 */
@property (nonatomic, copy, readonly, nullable) NSArray* array;
/**
 * 实例的 NSString 形式
 */
@property (nonatomic, copy, readonly, nullable) NSString* string;
/**
 * 实例的 NSNumber 形式
 */
@property (nonatomic, copy, readonly, nullable) NSNumber* number;
/**
 * 实例的 NSDecimalNumber 形式
 */
@property (nonatomic, copy, readonly, nullable) NSDecimalNumber* decimalNumber;
/**
 * 实例的 NSInteger 形式
 */
@property (nonatomic, readonly) NSInteger integerValue;
/**
 * 实例的 NSInteger 形式
 */
@property (nonatomic, readonly) double doubleValue;
/**
 * 实例的 NSInteger 形式
 */
@property (nonatomic, readonly) float floatValue;
/**
 * 实例的 NSInteger 形式
 */
@property (nonatomic, readonly) int intValue;
/**
 * 实例的 NSInteger 形式
 */
@property (nonatomic, readonly) BOOL boolValue;
/**
 * 实例的 int (64bit) 形式
 */
@property (nonatomic, readonly) int64_t longLongValue;
/**
 * 创建一个 MKJSON 实例
 * @param JSONObject 一个有效的 json 对象
 * @return MKJSON 实例
 */
- (instancetype)initWithJSONObject:(nullable id)JSONObject;
- (nullable instancetype)objectForKeyedSubscript:(NSString *)key;
@end

/**
 * 简化的实例方法
 * @param 等同 -[MKJSON initWithJSONObject:]
 * @return 等同 -[MKJSON initWithJSONObject:]
 */
MKJSON *MKMakeJSON(id _Nullable JSONObject);


NS_ASSUME_NONNULL_END
