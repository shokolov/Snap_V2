//
//  ChatViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController {
    NSTimer *timer;
}

@synthesize imagePicture, imageSource, countdownLabel, historyCell;

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
	
    [imagePicture setImage:imageSource];
    [countdownLabel setText:historyCell.sec];
}

- (void) viewWillDisappear:(BOOL)animated {
    // 뒤로가기 버튼으로 이동할 경우
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self completeChat];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    // 설정된 시간이 지나면 자동 화면 전환
    int secInt = [historyCell.sec intValue];
    [self performSelector:@selector(hiddenChatView)
                         withObject:nil
                         afterDelay:secInt];
    
    // 카운트다운
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(countdown)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)hiddenChatView
{
    //[self.navigationController popToRootViewControllerAnimated:YES];  // 더이상 미확인 챗이 없을 땐 바로 카메라뷰로 이동해도 좋을 듯
    [self.navigationController popViewControllerAnimated:YES];
    //[self completeChat];
}

- (void)completeChat
{
    [timer invalidate];
    [historyCell.getButton setHidden:YES];
    
    if (historyCell._id != nil) {
        NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:historyCell._id, @"_id", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"COMPLETE_CHAT" object:nil userInfo:infoToObject];
    }
}

- (void)countdown
{
    int count = [countdownLabel.text intValue];
    count--;
    countdownLabel.text = [@(count) stringValue];;
}

@end
