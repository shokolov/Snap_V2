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

@synthesize historyList, missList;

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
    return [self.historyList count] + [self.missList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 전송 실패 건을 가장 테이블 가장 위에 표시
    NSDictionary *history = nil;
    if (self.missList.count < indexPath.row + 1) {
        int missListCount = [self.missList count];
        history = (self.historyList)[indexPath.row - missListCount];
    } else {
        history = (self.missList)[indexPath.row];
    }
    
    // 수신, 송신 표시
    NSString *typeText = @"";
    if ([[history valueForKey:@"type"] isEqualToString:@"99"]) {
        cell.url = [history valueForKey:@"img"];
        cell.typeLabel.text = @"!";
        cell.getButton.hidden = YES;
        cell.uploadButton.hidden = NO;
        typeText = @"へ失敗";
        
    } else if ([[history valueForKey:@"type"] isEqualToString:@"0"]) {
        cell.url = [history valueForKey:@"img"];
        cell.typeLabel.text = @"←";
        cell.getButton.hidden = YES;
        cell.uploadButton.hidden = YES;
        typeText = @"に送信";
        
    } else if ([[history valueForKey:@"type"] isEqualToString:@"1"]) {
        cell.url = [history valueForKey:@"img"];
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = NO;
        cell.uploadButton.hidden = YES;
        typeText = @"から受信";
        
    } else {
        cell.url = [history valueForKey:@"img"];
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = YES;
        cell.uploadButton.hidden = YES;
        typeText = @"から受信";
    }
    
    // 내용(송수신 아이디)
    NSString *content = [history valueForKey:@"target"];
    content = [content stringByAppendingString:typeText];
    
    // 시간
    double unixTimeStamp =[[history valueForKey:@"createdt"] doubleValue];
    NSTimeInterval timeInterval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    NSString *dateString=[dateformatter stringFromDate:date];
    
    cell.contentLabel.text = content;
    cell.dateLabel.text = dateString;
    
    // 이미지 표시 시간, _id을 저장
    cell.sec = [@([[history valueForKey:@"sec"] integerValue]) stringValue];
    cell._id = [history valueForKey:@"msghistoryseq"];
    
    return cell;
}

- (IBAction)chatAction:(id)sender
{
    NSLog(@"HistoryViewController.chatAction");
}

- (IBAction)uploadAction:(id)sender {
    NSLog(@"HistoryViewController.uploadAction");
    
    NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [sender valueForKey:@"target"], @"target",
                                  [sender valueForKey:@"sec"], @"sec",
                                  [sender valueForKey:@"img"], @"img",
                                  true, @"missUpload",
                                  nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_PICTURE" object:nil userInfo:infoToObject];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 설정이미지 표시 초값 전달
    ChatViewController *chatViewController = [segue destinationViewController];
    
    // 서버 연결이 안될 경우를 대비해서 디폴트 이미지를 먼저 셋팅
    UIImage *image = [UIImage imageNamed: @"download_001.png"];
    
    NSString *imageUrl = [(HistoryCell *)sender url];

    NSString *forceUrlstring = [NSString stringWithFormat:@"%@", imageUrl];
    NSURL *url = [NSURL URLWithString:forceUrlstring];
    NSData *data = nil;
    
    if ([NSURL fileURLWithPath:forceUrlstring]) {
        // 전송 실패했던 이미지를 보는 경우
        NSString *path = [url path];
        data = [[NSFileManager defaultManager] contentsAtPath:path];
        
    } else {
        // 수신한 이미지를 보는 경우
        data = [NSData dataWithContentsOfURL:url];
    }
    image = [[UIImage alloc] initWithData:data];
    
    // 이미지, 테이블 셀을 전달
    [chatViewController setImageSource:image];
    [chatViewController setHistoryCell:sender];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = (HistoryCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.getButton.isHidden == NO || cell.uploadButton.isHidden == NO) {
        [self performSegueWithIdentifier:@"chatSegue" sender:cell];
    }
}

@end
