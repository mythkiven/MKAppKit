
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKFileManager.h"

@implementation MKFileManager
+ (NSString *)documentsDirectoryPath {
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return pathes.firstObject;
}
+ (NSURL *)documentsDirectoryURL {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return urls.firstObject;
}
+ (NSString *)libraryDirectoryPath {
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return pathes.firstObject;
}
+ (NSURL *)libraryDirectoryURL {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
    return urls.firstObject;
}
+ (NSString *)cacheDirectoryPath {
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return pathes.firstObject;
}
+ (NSString *)temporaryDirectoryPath {
    return NSTemporaryDirectory();
}

@end
