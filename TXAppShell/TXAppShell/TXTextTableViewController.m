//
//  TXTextTableViewController.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/22.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "TXTextTableViewController.h"
static NSString * const reuseIdentifier = @"Cell";

@interface TXTextTableViewController ()
@property(weak) IBOutlet UICollectionView* cv;
@end

@implementation TXTextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self.cv, contentSize) subscribeNext:^(id x) {
        CGRect frame = self.cv.frame;
        frame.size = [x CGSizeValue];
        self.cv.frame = frame;
        [self.tableView reloadData];
        NSLog(@"frame:%@", NSStringFromCGRect(frame));
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

#pragma mark - 
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UILabel* lable = [[UILabel alloc] init];
    NSArray* texts = @[@"不洒淡人",@"有",@"不不砂",@"我有",@"不洒淡人不我有",@"砂浊我有",@"不洒淡人不砂浊我有",@"不洒淡人不砂有",@"不洒我有"];
    lable.text = texts[indexPath.item % texts.count];
    lable.tag = 10;
    lable.textColor = [UIColor orangeColor];
    [cell.contentView addSubview:lable];
    [lable sizeToFit];
    lable.backgroundColor = [UIColor grayColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UILabel* lable = [[UILabel alloc] init];
    NSArray* texts = @[@"不洒淡人",@"有",@"不不砂",@"我有",@"不洒淡人不我有",@"砂浊我有",@"不洒淡人不砂浊我有",@"不洒淡人不砂有",@"不洒我有"];
    lable.text = texts[indexPath.item % texts.count];
    [lable sizeToFit];
    return lable.frame.size;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cv.frame.size.height;
}

//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
