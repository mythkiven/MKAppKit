
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

// fflush(stdout);


#include <sys/stat.h>
#include <pthread.h>
#include <dirent.h>

#import "MKDevice.h"
#import "MKHeader.h"
#import "MKFileUtils.h"
#include <pthread.h>


static pthread_mutex_t mk_pthread_mutex_t_write_content = PTHREAD_MUTEX_INITIALIZER;

@implementation MKFileUtils

#pragma mark - public -
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

+ (NSString*)saveLogToLocalFile:(NSString*)savePath {
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *documentDirectory = [MK_LOG_DIR stringByAppendingPathComponent:@"MKLog"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:documentDirectory isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    } 
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.log",dateString];
    NSString *logFilePath = mk_isFileExist(savePath) ? savePath : [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);// NSLog
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);// printf
    return logFilePath;
}

static  NSString *mk_markline_c = @"├---";
static  NSString *mk_markline_b = @"|    ";
static  NSString *mk_markline_w = @"     ";
static  NSString *mk_markline_e = @"└---";
+ (void)treeSanbox {
    NSString *homePath = NSHomeDirectory();
    MKPrintf(@"in %@/AppData directory:",homePath);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    NSArray *paths = [fm contentsOfDirectoryAtPath:homePath error:&err];
    for (NSString *path in paths) {
        MKPrintf(@"%@ %@",[paths indexOfObject:path]<paths.count-1?mk_markline_c: mk_markline_e,path);
        if ([[path lastPathComponent] hasPrefix:@"."]) {
            continue;
        }
        BOOL isDir = false;
        NSString *fullPath = [homePath stringByAppendingPathComponent:path];
        [fm fileExistsAtPath:fullPath isDirectory:&isDir];
        if (isDir) {
            [self treeFile:fullPath mark:mk_markline_b];
        }
    }
}
+ (void)treeFile:(NSString *)path mark:(NSString*)mark {
    NSArray *dir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [dir enumerateObjectsUsingBlock:^(id  _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
        MKPrintf(@"%@ %@",idx<dir.count-1?[mark stringByAppendingString:mk_markline_c]:[mark stringByAppendingString:mk_markline_e], file);
        BOOL isDir;
        NSString *newpath = [path stringByAppendingPathComponent: file];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newpath isDirectory:&isDir] && isDir) {
            [self treeFile:newpath mark:[mark stringByAppendingString:idx<dir.count-1?mk_markline_b:mk_markline_w]];
        }
    }]; 
}

+ (void)saveToDir:(NSString*)dirPath content:(NSMutableDictionary *)dict fileName:(NSString*)fileName{
    [dict setObject:[MKDevice new].deviceInfo forKey:@"appinfo"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    [dict setObject:dateString forKey:@"date"];
    NSString* savePath = [[dirPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".log"];
    
    pthread_mutex_lock(&mk_pthread_mutex_t_write_content);
    BOOL succeed = [ dict writeToFile:savePath atomically:YES];
    if(NO == succeed){
        MKErrorLog(@"crash report failed!");
    }else{
        MKLog(@"save crash report succeed!");
    }
    if(fileName) {
        NSMutableArray *mplist;
        if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[dirPath stringByAppendingPathComponent:[fileName stringByAppendingString:@".plist"]]]){
            mplist = [[NSMutableArray arrayWithContentsOfFile:[dirPath stringByAppendingPathComponent:[fileName stringByAppendingString:@".plist"]]] mutableCopy];
            [mplist addObject:dateString];
            if([mplist writeToFile:[MK_CRASH_DIR stringByAppendingPathComponent:@"mkCrashLog.plist"] atomically:YES]){
                MKLog(@"add to  %@.plist success",fileName);
            }else{
                MKErrorLog(@"add to %@.plist faile",fileName);
            }
        }
    }
    pthread_mutex_unlock(&mk_pthread_mutex_t_write_content);
    
}


#pragma mark -
bool mk_isFileExist(NSString *filePath) {
    bool exist = true;
    if(!filePath){
        return false;
    }
    const char * path = [filePath UTF8String];
    int fd = -1;
    struct stat st; // 获取文件信息
    if(stat(path, &st) < 0) {
        exist = false;
    }
    fd = open(path, O_RDONLY);
    if(fd < 0) {
        exist = false;
    } 
    return exist;
}
bool mk_safe_deletereFile(NSString *filePath) {
    return mk_removeFile([filePath UTF8String],false);
}
bool mk_safe_deleteContentsOfPath(NSString *filePath) {
    if(filePath == NULL) {
        return false;
    }
    if(!mk_canDeletePath([filePath UTF8String])) {
        return false;
    }
    return mk_deletePathContents([filePath UTF8String], false);
}

static pthread_mutex_t mk_pthread_mutex_t = PTHREAD_MUTEX_INITIALIZER;
NSString* mk_safe_readFile(NSString *filePath) {  // 基于 kscrs_readReport
    pthread_mutex_lock(&mk_pthread_mutex_t);
    char* result;
    const char* path = [filePath UTF8String];
    mk_readEntireFile(path, &result, NULL, 2000000);
    pthread_mutex_unlock(&mk_pthread_mutex_t);
    NSString *content = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:result length:strlen(result)] encoding:NSUTF8StringEncoding]; 
    return content;
}

#pragma mark - Api -

bool mk_readEntireFile(const char* const path, char** data, int* length, int maxLength) {
    bool isSuccessful = false;
    int bytesRead = 0;
    char* mem = NULL;
    int fd = -1;
    int bytesToRead = maxLength;
    
    struct stat st;
    if(stat(path, &st) < 0) {
        MKErrorLog(@"Could not stat %s: %s", path, strerror(errno));
        goto done;
    }
    
    fd = open(path, O_RDONLY);
    if(fd < 0) {
        MKErrorLog(@"Could not open %s: %s", path, strerror(errno));
        goto done;
    }
    
    if(bytesToRead == 0 || bytesToRead >= (int)st.st_size) {
        bytesToRead = (int)st.st_size;
    }
    else if(bytesToRead > 0) {
        if(lseek(fd, -bytesToRead, SEEK_END) < 0) {
            MKErrorLog(@"Could not seek to %d from end of %s: %s", -bytesToRead, path, strerror(errno));
            goto done;
        }
    }
    
    mem = malloc((unsigned)bytesToRead + 1);
    if(mem == NULL) {
        MKErrorLog(@"Out of memory");
        goto done;
    }
    
    if(!mk_readBytesFromFD(fd, mem, bytesToRead)) {
        goto done;
    }
    
    bytesRead = bytesToRead;
    mem[bytesRead] = '\0';
    isSuccessful = true;
    
done:
    if(fd >= 0) {
        close(fd);
    }
    if(!isSuccessful && mem != NULL) {
        free(mem);
        mem = NULL;
    }
    
    *data = mem;
    if(length != NULL) {
        *length = bytesRead;
    }
    
    return isSuccessful;
}
bool mk_readBytesFromFD(const int fd, char* const bytes, int length) {
    char* pos = bytes;
    while(length > 0) {
        int bytesRead = (int)read(fd, pos, (unsigned)length);
        if(bytesRead == -1) {
            MKErrorLog(@"Could not write to fd %d: %s", fd, strerror(errno));
            return false;
        }
        length -= bytesRead;
        pos += bytesRead;
    }
    return true;
}



static bool mk_deletePathContents(const char* path, bool deleteTopLevelPathAlso) {
    struct stat statStruct = {0};
    if(stat(path, &statStruct) != 0) {
        MKErrorLog("Could not stat %s: %s", path, strerror(errno));
        return false;
    }
    if(S_ISDIR(statStruct.st_mode)) {
        char** entries = NULL;
        int entryCount = 0;
        mk_dirContents(path, &entries, &entryCount);
        int bufferLength = MK_MAX_PATH_LENGTH;
        char* pathBuffer = malloc((unsigned)bufferLength);
        snprintf(pathBuffer, bufferLength, "%s/", path);
        char* pathPtr = pathBuffer + strlen(pathBuffer);
        int pathRemainingLength = bufferLength - (int)(pathPtr - pathBuffer);
        
        for(int i = 0; i < entryCount; i++) {
            char* entry = entries[i];
            if(entry != NULL && mk_canDeletePath(entry)) {
                strncpy(pathPtr, entry, pathRemainingLength);
                mk_deletePathContents(pathBuffer, true);
            }
        }
        
        free(pathBuffer);
        mk_freeDirListing(entries, entryCount);
        if(deleteTopLevelPathAlso) {
            mk_removeFile(path, false);
        }
    }else if(S_ISREG(statStruct.st_mode)) {
        mk_removeFile(path, false);
    }else {
        MKErrorLog("Could not delete %s: Not a regular file.", path);
        return false;
    }
    return true;
}

#pragma mark - Utility -

bool mk_makePath(const char* absolutePath) {
    bool isSuccessful = false;
    char* pathCopy = strdup(absolutePath);
    for(char* ptr = pathCopy+1; *ptr != '\0';ptr++) {
        if(*ptr == '/') {
            *ptr = '\0';
            if(mkdir(pathCopy, S_IRWXU) < 0 && errno != EEXIST) {
                MKErrorLog("Could not create directory %s: %s", pathCopy, strerror(errno));
                goto done;
            }
            *ptr = '/';
        }
    }
    if(mkdir(pathCopy, S_IRWXU) < 0 && errno != EEXIST) {
        MKErrorLog("Could not create directory %s: %s", pathCopy, strerror(errno));
        goto done;
    }
    isSuccessful = true;
done:
    free(pathCopy);
    return isSuccessful;
}


bool mk_removeFile(const char* path, bool mustExist) {
    if(remove(path) < 0) {
        if(mustExist || errno != ENOENT) {
            MKErrorLog("Could not delete %s: %s", path, strerror(errno));
        }
        return false;
    }
    return true;
}

static void mk_freeDirListing(char** entries, int count) {
    if(entries != NULL) {
        for(int i = 0; i < count; i++) {
            char* ptr = entries[i];
            if(ptr != NULL) {
                free(ptr);
            }
        }
        free(entries);
    }
}


static bool mk_canDeletePath(const char* path) {
    const char* lastComponent = strrchr(path, '/');
    if(lastComponent == NULL) {
        lastComponent = path;
    } else {
        lastComponent++;
    }
    if(strcmp(lastComponent, ".") == 0) {
        return false;
    }
    if(strcmp(lastComponent, "..") == 0) {
        return false;
    }
    return true;
}

static int mk_dirContentsCount(const char* path) {
    int count = 0;
    DIR* dir = opendir(path);
    if(dir == NULL) {
        MKErrorLog("Error reading directory %s: %s", path, strerror(errno));
        return 0;
    }
    struct dirent* ent;
    while((ent = readdir(dir))) {
        count++;
    }
    closedir(dir);
    return count;
}

static void mk_dirContents(const char* path, char*** entries, int* count) {
    DIR* dir = NULL;
    char** entryList = NULL;
    int entryCount = mk_dirContentsCount(path);
    if(entryCount <= 0) {
        goto done;
    }
    dir = opendir(path);
    if(dir == NULL) {
        MKErrorLog("Error reading directory %s: %s", path, strerror(errno));
        goto done;
    }
    
    entryList = calloc((unsigned)entryCount, sizeof(char*));
    struct dirent* ent;
    int index = 0;
    while((ent = readdir(dir))) {
        if(index >= entryCount) {
            MKErrorLog("Contents of %s have been mutated", path);
            goto done;
        }
        entryList[index] = strdup(ent->d_name);
        index++;
    }
done:
    if(dir != NULL) {
        closedir(dir);
    }
    if(entryList == NULL) {
        entryCount = 0;
    }
    *entries = entryList;
    *count = entryCount;
}
@end
