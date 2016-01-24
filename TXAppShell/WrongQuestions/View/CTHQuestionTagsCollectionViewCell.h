//
//  CTHQuestionTagsCollectionViewCell.h
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTHQuestionTagsCollectionViewCell : UICollectionViewCell
//@property(nonatomic, weak, readonly) UILabel* label;
@property(nonatomic, weak, readonly) UIButton* btn;
@property(nonatomic, strong) RACDisposable * disposable;
@end
