
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


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

