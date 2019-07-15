//
//  UTest.m
//  MKApp
//
//  Created by apple on 2019/6/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import "UTest.h"
#import "MKJSON.h"
#import "MKHeader.h"
#import "MKFunctions.h"
#import "MKRenderCounter.h"
#import "MKRenderWatch.h"
#import "MKCrashGuardManager.h"
#import "CrashTest.h"


#pragma mark - UTest 

@implementation UTest

@end




#pragma mark -
#pragma mark - renderTest

@implementation RenderTest
{
    NSTimer *_timer;
}
- (void)renderTest {
#if !TARGET_IPHONE_SIMULATOR
    [MKRenderCounter sharedRenderCounter].enabled = YES;
#endif
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(blockThread) userInfo:nil repeats:true];
    [self performSelector:@selector(cancelTest) withObject:nil afterDelay:3];
}
- (void)cancelTest {
    [_timer fire];
    _timer = nil;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}
- (void)blockThread {
    dispatch_async(dispatch_get_main_queue(), ^{
        for(NSInteger i = 0; i < 1000; i++){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            NSString *str = @"2017-03-08 01:03:31";
            [formatter dateFromString:str];
            NSLog(@"busy...");
        }
    });
}
@end


#pragma mark -
#pragma mark - CaseTest



@implementation CaseTest
- (void)test{
    [self testJSON];
    [self testOther];
}
- (void)testOther {
    UIColor *c1 = MKColorWithHex(0xffffb400);
    UIColor *c2 = [UIColor colorWithRed:255 green:180 blue:0 alpha:1];
    NSString *c3 = MKHexWithColor(c1);
    MKAssertEqualString(@"0xffffb400",c3);
}
#pragma mark  json
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







#pragma mark -
#pragma mark - CrashCaught




@implementation CrashCaughtTest

typedef struct Test{
    int a;
    int b;
}Test;

+ (void)testExceptionCrashCaught {
 //     exception
    NSArray* aaa = @[];
    NSLog(@"%@",aaa[2]);
// 
    
}
+ (void)testSigCrashCaught {
    
     //   SIGABRT
        Test *pTest = {1,2};
        free(pTest);
        pTest->a = 5;
    
    // or
    
    char* p1 = (char*)-1;
    *p1 = 10;
    
}
@end






#pragma mark -
#pragma mark - testViewController


@interface KVOObjectDemo : NSObject
@property(nonatomic,readwrite,copy)NSString* demoString;
@end
@implementation KVOObjectDemo
@end

@interface KVOObserver :NSObject
@end
@implementation KVOObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
}
- (void)dealloc{
    NSLog(@"dealloc");
}
@end


@interface testViewController ()

@property(nonatomic,readwrite,copy) NSString *test;
@property(nonatomic,readwrite,copy) NSString *test1;
@property(nonatomic,readwrite,copy) NSString *demoString1;

@end

@implementation testViewController {
    NSTimer *_t;
    KVOObjectDemo *_kvoDemo;
    KVOObserver *_kvoObserver;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _kvoDemo = [KVOObjectDemo new];
    _kvoObserver = [KVOObserver new];
    [self testTimer];
    [self testKVO];
    [self testNotification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _kvoObserver = nil;
        self.demoString1 = @"11";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
#pragma mark  test Notifiaction
- (void)testNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotificationObserver) name:@"test" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}
- (void)testNotificationObserver {
    NSLog(@"test Notifiaction");
}

#pragma mark   test Timer
- (void)testTimer {
    _t = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scheduledMethod) userInfo:nil repeats:YES];
}
- (void)scheduledMethod {
    NSLog(@"test Timer");
}

#pragma mark   test KVO
- (void)testKVO{
    [_kvoDemo addObserver:self forKeyPath:@"demoString" options:NSKeyValueObservingOptionNew context:nil];
    [_kvoDemo addObserver:self forKeyPath:@"demoString" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew  context:nil];
    [_kvoDemo addObserver:self forKeyPath:@"demoString" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"test1" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"test1" options:NSKeyValueObservingOptionNew context:nil];
    [self removeObserver:self forKeyPath:@"test0" context:nil];
    [self addObserver:self forKeyPath:@"test2" options:NSKeyValueObservingOptionNew context:nil];
    [_kvoDemo addObserver:self forKeyPath:@"demoString" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_kvoObserver forKeyPath:@"demoString1" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

#pragma mark   dealloc
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"test2"];
    NSLog(@"PushViewController%s",__FILE__);
}

@end
