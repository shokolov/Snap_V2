//
//  SelectViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "SelectViewController.h"
#import "Friend.h"
#import "AFHTTPRequestOperationManager.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

@synthesize secInfo, sendImage;

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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"userCode": @"userCode"};
    [manager GET:@"http://211.239.124.234:13405/friend"
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSString *string = [[NSString alloc] initWithData:responseObject
                                                      encoding:NSUTF8StringEncoding];
             NSLog(@"JSON1: %@", string);
             
             NSError *error;
             NSMutableArray *friendArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error];
             if(error) {
                 NSLog(@"%@", [error localizedDescription]);
                 
             } else {
                 for (int i = 0; i < friendArray.count; i++) {
                     Friend *friend = [[Friend alloc] init];
                     friend.code = [[friendArray objectAtIndex:i] valueForKey:@"code"];
                     friend.name = [[friendArray objectAtIndex:i] valueForKey:@"name"];
                     [self.friends addObject:friend];
                 }
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
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
    [self.sendButton setEnabled:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    
    // sevd 버튼 비활성화
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    if (selectedIndexPaths.count < 1) {
        [self.sendButton setEnabled:NO];
    }
}

- (IBAction)sendButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^(void){
        
        NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
        NSMutableArray *selectedFriends = [NSMutableArray arrayWithCapacity: selectedIndexPaths.count];
        for (NSIndexPath *indexPath in selectedIndexPaths)
        {
            Friend *friend = (Friend*)[self.friends objectAtIndex:indexPath.row];
            [selectedFriends addObject: friend.code];
        }
        
        NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:selectedFriends, @"selectedFriends", secInfo, @"selectedSec", sendImage, @"sendImage", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_PICTURE" object:nil userInfo:infoToObject];
    }];
}
     
@end
