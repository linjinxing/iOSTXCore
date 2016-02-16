//
//  CLImageToolOriginalImage.m
//  PRJ_CTH
//
//  Created by linjinxing on 16/1/31.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CLImageToolOriginalImage.h"

@implementation CLImageToolOriginalImage
#pragma mark- optional info

+ (NSString*)defaultIconImagePath{
//    self.editor.imageView.image;
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@@%@x.png", CLImageEditorTheme.bundle.bundlePath, NSStringFromClass([self class]), NSStringFromClass([self class]), @((int)[UIScreen mainScreen].scale)];
    return path;
}

+ (CGFloat)defaultDockedNumber{
    return 15.1;
}

+ (NSString*)defaultTitle{
    return @"原图";
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
