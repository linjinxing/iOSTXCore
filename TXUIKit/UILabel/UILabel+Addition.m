//
//  UILabel+Addition.m
//  TXUIKit
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import "UILabel+Addition.h"
#import "UIView+Subviews.h"

@implementation UILabel (Addition)

@end


@implementation UIView (UILabel)
- (UILabel*)labelWithTag:(NSInteger)tag{
    return [self viewWithTag:tag class:[UILabel class]];
}
@end