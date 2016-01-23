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
         [self.cellHeights setValue:@(0) withCount:self.groupTags.count];
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

- (IBAction)addAction:(id)sender
{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入要添加的标签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    @weakify(av)
    CTHQuestionTags* tags = self.groupTags[[sender tag]];
    [av.rac_buttonClickedSignal subscribeNext:^(id buttonIndex) {
        @strongify(av)
        if (av.cancelButtonIndex != [buttonIndex integerValue]) {
            CTHURLJSONConnectionCreateSignal(@{@"dataType":@"addTagInfo",
                                               @"tagInfo":@{@"tagTypeId":@"11",
                                                            @"subjectType":self.subject.subjecttype,
                                                            @"topic Tag":[av textFieldAtIndex:0].text,
                                                            @"userName":@"linjinxing"}
                                               },
                                             nil,
                                             nil);
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
    cell.collectionView.tag = indexPath.row;
//    [cell.collectionView registerClass:[CTHQuestionTagsCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [cell.collectionView reloadData];

    self.cellHeights[indexPath.row] = @(cell.collectionView.height + cell.label.height);
    @weakify(cell)
    @weakify(self)
    [RACObserve(cell.collectionView, contentSize) subscribeNext:^(id x) {
        @strongify(cell)
        @strongify(self)
        cell.collectionView.size = [x CGSizeValue];
        self.cellHeights[indexPath.row] = @(cell.collectionView.height + cell.label.height);
        [cell setNeedsLayout];
//        [self.tableView reloadData];
        NSLog(@"frame:%@", NSStringFromCGRect(cell.collectionView.frame));
    }];
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
    
    CTHQuestionTagItem* item  = [self tagsForTableViewIndex:collectionView.tag][indexPath.row];
    // Configure the cell
    LJXLogObject([cell.contentView buttonWithTag:1]);
    [cell.btn setTitle:item.topicTag forState:UIControlStateNormal];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//        cell = [collectionView cellForItemAtIndexPath:indexPath];
//        cell.selected = YES;
//    self.selectedIndex = indexPath.item;
}

@end
