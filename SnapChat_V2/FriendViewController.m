//
//  FriendViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/17.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "FriendViewController.h"
#import "Friend.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    NSLog(@"aaaaaaaaaaaa_initWithStyle");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSMutableArray *_friends = [NSMutableArray arrayWithCapacity:20];
    
    Friend *friend = [[Friend alloc] init];
    friend.code = @"000001";
    friend.name = @"ggammo";
    [_friends addObject:friend];
    
    friend = [[Friend alloc] init];
    friend.code = @"000002";
    friend.name = @"hhammo";
    [_friends addObject:friend];
    
    self.friends = _friends;
    
    NSLog(@"aaaaaaaaaaaa_viewDidLoad");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 0;
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Friend *friend = (self.friends)[indexPath.row];
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.code;
    
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"TableViewController.prepareForSegue");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TableViewController.didSelectRowAtIndexPath,%@", indexPath);
    
    UITableViewCellAccessoryType theCheckMark;
    
    theCheckMark = [tableView cellForRowAtIndexPath:indexPath].accessoryType;
    if( theCheckMark == UITableViewCellAccessoryNone )
        theCheckMark = UITableViewCellAccessoryCheckmark;
    else
        theCheckMark = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = theCheckMark;
}

- (IBAction)backAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CAMERA" object:nil userInfo:nil];
}
@end
