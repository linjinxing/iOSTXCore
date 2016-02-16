//
//  CTHQuestionTagsTableViewController.h
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTHSubject.h"

typedef enum tagCTHQuestionTagTypes{
    CTHQuestionTagTypeFrom = 9, /* 来源 */
    CTHQuestionTagTypeType = 10, /* 题目类型 */
    CTHQuestionTagTypeCustom = 11, /* 自定义 */
    CTHQuestionTagTypeAnalysis = 12, /* 错因分析 */
}CTHQuestionTagTypes;

@interface CTHQuestionTagsSelectionViewController : UICollectionViewController
@property(nonatomic, strong) CTHSubject* subject;
@property(nonatomic, copy) LJXResultBlock doneBlock; /* 完成标签选择回调 */
@end
