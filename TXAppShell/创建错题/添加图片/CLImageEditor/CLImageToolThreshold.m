//
//  CLImageToolThreshold.m
//  PRJ_CTH
//
//  Created by linjinxing on 16/2/2.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CLImageToolThreshold.h"

@implementation CLImageToolThreshold

+ (NSString*)defaultIconImagePath{
    //    self.editor.imageView.image;
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@@%@x.png", CLImageEditorTheme.bundle.bundlePath, NSStringFromClass([self class]), NSStringFromClass([self class]), @((int)[UIScreen mainScreen].scale)];
    return path;
}

+ (CGFloat)defaultDockedNumber{
    return 10.1;
}

+ (NSString*)defaultTitle{
    return @"智能处理";
}

+ (BOOL)isAvailable{
    return YES;
}

+ (NSArray*)subtools{
    return nil;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}
@end
