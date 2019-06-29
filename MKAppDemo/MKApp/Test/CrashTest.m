
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "CrashTest.h"
#import <UIKit/UIKit.h>


@interface TestCase : NSObject

@end
@interface TestCase ()
@property (copy,nonatomic) NSString* key;
@end
@implementation TestCase
-(void)testDelegate{
}
@end





@implementation CrashTest
{
    NSString *_dicValue;
    NSArray *_testArr;
}

- (void)executeAllTest {
    [self testArray];
    [self testNSMutableArray];
    [self testNSString];
    [self testNSMutableString];
    [self testNSDictionary];
    [self testNSMutableDictionary];
    [self testNSAttributedString];
    [self testNSMutableAttributedString];
    
    [self testKVC];
    [self testSelector];
    
    [self testUnSupportCrash];
    [self testOp];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(6 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{ 
        
    } );
    
    
    
}

- (void)testOp {
    id nullValue = [NSNull null];
    NSString *result = [nullValue stringValue];
    __unused float x = floorf(123.456f); // makes sure compiler doesn't trick us
    float result2 = [nullValue floatValue];
    int result3 = [nullValue intValue];
    const void *result4 = [nullValue bytes];
    NSString *result5 = NSStringFromClass([nullValue class]);
    NSString *result6 = [nullValue description]; 
    
}

#pragma mark crash 防护
- (void)testUnSupportCrash {
    
    // NSData
    self.mdata = [NSMutableData data];
    [self.mdata appendBytes:"" length:1];
    //   set
    self.mset = [NSMutableSet setWithArray:@[@"1",@"2"]];
    [self.mset removeObject:@"1"];
    
    id person = [UIViewController new];
    [person objectForKey:@"key"];
    
    
    void *dataOut = malloc(16 * sizeof(uint8_t));
//    free(dataOut);
    /**
     * 暂不知支持：
     */
//    // block
//    self.httpFailed([NSURLSessionDataTask new]);
//    // appendFormat
//    self.mstring = [NSMutableString string];   // non
//    [self.mstring appendFormat:@"%@",@"mythkiven"];  // non
//    // kvc
//    [[TestCase new] setNilValueForKey:@"key"];  // non
////    Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIViewController objectForKey:]: unrecognized selector sent to instance 0x7fc075f0f790'
//    [[NSObject new] valueForKey:@"MKCrashGuard"];
////    Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<NSObject 0x600001910050> valueForUndefinedKey:]: this class is not key value coding-compliant for the key MKCrashGuard.'
//    [[UIView new] valueForKey:@"MKCrashGuard"];
//// Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<UIView 0x7f8441d024f0> valueForUndefinedKey:]: this class is not key value coding-compliant for the key MKCrashGuard.'

}




#pragma mark -

- (void)testArray {
    NSString *nilStr = nil;
    NSString *nulStr = [NSNull null];
    NSArray <NSString*>*array = @[@"mythkvien", nilStr, nulStr];
    NSLog(@"%@ %@ %@ %@ %@ ",array,array.firstObject,array.lastObject,array[0],array[9999]);
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:100];
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    NSArray <NSString*>*array1 = @[nilStr,nulStr,@"1"];
    
    NSLog(@"%@ %@ %@ ", [array1 objectAtIndex:999],[array1 objectsAtIndexes:indexSet], [array1 componentsJoinedByString:@":"]);
    [array1 getObjects:cArray range:range];
    
    NSArray *array2 = @[@"mythkvien", @"iOS_Dev"];
    NSObject *object = array2[1000];
    NSLog(@"object = %@",object);
    
    NSString *string3 = nil;
    id string4 = [NSNull null];
    NSIndexSet *indexSet3 = [NSIndexSet indexSetWithIndex:100];
    NSRange range3 = NSMakeRange(0, 11);
    __unsafe_unretained id cArray3[range.length];
    NSArray <NSString*>*array3 = @[string3,string4,@"1"];
    NSLog(@"%@ %@ %@ %@",array3.lastObject, array3.firstObject, array3[3], [array3 objectAtIndex:7]);
    NSLog(@"%@ %@",[array3 objectsAtIndexes:indexSet3], [array3 componentsJoinedByString:@":"]);
    [array3 getObjects:cArray3 range:range3];
    NSMutableArray *mutableArrray = [NSMutableArray array];
    [mutableArrray addObject:string3];   // non
    
}

- (void)testNSMutableArray {
    NSMutableArray <NSString*>*array1 = @[@"mythkvien"].mutableCopy;
    NSObject *object = array1[222];
    array1[3] = @"iOS";
    NSLog(@"%@ %@ %@ %@ %@ %@",array1,array1.firstObject,array1.lastObject,array1[0],array1[9999],[array1 objectAtIndex:20]);
    
    [array1 removeObjectAtIndex:8];
    [array1 insertObject:@"cool" atIndex:15];
    [array1 insertObject:nil atIndex:0];
    NSString *nilStr = nil;
    [array1 addObject:nilStr]; //其本质是调用insertObject:
    
    NSMutableArray *array2 = @[@"mythkvien", @"iOSDeveloper"].mutableCopy;
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    [array2 getObjects:cArray range:range];
    
    
    NSMutableArray <NSNumber*>*mulArr = [NSMutableArray arrayWithArray:@[@3,@1,@2]];
    for (NSNumber* obj in mulArr) {
        if (obj.integerValue == 2) {
            [mulArr removeObject:obj];
        }
    }
    self.marr = [NSMutableArray arrayWithArray:@[@"1"]];
    [self.marr removeObjectAtIndex:0];
}

- (void)testNSDictionary {
    NSString *nilkey = nil;
    NSString *nilvalue = nil;
    NSString *nullkey = [NSNull null];
    NSString *nullvalue= [NSNull null];
    NSDictionary *dict = @{
                           nilkey : nilvalue,
                           nullkey : nullvalue,
                           @"name" :@"mythkiven"
                           };
    NSLog(@"%@ %@ %@ ",dict,dict[nullkey],dict[@"mythkiven"],[dict objectForKey:@"666"]);
    
    
    [self.mdic setObject:_dicValue forKey:@"key"];
    [self.mdic removeObjectForKey:@"1"];
    [NSMutableDictionary dictionaryWithDictionary:@{@"":_dicValue}]; // non
    
    
}

- (void)testNSMutableDictionary {
    NSString *nilkey = nil;
    NSString *nilvalue = nil;
    NSString *nullkey = [NSNull null];
    NSString *nullvalue= [NSNull null];
    NSMutableDictionary *dict = @{
                                  @"name" : @"mythkvien",
                                  nilkey : nullvalue
                                  }.mutableCopy;
    dict[nullkey] = @(996);
    NSLog(@"%@ %@ %@ %@ ",dict,dict[nullkey],dict[@"mythkiven"],[dict objectForKey:@"666"]);
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    NSString *ageKey = nil;
    [dict2 setObject:@(669) forKey:ageKey];
    NSLog(@"%@ %@ %@ %@ ",dict2,dict2[nullkey],dict2[@"mythkiven"],[dict2 objectForKey:@"666"]);
    
    NSMutableDictionary *dict3 = @{
                                   @"name" : @"mythkvien",
                                   @"age" : @(25)
                                   }.mutableCopy;
    NSString *key = nil;
    [dict3 removeObjectForKey:key];
    NSLog(@"%@ %@ %@ %@ ",dict3,dict3[nullkey],dict3[@"mythkiven"],[dict3 objectForKey:@"666"]);
}

- (void)testNSString {
    NSString *str1 = @"mythkvien";
    NSLog(@"%c %@",[str1 characterAtIndex:996],[str1 substringFromIndex:669]);
    
    NSString *str2 = @"mythkvien";
    NSRange range = NSMakeRange(0, 100);
    NSLog(@"%@ %@",[str2 substringToIndex:100],[str2 substringWithRange:range]);
    
    NSString *nilStr = nil;
    str2 = [str2 stringByReplacingOccurrencesOfString:nilStr withString:nilStr];
    NSLog(@"%@",str2);
    str1 = [str1 stringByReplacingOccurrencesOfString:@"myth" withString:@"" options:NSCaseInsensitiveSearch range:range];
    NSLog(@"%@",str1);
    
    str1 = [str2 stringByReplacingCharactersInRange:NSMakeRange(0, 1000) withString:@"cff"];
    NSLog(@"%@",str1);
}

- (void)testNSMutableString {
    NSMutableString *str = [NSMutableString stringWithFormat:@"mythkvien"];
    NSRange range = NSMakeRange(0, 1000);
    [str replaceCharactersInRange:range withString:nil];
    [str insertString:@"cool" atIndex:1000];
    [str deleteCharactersInRange:range];
}

- (void)testNSAttributedString {
    NSString *str = nil;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str];
    NSLog(@"%@",attributeStr);
    NSAttributedString *nilAttributedStr = nil;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithAttributedString:nilAttributedStr];
    NSLog(@"%@",attributedStr);
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor redColor] };
    NSString *nilStr = nil;
    NSLog(@"%@",[[NSAttributedString alloc] initWithString:nilStr attributes:attributes]);
}

- (void)testNSMutableAttributedString {
    NSString *nilStr = nil;
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:nilStr];
    NSLog(@"%@",attrStrM);
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redColor]
                                 };
    NSLog(@"%@", [[NSMutableAttributedString alloc] initWithString:nilStr attributes:attributes]);
}


#pragma mark - KVC
/**
 * - (void)setValue:(id)value forKey:(NSString *)key
 * - (void)setValue:(id)value forKeyPath:(NSString *)keyPath
 * - (void)setValue:(id)value forUndefinedKey:(NSString *)key //这个方法一般用来重写，不会主动调用
 * - (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
 * unrecognized selector sent to instance
 */
- (void)testKVC {
    [[UITableView new] setValue:self forKey:@"MKCrashGuard"];
    [[UIView new] setValue:self forKeyPath:@"MKCrashGuard"];
    NSDictionary *dictionary = @{
                                 @"name" : @"mythkvien"
                                 };
    [NSObject setValuesForKeysWithDictionary:dictionary];
    
    NSDictionary *cdic = @{@"1":@"a"};
    [cdic setValue:_dicValue forKey:@"key"];
    [[TestCase new] setValue:_dicValue forKey:@"key"];
    [[TestCase new] setValue:_dicValue forKey:@"nonkey"];
    
 }

#pragma mark - selector
- (void)testSelector {
    
    [self nonselector];
    self.delegate = [TestCase new];
    [self.delegate didDiscoverDevice:@"device"];
    [self performSelector:@selector(hello:) withObject:@"" afterDelay:3];
    
    
    SEL selector = NSSelectorFromString(@"love669");
    [NSClassFromString(@"MK") performSelector:selector withObject:nil afterDelay:1.0];
    
    [self performSelector:@selector(l996ove) withObject:nil afterDelay:1.0];
    //    Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[ViewController l996ove]: unrecognized selector sent to instance 0x7fc16850b690'
    [self performSelector:@selector(love996:) withObject:nil afterDelay:1.0];
    //    Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[ViewController l996ove]: unrecognized selector sent to instance 0x7fc38340c550'
}

@end
