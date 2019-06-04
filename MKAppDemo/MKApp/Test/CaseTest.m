//
//  CaseTest.m
//  MKApp
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import "CaseTest.h"
#import "MKJSON.h"
#import "MKDebug.h"
#import "MKFunctions.h"

@implementation CaseTest
- (void)test{
    [self testJSON];
    [self testOther];
}

#pragma mark -
- (void)testOther {
    UIColor *c1 = MKColorWithHex(0xffffb400);
    UIColor *c2 = [UIColor colorWithRed:255 green:180 blue:0 alpha:1];
    NSString *c3 = MKHexWithColor(c1);
    MKAssertEqualString(@"0xffffb400",c3);
}

#pragma mark - json

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
