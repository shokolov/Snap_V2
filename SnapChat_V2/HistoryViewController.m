//
//  HistoryViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "ChatViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize historyList;

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
    return [self.historyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *history = (self.historyList)[indexPath.row];
    
    // 수신, 송신 표시
    if ([[history valueForKey:@"type"] intValue] == 0) {
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = NO;
    } else if ([[history valueForKey:@"type"] intValue] == 1) {
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = YES;
    } else {
        cell.typeLabel.text = @"←";
        cell.getButton.hidden = YES;
    }
    
    // 이미지 표시 시간, 아이디, 시간을 표시
    NSString *content = [history valueForKey:@"sec"];
    content = [content stringByAppendingString:@"sec ID:"];
    content = [content stringByAppendingString:[history valueForKey:@"name"]];
    content = [content stringByAppendingString:@"("];
    content = [content stringByAppendingString:[history valueForKey:@"time"]];
    content = [content stringByAppendingString:@")"];
    cell.contentLabel.text = content;
    
    // 이미지 표시 시간, _id를 저장
    cell.sec = [history valueForKey:@"sec"];
    cell._id = [history valueForKey:@"_id"];
    return cell;
}

- (IBAction)chatAction:(id)sender
{
    NSLog(@"HistoryViewController.chatAction");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 설정이미지 표시 초값 전달
    ChatViewController *chatViewController = [segue destinationViewController];
    
    // 서버 연결이 안될 경우를 대비해서 디폴트 이미지를 먼저 셋팅
    //UIImage *image = [UIImage imageNamed: @"download_001.png"];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pixabay.com/static/uploads/photo/2013/03/29/13/39/download-97607_150.png"]]];
    
    // 이미지, 테이블 셀을 전달
    [chatViewController setImageSource:image];
    [chatViewController setHistoryCell:sender];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = (HistoryCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.getButton.isHidden == NO) {
        [self performSegueWithIdentifier:@"chatSegue" sender:cell];
    }
}

@end
