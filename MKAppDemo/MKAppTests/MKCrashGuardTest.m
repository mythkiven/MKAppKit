//
//  MKCrashGuardTest.m
//  MKApp
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <XCTest/XCTest.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface MKCrashGuardTest : XCTestCase

@end

@implementation MKCrashGuardTest


- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}
/**
 野指针：EXC_BAD_ACCESS
 SEL:找不到方法：unrecognized selector sent to instance 0x1df96160
 Array:数组越界、插入空对象、for遍历数组的同时，删除其中的元素、
 Map：key\value为空、调用可变dic的`setObject:ForKey`方法、`NSMutableDictionary`的`setValue:ForKey:`方法而不是`setObject:ForKey:`方法
 
 */

// String 防护
- (void)testStringProtect {
    NSString *string = nil;
    [string rangeOfString:@"mythkiven"];
    [string substringFromIndex:8];
    [string substringToIndex:8];
    [string substringWithRange:NSMakeRange(8, 8)];
}
// MutableString 防护
- (void)testMutableStringProtect {
    NSString *string = nil;
    [string rangeOfString:@"mythkiven"];
    [string substringFromIndex:8];
    [string substringToIndex:8];
    [string substringWithRange:NSMakeRange(8, 8)];
}

// array 防护
- (void)testArrayProtect {
    NSArray *array = @[];
    array[9];
    [array objectAtIndex:12];
}
// MutableArray 防护
- (void)testMutableArrayProtect {
    NSString *string = nil;
    NSMutableArray *marray = @[@"a", @"b"].mutableCopy;
    NSMutableArray *marray2 = [NSMutableArray arrayWithObjects:string, nil];
    marray[3];
    [marray objectAtIndex:7];
    [marray addObject:string];
    [marray removeObjectAtIndex:7];
    [marray removeObject:@"c"];
    [marray insertObject:@"c" atIndex:7];
    [marray replaceObjectAtIndex:9 withObject:@"c"];
}
// Dictionary 防护
- (void)testDictionaryProtect {
    NSString *string = nil;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:string, string, nil];
    [dictionary objectForKey:string];
}

// MutableDictionary 防护
- (void)testMutableDictionaryProtect {
    NSString *string = nil;
    NSMutableDictionary *mdictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:string, string, nil];
    [mdictionary objectForKey:string];
    [mdictionary setObject:string forKey:string];
    mdictionary[string] = string;
    [mdictionary removeObjectForKey:string];
}


- (void)testAttributedStringProtect {
    NSString *string = nil;
    
    [[NSAttributedString alloc] initWithString:string];
    [[NSAttributedString alloc] initWithString:string attributes:nil];
}

// unrecognized selector 防护
- (void)testSelectorProtect {
    SuppressPerformSelectorLeakWarning(
                                       [self performSelector:NSSelectorFromString(@"nullSelector")];
                                       [[self class] performSelector:NSSelectorFromString(@"nullSelector")];
                                       );
}

@end
