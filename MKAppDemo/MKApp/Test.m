
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "Test.h"
#import <UIKit/UIKit.h>
#import "MKJSON.h"
#import "MKDebug.h"
#import "MKFunctions.h"

@interface TestCase : NSObject

@end
@interface TestCase ()
@property (copy,nonatomic) NSString* key;
@end
@implementation TestCase
-(void)testDelegate{
}
@end





@implementation Test
{
    NSString *_dicValue;
    NSArray *_testArr;
}

-(void)test{
    UIColor *c1 = MKColorWithHex(0xffffb400);
    UIColor *c2 = [UIColor colorWithRed:255 green:180 blue:0 alpha:1];
    NSString *c3 = MKHexWithColor(c1);
    MKAssertEqualString(@"0xffffb400",c3);
    [self testJSON];
    
    // crash test
    [self testCrash];
}
- (void)testCrash {
    
    
////    sel
//    [self nonselector];
//    self.delegate = [TestCase new];
//    [self.delegate didDiscoverDevice:@"device"];
//    [self performSelector:@selector(hello:) withObject:@"" afterDelay:3];
    
//    NSMutableArray <NSNumber*>*mulArr = [NSMutableArray arrayWithArray:@[@3,@1,@2]];
//    for (NSNumber* obj in mulArr) {
//        if (obj.integerValue == 2) {
//            [mulArr removeObject:obj];
//        }
//    }
//    self.marr = [NSMutableArray arrayWithArray:@[@"1"]];
//    [self.marr removeObjectAtIndex:0];
//    self.mdata = [NSMutableData data];
//    [self.mdata appendBytes:"" length:1];
    
    
    
//    // string
//    self.httpFailed([NSURLSessionDataTask new]);  // non
//    self.mstring = [NSMutableString string];   // non
//    [self.mstring appendFormat:@"%@",@"mythkiven"];  // non
    
    
    
//  //  dic
//    NSDictionary *cdic = @{@"1":@"a"};
//    [cdic setValue:_dicValue forKey:@"key"];
//    [[TestCase new] setValue:_dicValue forKey:@"key"];
//    [[TestCase new] setNilValueForKey:@"key"];  // non
//    [[TestCase new] setValue:_dicValue forKey:@"nonkey"]; // non
//    [self.mdic setObject:_dicValue forKey:@"key"];
//    [self.mdic removeObjectForKey:@"1"];
//    [NSMutableDictionary dictionaryWithDictionary:@{@"":_dicValue}]; // non
    
    
//    array
    // NSArray
    NSString *string1 = nil;
    id string2 = [NSNull null];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:100];
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    NSArray <NSString*>*array1 = @[string1,string2,@"1"];
    
    NSLog(@"%@ %@ %@ %@",array1.lastObject, array1.firstObject, array1[3], [array1 objectAtIndex:7]);
    NSLog(@"%@ %@",[array1 objectsAtIndexes:indexSet], [array1 componentsJoinedByString:@":"]);
    [array1 getObjects:cArray range:range];
    
    NSMutableArray *mutableArrray = [NSMutableArray array];
    [mutableArrray addObject:non];   // non
    
    

// //   set
//    self.mset = [NSMutableSet setWithArray:@[@"1",@"2"]];
//    [self.mset removeObject:@"1"];
    
   
}
- (void)testJSON {
    MKAssertNil(MKMakeJSON(nil));
    MKAssertNonNil(MKMakeJSON([self sampleDic]));
    MKAssertNil(MKMakeJSON([NSObject new]));
    MKAssertType(MKMakeJSON(self.sampleDic)[@"txdata"].dictionary,NSDictionary);
    NSArray *array = @[@1, @2, @3];
    MKAssertEqualArray(MKMakeJSON([self sampleDic])[@"bip_path"].array,array);
    MKAssertEqualString(MKMakeJSON([self sampleDic])[@"txdata"][@"utxos"][@"address"][@"country"].string, @"mhw3QEfdGyfGhZyH2zMMPS8MgEocFyi2o");
    MKAssertEqualString(MKMakeJSON([self sampleDic])[@"txdata"][@"utxos"][@"amount"].string, @"34346436547542135456548676964542324534563456");
}
- (NSDictionary *)sampleDic {
    return @{
             @"title": @"BTC 签名",
             @"extra_info":@"U77ffU5de5U8d39  6.46354636  USDT",
             @"txid": @"ee67d2f393a6868d44544a2fe81681a06aebb2384a5431fa981134de751b2699",
             @"txdata": @{
                     @"script_type": @"P2PKH",
                     @"type": @-1,
                     @"utxos": @{
                             @"amount": @"34346436547542135456548676964542324534563456",
                             @"script_pub_key":@"76a9141a7e7f56ea53c2120d4d735fd35795d52b3fd5",
                             @"address": @{
                                     @"country": @"mhw3QEfdGyfGhZyH2zMMPS8MgEocFyi2o",
                                     @"castle": @"myhJm9wcHAoQFyXC3ewyycG5q88nSrTLv",
                                     },
                             @"address2": [NSNull null],
                             }
                     },
             @"bip_path": @[@1, @2, @3],
             @"values": @43432.3763412,
             @"vout": @1434412,
             @"isUsdt": @YES,
             @"isBtc": @NO,
             @"n": @"0"
             };
}
@end
