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
@property(nonatomic, strong) NSMutableArray* selectedTags;
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
     subscribeNext:^(id x) {
         self.groupTags = x;
         for (CTHQuestionTags* tag in x) {
             tag.selectedTags = [NSMutableSet setWithCapacity:30];
         }
         LJXPerformBlockAsynOnMainThread(^{
             [self.tableView reloadData];
         });
         LJXLogObject(x);
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneAction:(id)sender
{
    if (self.doneBlock) {
        self.doneBlock(self.groupTags, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
             subscribeNext:^(id x) {
                [self showHUDAndHidWithStr:kLJXAddSuccessTip];
                questionTags.tags = [questionTags.tags arrayByAddObject:x];
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
    
}

- (NSArray*)tagsForTableViewIndex:(NSInteger)tvIndex
{
    return [(CTHQuestionTags*)self.groupTags[tvIndex] tags];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return groupTags.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagsTableViewCell *cell = (CTHQuestionTagsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    CTHQuestionTags* tag = self.groupTags[indexPath.row];
    // Configure the cell...
    cell.label.text = tag.typeName;
    cell.collectionView.tag = cell.btnAdd.tag = cell.btnEdit.tag = indexPath.row;
    [cell.collectionView reloadData];

    
//    self.cellHeights[indexPath.row] = @(cell.collectionView.height + cell.label.height);
//    @weakify(cell)
//    @weakify(self)
//    [RACObserve(cell.collectionView, contentSize) subscribeNext:^(id x) {
//        @strongify(cell)
//        @strongify(self)
//        cell.collectionView.size = [x CGSizeValue];
//        self.cellHeights[indexPath.row] = @(cell.collectionView.height + cell.label.height);
//        [cell setNeedsLayout];
////        [self.tableView reloadData];
//        NSLog(@"frame:%@", NSStringFromCGRect(cell.collectionView.frame));
//    }];
    return cell;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
    return [self.cellHeights[indexPath.row] floatValue];
}

#pragma mark - UICollectionView 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.groupTags[collectionView.tag] tags] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagsCollectionViewCell *cell = (CTHQuestionTagsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    CTHQuestionTags* tags = self.groupTags[collectionView.tag];
    CTHQuestionTagItem* item  = [self tagsForTableViewIndex:collectionView.tag][indexPath.row];
    // Configure the cell
    [cell.btn setTitle:item.topicTag forState:UIControlStateNormal];
    cell.btn.selected = [tags.selectedTags containsObject:item];
    
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

//    cell.label.text = item.topicTag;
//    RAC(label, textColor) = [RACObserve(cell, isHighlighted) map:^id(id value) {
//        return [value boolValue] ? [UIColor whiteColor] : [UIColor grayColor];
//    }];
    
//    UIView* view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor clearColor]];
//    cell.backgroundView = view;
//    
//    view = [[UIView alloc] init];
//    [view setBackgroundColor:UIColorFromRGBHex(0x398cf4)];
//    cell.selectedBackgroundView = view;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CTHQuestionTagItem* item  = [self tagsForTableViewIndex:collectionView.tag][indexPath.row];
    // Configure the cell
    UILabel* lable = [[UILabel alloc] init];
    lable.text = item.topicTag;
    [lable sizeToFit];
    CGSize size = lable.frame.size;
    size.height += 8;
    size.width += 18;
    return size;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CTHQuestionTags* tags = self.groupTags[collectionView.tag];
//    NSArray* multiSelectItems = @[@"错因分析", @"自定义标签"];
//    if (![multiSelectItems containsObject:tags.typeName]) {
//        [tags.selectedTags removeAllObjects];
//    }
//    [tags.selectedTags addObject:[self tagsForTableViewIndex:collectionView.tag][indexPath.row]];
//    
//    [collectionView reloadData];
//        cell = [collectionView cellForItemAtIndexPath:indexPath];
//        cell.selected = YES;
//    self.selectedIndex = indexPath.item;
//}

@end
