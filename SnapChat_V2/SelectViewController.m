//
//  SelectViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/17.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "SelectViewController.h"
#import "Friend.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"desc3: %@", [[self navigationController] childViewControllers]);
    
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
    
    NSLog(@"SelectViewController.viewDidLoad");
    
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

#pragma mark - Navigation

/*
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 NSLog(@"TableViewController.prepareForSegue");
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SelectViewController.didSelectRowAtIndexPath,%@", indexPath);
    
    UITableViewCellAccessoryType theCheckMark;
    
    theCheckMark = [tableView cellForRowAtIndexPath:indexPath].accessoryType;
    if( theCheckMark == UITableViewCellAccessoryNone )
        theCheckMark = UITableViewCellAccessoryCheckmark;
    else
        theCheckMark = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = theCheckMark;
}

- (IBAction)sendButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^(void){
        
        NSLog(@"desc6: %@", [[self navigationController] childViewControllers]);
        
        NSArray *friendArray = [[NSArray alloc] initWithObjects:@"aaa", @"bbb", nil];
        NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:friendArray, @"uploadInfo", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_PICTURE" object:nil userInfo:infoToObject];
    }];
}
     
@end
