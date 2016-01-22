//
//  LJXButton.h
//  QvodUI
//
//  Created by steven on 2/1/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXControlActionProtocol.h"

typedef enum tagIMButtonLayout{
    LJXBL_Default,
    LJXBL_ImageTop,     /* 图片在上，标题在下 */
    LJXBL_ImageLeft,     /* 图片在左，标题在右 */
    LJXBL_ImageRight,  /* 图片在右，标题在左 */
}LJXButtonLayout;


@interface LJXButton : UIButton<LJXControlActionHandler>
@property(nonatomic, assign)CGFloat verticalSpace; /* 默认控件之间的间隔 */
@property(nonatomic, assign)LJXButtonLayout layout;
//- (void)addActionBlock:(LJXButtonActionBlock)block forControlEvents:(UIControlEvents)events;
@end
