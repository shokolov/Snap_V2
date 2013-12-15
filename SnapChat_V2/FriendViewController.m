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
    
    //NSDictionary *parameters = @{@"code": testLoginId};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"LOGIN_ID"];
    NSDictionary *parameters = @{@"code": username};
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
                 NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
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
