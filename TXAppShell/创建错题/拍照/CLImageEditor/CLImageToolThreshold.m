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
    return [NSString stringWithFormat:@"%@/CLEffectTool/CLEffectBase.png", CLImageEditorTheme.bundle.bundlePath];
}

+ (CGFloat)defaultDockedNumber{
    return 5.1;
}

+ (NSString*)defaultTitle{
    return @"黑白";
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
