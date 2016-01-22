//
//  NSBundle+Info_Plist.m
//  LJXFoundation
//
//  Created by steven on 5/28/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "NSBundle+Info_Plist.h"
#import "LJXDebug.h"

@implementation NSBundle (Info_Plist)
//+(NSString*)filePathWithLanguage:(NSString*)aLanguage
//{
//    //    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
//    //    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"LJXResource.bundle"];
//    //    NSString* fileName = [NSString stringWithFormat:@"LocalString_%@.plist", aLanguage];
//    //    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:fileName];
//    NSString *resorcePath = [[NSBundle mainBundle] resourcePath];
//    NSString *fileName = [NSString stringWithFormat:@"LocalString_%@.plist", aLanguage];
//    NSString *finalPath = [resorcePath stringByAppendingPathComponent:fileName];
//    
//    return finalPath;
//}


+ (NSString*)bundleValueForKey:(NSString*)key
{
    static NSDictionary* infoDict = nil;;
    NSString* version = nil;
    if (nil == infoDict) {
        infoDict = [[NSBundle mainBundle] infoDictionary];        
    }
    version = [infoDict objectForKey:key];
    return version;
}

+(NSString*)identifier
{
    return  [self bundleValueForKey:(NSString*)kCFBundleIdentifierKey];
}

+(NSString*)executable
{
    return  [self bundleValueForKey:(NSString*)kCFBundleExecutableKey];
}

+(NSString*)displayName
{
    return [self bundleValueForKey:@"CFBundleDisplayName"];
}

+(NSString*)applicationName
{
    return  [self bundleValueForKey:(NSString*)kCFBundleNameKey];
}

+(NSString*)buildVersion
{
    return  [self bundleValueForKey:@"CFBundleVersion"];   
}

+(NSString*)version
{
    return  [self bundleValueForKey:@"CFBundleShortVersionString"];   
}

+(NSString*)URLSchemes
{
    //return  [[self bundleValueForKey:@"CFBundleURLTypes"] valueForKey:@"CFBundleURLSchemes"];
    id obj =  [[self bundleValueForKey:@"CFBundleURLTypes"] valueForKey:@"CFBundleURLSchemes"];
    if ([obj isKindOfClass:[NSString class]]) {
        LJXFoundationLog("obj:%@\n", obj);
        return obj;
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        LJXFoundationLog("[obj lastObject]:%@\n", [obj lastObject]);
        obj = [obj lastObject];
        if ([obj isKindOfClass:[NSArray class]]) {
            LJXFoundationLog("[obj lastObject]:%@\n", [obj lastObject]);
            return [obj lastObject];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            LJXFoundationLog("obj:%@\n", obj);
            return obj;
        }
    }
    LJXFoundationLog("obj:%@\n", obj);
    return nil;
}

@end
