//
//  CTHAnswerButton.m
//  PRJ_CTH
//
//  Created by linjinxing on 16/1/24.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHAnswerButton.h"

@implementation CTHAnswerButton

- (void)awakeFromNib
{
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.layer.cornerRadius = self.height/2;
    
    [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* btn) {
        btn.selected = !btn.isSelected;
        //        [self.btn setBackgroundColor:self.btn.selected? [UIColor blueColor] : [UIColor whiteColor]];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
