//
//  FriendViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "FriendViewController.h"
#import "Friend.h"
#import "AFHTTPRequestOperationManager.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

NSString *CellIdentifier = @"FriendCell";


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
    // タイトルを設定
    self.title = @"MyFriends";
    
    // バーにボタンを追加
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithTitle:@"Find"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(showNextView:)];
    
    // ナビゲーションバーの右にボタンをセット
    self.navigationItem.rightBarButtonItem = button;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // TODO 安
    // 테스트용으로 유저 아이디를 입력(유저 아이디:알림 토큰의 10자리, 비밀번호는 무시)
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICE_TOKEN"];
    NSString *testLoginId = [token substringToIndex:10];
    
    NSDictionary *parameters = @{@"code": testLoginId};
    
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
                 NSMutableArray *friends_ = [NSMutableArray arrayWithCapacity:friendArray.count];
                 
                 for (int i = 0; i < friendArray.count; i++) {
                     Friend *friend = [[Friend alloc] init];
                     friend.code = [[friendArray objectAtIndex:i] valueForKey:@"code"];
                   //  friend.name = [[friendArray objectAtIndex:i] valueForKey:@"name"];
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

/**
 * 次へボタンがタップされたとき
 */
- (void)showNextView:(id)sender
{
    plusFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlusFriend"];
    [self.navigationController pushViewController:plusFriendViewController animated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        // cellのインスタンスを生成する
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Friend *friend = (self.friends)[indexPath.row];
    cell.textLabel.text = friend.code;
    //cell.detailTextLabel.text = friend.code;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"FriendViewController.didSelectRowAtIndexPath,%@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.detailTextLabel.text = @"Test Friend Info";

    
}

@end
