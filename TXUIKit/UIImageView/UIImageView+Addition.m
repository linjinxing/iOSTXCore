//
//  UIImageView+Addition.m
//  TXUIKit
//
//  Created by linjinxing on 16/2/1.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import "UIImageView+Addition.h"
#import "UIView+Subviews.h"

@implementation UIView (Addition)
- (UIImageView*)imageViewWithTag:(NSInteger)tag{
    return [self viewWithTag:tag class:[UIImageView class]];
}
@end
