//
//  CTHQuestionTagsTableViewCell.h
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTHQuestionTagsTableViewCell : UITableViewCell
@property(nonatomic, weak, readonly) UICollectionView* collectionView;
@property(nonatomic, weak, readonly) UIButton* btnEdit;
@property(nonatomic, weak, readonly) UIButton* btnAdd;
@property(nonatomic, weak, readonly) UILabel* label;
@end
