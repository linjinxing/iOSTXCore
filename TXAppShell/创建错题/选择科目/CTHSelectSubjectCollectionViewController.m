//
//  CTHSelectSubjectCollectionViewController.m
//  PRJ_CTH
//
//  Created by linjinxing on 16/1/22.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHSelectSubjectCollectionViewController.h"
#import "CTHSubject.h"
#import "CTHCreateQuestionTableViewController.h"

@interface CTHSelectSubjectCollectionViewController ()
@property(assign) NSInteger selectedIndex;
@property(copy) NSArray* subjects;
@property(weak) IBOutlet UICollectionView* collectionView;
@property(weak) IBOutlet NSLayoutConstraint* layoutHeight;
@end

@implementation CTHSelectSubjectCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.layoutHeight, constant) = [RACObserve(self.collectionView, contentSize) map:^id(id value) {
        return @([value CGSizeValue].height);
    }];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    @weakify(self)
[CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getSubjects",@"userId":@"1"}, @"subjects", [CTHSubject class])
     subscribeNext:^(id x) {
//         @strongify(self)
         LJXPerformBlockAsynOnMainThread(^{
             self.subjects = x;
             [self.collectionView reloadData];
         });
         LJXLogObject(x);
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CTHCreateQuestionTableViewController* vc = (CTHCreateQuestionTableViewController*)[[segue destinationViewController] topViewController];
    vc.subject = self.subjects[self.selectedIndex];
    vc.type = [sender tag] ? @"其它题型" : @"选择题型";
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

    return self.subjects.count;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    cell.backgroundView = view;

    view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor redColor]];
    cell.selectedBackgroundView = view;
    
    [cell.contentView labelWithTag:2].text = [self.subjects[indexPath.item] subjectname];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
//    cell.selected = NO;
//    cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = YES;
    self.selectedIndex = indexPath.item;
}


@end
