//
//  CTHQuestionTags.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHQuestionTags.h"
#import "CTHQuestionTagItem.h"

@implementation CTHQuestionTags

+ (void)load
{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"tags" : [CTHQuestionTagItem class]
                 };
    }];
}

@end
