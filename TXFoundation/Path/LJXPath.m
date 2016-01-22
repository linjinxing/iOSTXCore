//
//  IMPath.m
//  LJXFoundation
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "LJXPath.h"
#import "LJXSystem.h"
#import "NSBundle+Info_Plist.h"

@implementation LJXPath

+ (NSString*)root
{
    return [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
}

+(NSString*)library
{
#if DEBUG
	if ([LJXSystem isSimulator]) {
		return @"/tmp";
	}
#endif
    return [[self root] stringByAppendingPathComponent:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] lastPathComponent]];
}

+(NSString*)document
{
    return [[self root] stringByAppendingPathComponent:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    return nil;
}

+(NSString*)tmp
{
    return [[self root] stringByAppendingPathComponent:[NSTemporaryDirectory() lastPathComponent]];
}


+ (NSString *)systemData
{
    //    NSString *documentPath = [NSFileManager documentsPath];
    //    NSString *sysDataPath = [documentPath stringByAppendingPathComponent:@"IMPlayer"];
    NSString *sysDataPath = [[self library] stringByAppendingPathComponent:@"Private Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:sysDataPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:sysDataPath withIntermediateDirectories:YES attributes:nil error:&error];
    }

    return sysDataPath;
}


+ (NSString *)downloadData
{
//    return [self document];
    NSString *downloadPath = nil;
    downloadPath = [[LJXPath library] stringByAppendingPathComponent:@"Private Documents/IMPlayer/DownloadCaches"];
//    if ([LJXSystem OSVersion] >= 5.0) {
//        if ([LJXSystem isEqualToOSVersion:@"5.0"])
//        {
//            downloadPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        }else{
//            downloadPath = [self systemData];
//        }
//    }else{
//        downloadPath = [self systemData];
//    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:downloadPath])
    {
        NSError *error = nil;
        
        [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return downloadPath;
}

+(NSString *)bigScreenCache
{
    NSString *bigScreenCachePath = [[LJXPath library] stringByAppendingPathComponent:@"Private Documents/IMPlayer/BigScreen"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bigScreenCachePath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:bigScreenCachePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return bigScreenCachePath;
}
@end
