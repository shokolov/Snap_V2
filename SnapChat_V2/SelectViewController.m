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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 로그인시 저장했던 아이디를 꺼내온다.
    NSString *loginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOGIN_ID"];
    
    NSDictionary *parameters = @{@"code": loginId};
    
    [manager POST:@"http://54.238.237.80/friend_selectList"
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSString *string = [[NSString alloc] initWithData:responseObject
                                                      encoding:NSUTF8StringEncoding];
             NSLog(@"JSON1: %@", string);
             
             NSError *error;
             NSMutableArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error];
             if(error) {
                 NSLog(@"%@", [error localizedDescription]);
                 
             } else {
                 NSMutableArray *paramList = [responseJson valueForKey:@"params"];
                 NSMutableArray *friendList = [paramList valueForKey:@"friendsList"];
                 NSMutableArray *friends_ = [NSMutableArray arrayWithCapacity:friendList.count];
                 
                 for (int i = 0; i < friendList.count; i++) {
                     Friend *friend = [[Friend alloc] init];
                     friend.code = [[friendList objectAtIndex:i] valueForKey:@"f_code"];
                     [friends_ addObject:friend];
                 }
                 self.friends = friends_;
                 [self.tableView reloadData];
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
    cell.textLabel.text = friend.code;
    
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
