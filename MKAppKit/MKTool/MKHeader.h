//
//  MKHeader.h
//  MKApp
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#ifndef MKHeader_h
#define MKHeader_h


#ifdef DEBUG
#define MKDEBUG  true
#else
#define MKDEBUG  false
#endif



#define MKDeviceVersion  [UIDevice currentDevice].systemVersion.doubleValue

//#define MKLog(FORMAT, ...)      MKDEBUG ? fprintf(stderr,"MKLog>> %s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]) : printf("")

#define MKDLog(fmt, ...)        MKDEBUG ? fprintf(stderr,"MKLog>> %s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]) : printf("")

#define MKLog(fmt, ...)         MKDEBUG ? NSLog((@"MKDLog>> %s%s "           fmt), "", "", ##__VA_ARGS__) : printf("")
#define MKErrorLog(fmt, ...)    MKDEBUG ? NSLog((@"MKDLog>> Error!! %s:%d "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) : printf("")
#define MKWarningLog(fmt, ...)  MKDEBUG ? NSLog((@"MKDLog>> Warning!! %s%s " fmt), "", "", ##__VA_ARGS__) : printf("")

#endif /* MKHeader_h */
