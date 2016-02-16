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
#import "UserManager.h"

@interface CTHSelectSubjectCollectionViewController ()
@property(strong) NSIndexPath* selectedIndex;
//@property(copy) NSArray* subjects;
@property(strong) NSArray* subjectNames;
@property(strong) NSArray* subjectTypeNames;
@property(weak) IBOutlet UICollectionView* collectionView;
@property(weak) IBOutlet UIView* viewButtons;
@property(weak) IBOutlet UICollectionViewFlowLayout* layout;
@end

@implementation CTHSelectSubjectCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subjectNames = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"政治",@"地理",@"历史",@"生物"];
    self.subjectTypeNames = @[@"chinese",@"math",@"english",@"physics",@"chemistry",@"biology",@"politics",@"history",@"geography"];
//    RAC(self.layoutHeight, constant) = [RACObserve(self.collectionView, contentSize) map:^id(id value) {
//        return @([value CGSizeValue].height);
//    }];
    CGFloat width = [LJXUISystemMetric screenWidth] /5;
    self.layout.itemSize = CGSizeMake(width, width);
    
    [[self.view rac_signalForSelector:@selector(hitTest:withEvent:)] subscribeNext:^(RACTuple* tuple) {
        CGPoint point1 = [self.view convertPoint:[tuple.first CGPointValue] toView:self.collectionView];
        CGPoint point2 = [self.view convertPoint:[tuple.first CGPointValue] toView:self.viewButtons];
        if (![self.collectionView pointInside:point1 withEvent:nil]
            && ![self.viewButtons pointInside:point2 withEvent:nil]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
//    UITapGestureRecognizer* ges = [[UITapGestureRecognizer alloc] init];
//    [self.view addGestureRecognizer:ges];
//    @weakify(self)
//    [[ges rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer* tap) {
//        @strongify(self)
//        CGPoint p = [tap locationInView:self.collectionView];
//        CGPoint p1 = [tap locationInView:self.view];
//        NSLog(@"p:%@, p1:%@, %s", NSStringFromCGPoint(p), NSStringFromCGPoint(p1), [self.collectionView pointInside:p withEvent:nil] ? "yes" : "no");
////        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    @weakify(self)
//    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getSubjects",@"userId":@([UserManager getPupilId])}, @"subjects", [CTHSubject class])
//     subscribeNext:^(id x) {
////         @strongify(self)
//         LJXPerformBlockAsynOnMainThread(^{
//             self.subjects = x;
//             [self.collectionView reloadData];
//         });
//         LJXLogObject(x);
//     } error:^(NSError *error) {
//         LJXNSError(error);
//     }];
    
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


- (IBAction)select:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        UINavigationController* naviCtrl = (UINavigationController*)[CTHCreateQuestionTableViewController prsentInStoryboard:@"CreateWrongQuestions"];
        CTHCreateQuestionTableViewController* vc = (CTHCreateQuestionTableViewController*)naviCtrl.topViewController;
        CTHSubject* sub = [[CTHSubject alloc] init];
        sub.subjectName = self.subjectNames[self.selectedIndex.item];
        sub.subjectType = self.subjectTypeNames[self.selectedIndex.item];
        vc.subject = sub;
        vc.type = [sender tag] ? @"其它题型" : @"选择题";
    }];
//    @weakify(self)
//    vc.dismiss = ^{
//        @strongify(self)
//        [self dismissViewControllerAnimated:NO completion:nil];
//    };
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//}

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

    return self.subjectNames.count;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
//    UIView* view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor lightGrayColor]];
//    cell.backgroundView = view;
//
//    view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor redColor]];
//    cell.selectedBackgroundView = view;
    
    NSString* subjectName = self.subjectNames[indexPath.item];//[self.subjects[indexPath.item] subjectName];
    [cell.contentView labelWithTag:2].text = subjectName;
    UIImageView* imageView = [cell.contentView imageViewWithTag:1];
    imageView.image = [UIImage imageNamed:[subjectName stringByAppendingString:@"2"]];
    imageView.highlightedImage = [UIImage imageNamed:subjectName];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.selectedIndex];
    [cell.contentView imageViewWithTag:1].highlighted = NO;
    [cell.contentView labelWithTag:2].textColor = [UIColor blackColor];
    
    cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell.contentView imageViewWithTag:1].highlighted = YES;
    [cell.contentView labelWithTag:2].textColor = [UIColor blueColor];
    self.selectedIndex = indexPath;
}


@end
