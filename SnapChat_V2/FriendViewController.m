//
//  FriendViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
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
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *friends_ = [NSMutableArray arrayWithCapacity:20];
    
    Friend *friend = [[Friend alloc] init];
    friend.code = @"000001";
    friend.name = @"ggammo";
    [friends_ addObject:friend];
    
    friend = [[Friend alloc] init];
    friend.code = @"000002";
    friend.name = @"hhammo";
    [friends_ addObject:friend];
    
    self.friends = friends_;
    
    NSLog(@"FriendViewController.viewDidLoad");
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
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Friend *friend = (self.friends)[indexPath.row];
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.code;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"FriendViewController.didSelectRowAtIndexPath,%@", indexPath);
    
    UITableViewCellAccessoryType theCheckMark;
    
    theCheckMark = [tableView cellForRowAtIndexPath:indexPath].accessoryType;
    if( theCheckMark == UITableViewCellAccessoryNone )
        theCheckMark = UITableViewCellAccessoryCheckmark;
    else
        theCheckMark = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = theCheckMark;
}

@end
