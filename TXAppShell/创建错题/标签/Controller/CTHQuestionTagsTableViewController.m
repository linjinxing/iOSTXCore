//
//  CTHQuestionTagsTableViewController.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHQuestionTagsTableViewController.h"
#import "CTHQuestionTagsCollectionViewCell.h"
#import "CTHQuestionTagsTableViewCell.h"
#import "CTHQuestionTags.h"
#import "CTHQuestionTagItem.h"

@interface CTHQuestionTagsTableViewController ()
@property(nonatomic, strong) NSArray* groupTags;
//@property(nonatomic, strong) NSMutableArray* selectedTags;
@property(nonatomic, strong) NSMutableArray* cellHeights;
@end

@implementation CTHQuestionTagsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeights = [NSMutableArray array];
 [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getTagInfos",
                                     @"subjectType":self.subject.subjecttype,
                                     @"userName":@"linjinxing"},
                                   @"result",
                                   [CTHQuestionTags class])
     subscribeNext:^(NSArray* tags) {
         self.groupTags = tags;
         for (CTHQuestionTags* tag in tags) {
             tag.selectedTags = [NSMutableSet setWithCapacity:30];
         }
         LJXPerformBlockAsynOnMainThread(^{
             [self.tableView reloadData];
         });
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
}

- (IBAction)doneAction:(id)sender
{
    if (self.doneBlock) {
        NSMutableSet* set = [NSMutableSet setWithCapacity:30];
        for (CTHQuestionTags* tag in self.groupTags) {
            [set unionSet:tag.selectedTags];
        }
        self.doneBlock([set allObjects], nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAction:(id)sender
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入要添加的标签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    @weakify(av)
    CTHQuestionTags* questionTags = self.groupTags[[sender tag]];
    [av.rac_buttonClickedSignal subscribeNext:^(id buttonIndex) {
        @strongify(av)
        if (av.cancelButtonIndex != [buttonIndex integerValue]) {
            [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"addTagInfo",
                                               @"tagInfo":@{@"tagTypeId":questionTags.id,
                                                            @"subjectType":self.subject.subjecttype,
                                                            @"topic Tag":[av textFieldAtIndex:0].text,
                                                            @"userName":@"linjinxing"}
                                               },
                                             @"result",
                                              [CTHQuestionTagItem class])
             subscribeNext:^(CTHQuestionTagItem* item) {
//                [self showHUDAndHidWithStr:kLJXAddSuccessTip];
                questionTags.tags = [questionTags.tags arrayByAddObject:item];
                 LJXPerformBlockAsynOnMainThread(^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[sender tag] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                 });
            } error:^(NSError *error) {
                [self showErrorHUD:error];
            }];
        };
    }];
}

- (IBAction)editAction:(id)sender
{
    void(^reloadCell)() = ^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[sender tag] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    };
    CTHQuestionTags* qTags = self.groupTags[[sender tag]];
    if (qTags.isEditing) {
        qTags.isEditing = NO;
        reloadCell();
        return;
    }
    
    if ([qTags.tags.rac_sequence any:^BOOL(id value) {
        return [[value userName] length];
    }]){
        qTags.isEditing = YES;
        reloadCell();
    }else{
        [self showHUDAndHidWithStr:@"没有可编辑的标签"];
    }
}

- (NSArray*)tagsForTableViewIndex:(NSInteger)tvIndex
{
    return [(CTHQuestionTags*)self.groupTags[tvIndex] tags];
}

#pragma mark - Table view delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagsTableViewCell *cell = (CTHQuestionTagsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    CTHQuestionTags* tag = self.groupTags[indexPath.row];
    // Configure the cell...
    [cell.btnEdit setTitle:tag.isEditing ? LJXButtonTitleDone : LJXButtonTitleEdit forState:UIControlStateNormal];
    cell.label.text = tag.typeName;
    cell.collectionView.tag = cell.btnAdd.tag = cell.btnEdit.tag = indexPath.row;
    [cell.collectionView reloadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
    return [self.cellHeights[indexPath.row] floatValue];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.groupTags[collectionView.tag] tags] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagsCollectionViewCell *cell = (CTHQuestionTagsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    CTHQuestionTags* tags = self.groupTags[collectionView.tag];
    CTHQuestionTagItem* item  = [self tagsForTableViewIndex:collectionView.tag][indexPath.row];
    // Configure the cell
    [cell.btn setTitle:item.topicTag forState:UIControlStateNormal];
    cell.btn.selected = [tags.selectedTags containsObject:item] && !tags.isEditing;
    cell.btn.enabled = !tags.isEditing;
    cell.bDeleteViewHidden = !(tags.isEditing && [item.userName length]);
    
    [cell.disposable dispose];
    /* 当用户点击按钮时调用subscribeNext */
    cell.disposable = [[cell.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* btn) {
        NSArray* multiSelectItems = @[@"错因分析", @"自定义标签"];
        if (![multiSelectItems containsObject:tags.typeName]) {
            [tags.selectedTags removeAllObjects];
        }
        if (btn.isSelected) {
            [tags.selectedTags addObject:item];
        }else{
            [tags.selectedTags removeObject:item];
        }
        [collectionView reloadData];
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagItem* item  = [self tagsForTableViewIndex:collectionView.tag][indexPath.item];
    UILabel* lable = [[UILabel alloc] init];
    lable.text = item.topicTag;
    [lable sizeToFit];
    CGSize size = lable.frame.size;
    size.height += 8;
    size.width += 18;
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTHQuestionTags* questionTags = self.groupTags[collectionView.tag];
    CTHQuestionTagItem* item  = questionTags.tags[indexPath.item];
    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"delTagInfo",
                                        @"tagInfoId":item.id
                                        },
                                      @"result",
                                      [CTHQuestionTagItem class])
     subscribeNext:^(CTHQuestionTagItem* item) {
         //                [self showHUDAndHidWithStr:kLJXAddSuccessTip];
         questionTags.tags = [questionTags.tags arrayByRemoveObjectWitBlock:^BOOL(id obj) {
             return [[obj topicTag] isEqualToString:item.topicTag];
         }];
         LJXPerformBlockAsynOnMainThread(^{
             [collectionView reloadData];
         });
     } error:^(NSError *error) {
         [self showErrorHUD:error];
     }];

}

@end
