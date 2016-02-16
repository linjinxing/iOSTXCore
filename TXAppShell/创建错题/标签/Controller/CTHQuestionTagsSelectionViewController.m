//
//  CTHQuestionTagsTableViewController.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHQuestionTagsSelectionViewController.h"
#import "CTHQuestionTagsCollectionViewCell.h"
#import "CTHQuestionTagsCollectionViewHeader.h"
#import "CTHQuestionTags.h"
#import "CTHQuestionTagItem.h"

@interface CTHQuestionTagsSelectionViewController ()
@property(nonatomic, strong) NSArray* groupTags;
@end

@implementation CTHQuestionTagsSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getTagInfos",
                                     @"subjectType":self.subject.subjectType,
                                     @"userName":@"linjinxing"},
                                   @"result",
                                   [CTHQuestionTags class])
     subscribeNext:^(NSArray* tags) {
         self.groupTags = tags;
         for (CTHQuestionTags* tag in tags) {
             tag.selectedTags = [NSMutableSet setWithCapacity:30];
         }
         LJXPerformBlockAsynOnMainThread(^{
             [self.collectionView reloadData];
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
                                                            @"subjectType":self.subject.subjectType,
                                                            @"topic Tag":[av textFieldAtIndex:0].text,
                                                            @"userName":@"linjinxing"}
                                               },
                                             @"result",
                                              [CTHQuestionTagItem class])
             subscribeNext:^(CTHQuestionTagItem* item) {
//                [self showHUDAndHidWithStr:kLJXAddSuccessTip];
                questionTags.tags = [questionTags.tags arrayByAddObject:item];
                 LJXPerformBlockAsynOnMainThread(^{
                     [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[sender tag]]];
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
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[sender tag]]];
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

- (CTHQuestionTagItem*)itemForIndexPath:(NSIndexPath*)ip
{
    return [(CTHQuestionTags*)self.groupTags[ip.section] tags][ip.item];
}


- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTHQuestionTags* questionTags = self.groupTags[indexPath.section];
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
             [self. collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
         });
     } error:^(NSError *error) {
         [self showErrorHUD:error];
     }];
    
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.groupTags.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.groupTags[section] tags] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CTHQuestionTagsCollectionViewHeader* reusableView = (CTHQuestionTagsCollectionViewHeader*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header"  forIndexPath:indexPath];
    reusableView.btnEdit.tag = reusableView.btnAdd.tag = indexPath.section;
    CTHQuestionTags* tag = self.groupTags[indexPath.section];
    [reusableView.btnEdit setTitle:tag.isEditing ? LJXButtonTitleDone : LJXButtonTitleEdit forState:UIControlStateNormal];
    reusableView.label.text = tag.typeName;
    return reusableView;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagsCollectionViewCell *cell = (CTHQuestionTagsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    CTHQuestionTags* tags = self.groupTags[indexPath.section];
    CTHQuestionTagItem* item  = [self itemForIndexPath:indexPath];
    // Configure the cell
    [cell.btn setTitle:item.topicTag forState:UIControlStateNormal];
    cell.btn.selected = [tags.selectedTags containsObject:item] && !tags.isEditing;
    cell.btn.enabled = !tags.isEditing;

    cell.btnDelete.enabled = tags.isEditing;
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
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }];
    
    [cell.deleteDisposable dispose];
    @weakify(self)
    cell.deleteDisposable = [[cell.btnDelete rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* btn) {
        @strongify(self)
        [self deleteItemAtIndexPath:indexPath];
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagItem* item  = [self itemForIndexPath:indexPath];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:item.topicTag forState:UIControlStateNormal];
    [btn sizeToFit];
    CGSize size = btn.size;
    size.height += 8;
    size.width += 24;
    return size;
}


@end
