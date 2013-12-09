//
//  PlusFriendViewController.m
//  SnapChat_V2
//
//  Created by KimByungyoon on 2013/12/08.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "PlusFriendViewController.h"
#import "Friend.h"
#import "AFHTTPRequestOperationManager.h"

@interface PlusFriendViewController ()
@property(nonatomic, retain, readwrite) NSArray *dataSource;
@end

@implementation PlusFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // TODO 安
    // 테스트용으로 유저 아이디를 입력(유저 아이디:알림 토큰의 10자리, 비밀번호는 무시)
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICE_TOKEN"];
    NSString *testLoginId = @"shokolov";
    
    NSDictionary *parameters = @{@"code": testLoginId};
    parameters = @{@"token": token};
    parameters = @{@"password": @"password"};
    [manager POST:@"http://54.238.237.80/login"
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
                 NSMutableArray *friends_ = [NSMutableArray arrayWithCapacity:friendArray.count];
                 
                 for (int i = 0; i < friendArray.count; i++) {
                     Friend *friend = [[Friend alloc] init];
                     friend.code = [[friendArray objectAtIndex:i] valueForKey:@"code"];
                     //  friend.name = [[friendArray objectAtIndex:i] valueForKey:@"name"];
                     [friends_ addObject:friend];
                 }
                 self.friends = friends_;
                 [self.friendTableView reloadData];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *CellIdentifier3 = @"FriendInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
    if(cell == nil) {
        // cellのインスタンスを生成する
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier3];
    }
    Friend *friend = (self.friends)[indexPath.row];
    cell.textLabel.text = friend.code;
    //cell.detailTextLabel.text = friend.code;
    
    return cell;
}

@end
