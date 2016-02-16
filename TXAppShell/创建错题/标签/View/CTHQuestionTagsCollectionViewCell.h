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
@property(nonatomic, weak, readonly) UIButton* btn;  /* 显示标签的按钮 */
@property(nonatomic, weak, readonly) UIButton* btnDelete; /* 删除按钮 */
@property(nonatomic, strong) RACDisposable * disposable;
@property(nonatomic, strong) RACDisposable * deleteDisposable;
@property(nonatomic, assign) BOOL bDeleteViewHidden; /* 是否显示删除 */
@end
