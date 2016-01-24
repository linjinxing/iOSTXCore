//
//  CTHCreateQuestionTableViewController.h
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//  创建问题界面

#import <UIKit/UIKit.h>
#import "CTHSubject.h"

@interface CTHCreateQuestionTableViewController : UITableViewController
@property(nonatomic, strong) CTHSubject* subject;
@property(nonatomic, copy) NSString* type;
@end
