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

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_BADGE" object:nil userInfo:nil];
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
    NSString *typeText = @"";
    if ([[history valueForKey:@"type"] intValue] == 0) {
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = NO;
        typeText = @"から受信";
    } else if ([[history valueForKey:@"type"] intValue] == 1) {
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = YES;
        typeText = @"から受信";
    } else {
        cell.typeLabel.text = @"←";
        cell.getButton.hidden = YES;
        typeText = @"に送信";
    }
    
    // 내용(송수신 아이디)
    NSString *content = [history valueForKey:@"code"];
    content = [content stringByAppendingString:typeText];
    
    // 시간
    double unixTimeStamp =[[history valueForKey:@"time"] doubleValue];
    NSTimeInterval timeInterval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    NSString *dateString=[dateformatter stringFromDate:date];
    
    cell.contentLabel.text = content;
    cell.dateLabel.text = dateString;
    
    // 이미지 표시 시간, _id, url을 저장
    cell.sec = [history valueForKey:@"sec"];
    cell._id = [history valueForKey:@"_id"];
    cell.url = [history valueForKey:@"url"];
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
    UIImage *image = [UIImage imageNamed: @"download_001.png"];
    
    NSString *imageUrl = @"http://an.just4fun.co.kr:13405/image/";
    NSString *imageName = [(HistoryCell *)sender url];
    imageUrl = [imageUrl stringByAppendingString:imageName];

    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    image = [[UIImage alloc] initWithData:data];
    
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
