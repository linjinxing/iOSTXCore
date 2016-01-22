//
//  TXTestCollectionViewController.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/22.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "TXTestCollectionViewController.h"

@interface TXTestCollectionViewController ()

@end

@implementation TXTestCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    lable.tag = 10;
    lable.textColor = [UIColor redColor];
    [lable sizeToFit];
    return lable.frame.size;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
