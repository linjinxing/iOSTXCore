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
    return [NSString stringWithFormat:@"%@/CLEffectTool/CLEffectBase.png", CLImageEditorTheme.bundle.bundlePath];
}

+ (CGFloat)defaultDockedNumber{
    return 4.1;
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
