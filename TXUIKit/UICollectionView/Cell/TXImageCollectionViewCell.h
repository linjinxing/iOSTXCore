//
//  TXImageCollectionViewCell.h
//  TXUIKit
//
//  Created by linjinxing on 16/1/30.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXImageCollectionViewCell : UICollectionViewCell
@property(nonatomic, weak, readonly) UIImageView* imageView;
@property(nonatomic, weak, readonly) UIButton* btnDelete;
@end
