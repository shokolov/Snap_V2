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

#pragma mark - Navigation

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

- (IBAction)sendButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^(void){
        
        NSLog(@"desc6: %@", [[self navigationController] childViewControllers]);
        
        NSArray *friendArray = [[NSArray alloc] initWithObjects:@"aaa", @"bbb", nil];
        NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:friendArray, @"uploadInfo", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_PICTURE" object:nil userInfo:infoToObject];
    }];
}
     
@end
