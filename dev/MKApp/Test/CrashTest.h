
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TestDelegate <NSObject>

- (void)didDiscoverDevice:(NSObject*)device;

@end


typedef void (^HttpFailed) (NSURLSessionDataTask*);


@interface CrashTest : NSObject

// test crash
@property (nonatomic,copy) HttpFailed httpFailed;
@property (nonatomic,weak)  id<TestDelegate>  delegate;
@property (nonatomic,copy)  NSMutableArray*  marr;
@property (nonatomic,copy)  NSMutableDictionary*  mdic;
@property (nonatomic,copy)  NSMutableString*  mstring;
@property (nonatomic,copy)  NSMutableData*  mdata;
@property (nonatomic,copy)  NSMutableSet*  mset;
@property (strong,nonatomic) NSTimer* timer;

- (void)executeAllTest;
-(void)nonselector;

@end

NS_ASSUME_NONNULL_END
