//
//  CTHQuestionTagsTableViewCell.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHQuestionTagsTableViewCell.h"

@interface CTHQuestionTagsTableViewCell()
@property(nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property(nonatomic, weak) IBOutlet UIButton* btnEdit;
@property(nonatomic, weak) IBOutlet UIButton* btnAdd;
@property(nonatomic, weak) IBOutlet UILabel* label;
//@property(nonatomic, weak) IBOutlet 
@end

@implementation CTHQuestionTagsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
