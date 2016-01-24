//
//  CTHQuestionTagsCollectionViewCell.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHQuestionTagsCollectionViewCell.h"

@interface CTHQuestionTagsCollectionViewCell()
@property(nonatomic, weak) IBOutlet UILabel* label;
@property(nonatomic, weak) IBOutlet UIButton* btn;
@property(nonatomic, weak) IBOutlet UIButton* btnDelete;
@end

@implementation CTHQuestionTagsCollectionViewCell
- (void)awakeFromNib
{
    [self.btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    @weakify(self)
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.btn.selected = !self.btn.isSelected;
//        [self.btn setBackgroundColor:self.btn.selected? [UIColor blueColor] : [UIColor whiteColor]];
    }];
    
    RAC(self.btnDelete, hidden) = RACObserve(self, bDeleteViewHidden);
    self.bDeleteViewHidden = YES;
    self.btnDelete.userInteractionEnabled = NO;
}
@end
