//
//  SelectViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "SelectViewController.h"
#import "Friend.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

@synthesize sendButton, secInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"desc3: %@", [[self navigationController] childViewControllers]);
    
    NSMutableArray *friends_ = [NSMutableArray arrayWithCapacity:20];
    
    Friend *friend = [[Friend alloc] init];
    friend.code = @"000001";
    friend.name = @"ggammo";
    [friends_ addObject:friend];
    
    friend = [[Friend alloc] init];
    friend.code = @"000002";
    friend.name = @"hhammo";
    [friends_ addObject:friend];
    
    friend = [[Friend alloc] init];
    friend.code = @"000003";
    friend.name = @"jjammo";
    [friends_ addObject:friend];
    
    self.friends = friends_;
    
    NSLog(@"SelectViewController.viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Friend *friend = (self.friends)[indexPath.row];
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.code;
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // sevd 버튼 활성화
    [sendButton setEnabled:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    
    // sevd 버튼 비활성화
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    if (selectedIndexPaths.count < 1) {
        [sendButton setEnabled:NO];
    }
}

- (IBAction)sendButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^(void){
        
        NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
        NSMutableArray *selectedFriends = [NSMutableArray arrayWithCapacity: selectedIndexPaths.count];
        for (NSIndexPath *indexPath in selectedIndexPaths)
        {
            [selectedFriends addObject: [self.friends objectAtIndex:indexPath.row]];
        }
        
        NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:selectedFriends, @"selectedFriends", secInfo, @"selectedSec", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_PICTURE" object:nil userInfo:infoToObject];
    }];
}
     
@end
