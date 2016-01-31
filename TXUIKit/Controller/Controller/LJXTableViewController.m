//
//  LJXTableViewController.m
//  LJX
//
//  Created by lin steven on 3/29/11.
//  Copyright 2011 LJX. All rights reserved.
//


#import "LJXTableViewController.h"
//#import "UITableViewAdditions.h"

@interface LJXTableViewController()
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property(nonatomic, assign) BOOL statusBarHidden;
@property(nonatomic, assign) UIBarStyle navigationBarStyle;
@property(nonatomic, assign) BOOL navigationBarHidden;
@property(nonatomic, assign) BOOL wantFullSceen;
@end


@implementation LJXTableViewController

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//- (void)dealloc
//{
//    if ([LJXSystem isiPad]) [self bk_removeAllBlockObservers];
//}

//- (void(^)(UIViewController*, NSString*))setupTitleBlock
//{
//    return ^(UIViewController*vc, NSString* title){
//        UILabel* l = [[UILabel alloc] init];
//        l.backgroundColor = [UIColor clearColor];
//        l.textColor = [UIColor whiteColor];
//        l.font = [UIFont boldSystemFontOfSize:20];
//        l.text = title;
//        [l sizeToFit];
//        vc.navigationItem.titleView = l;
//    };
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([LJXSystem isiPad]) {
//        [self bk_addObserverForKeyPaths:@[@"title", @"navigationItem.title"] task:^(LJXTableViewController* vc, NSDictionary* keyPaths) {
//            [vc setupTitleBlock](vc, [vc valueForKeyPath:keyPath]);
//        }];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([LJXSystem isiPad]) {
//        NSString *titleString;
//        if ([self.title length]>0) {
//            titleString = self.title;
//        }
//        if ([self.navigationItem.title length]>0) {
//            titleString = self.navigationItem.title;
//        }
//        [self setupTitleBlock](self, titleString);
//    }
    //    if ([LJXSystem isiPad]) {
    //        [self setupTitleBlock](self, self.navigationItem.title);
    //    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)pushBarStatus
{
    self.navigationBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationBarStyle = self.navigationController.navigationBar.barStyle;
    
    self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    self.wantFullSceen = self.wantsFullScreenLayout;
    
    //LJXUILog("self.wantFullSceen:%d, self.statusBarStyle:%d, self.statusBarHidden:%d", self.wantFullSceen, self.statusBarStyle, self.statusBarHidden);
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

- (void)popBarStatus
{
    [self setWantsFullScreenLayout:self.wantFullSceen];
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden];
    self.navigationController.navigationBar.barStyle = self.navigationBarStyle;
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:YES];
    //LJXUILog("self.wantFullSceen:%d, self.statusBarStyle:%d, self.statusBarHidden:%d", self.wantFullSceen, self.statusBarStyle, self.statusBarHidden);
}

#pragma mark - rotate

//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations{
//    //        return UIInterfaceOrientationMaskAll;
//    if ([LJXSystem isiPad]) {
//        return UIInterfaceOrientationMaskAll;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    if ([LJXSystem isiPad]) {
//        return YES;
//    }else{
//        return (UIInterfaceOrientationPortrait == toInterfaceOrientation);
//    }
//}
//
//

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - overwrite
//- (NSArray*)indexPathsForSelectedRows
//{
//    if ([LJXSystem OSVersion] >= 5.0) {
//        return [self.tableView indexPathsForSelectedRows];
//    }
//    return nil;
//}

@end
