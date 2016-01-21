//
//  UIImage+Bundle.m
//  iMove
//
//  Created by linjinxing on 7/30/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (instancetype)imageWithName:(NSString*)fileName inMainBundleName:(NSString*)name
{
    return [self imageWithName:fileName subdirectory:nil inMainBundleName:name];
}

+ (instancetype)imageWithName:(NSString*)fileName subdirectory:(NSString*)subdir inMainBundleName:(NSString*)name
{
    NSString* path = nil;
    if ([subdir length]) {
        path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"],  fileName];
    }else{
        path = [NSString stringWithFormat:@"%@/%@/%@", [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"], subdir, fileName];
    }
    return ([path length] ? [UIImage imageWithContentsOfFile:path] : nil);
}
@end
