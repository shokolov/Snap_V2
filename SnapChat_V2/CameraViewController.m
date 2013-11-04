//
//  CameraViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/04.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController
{
    UIStoryboard *sb;
    UIViewController *vc;
}

@synthesize historyButton;
@synthesize captureButton;

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
	// Do any additional setup after loading the view.
    
    sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [sb instantiateViewControllerWithIdentifier:@"OverLayView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)historyButtonAction:(id)sender
{
    NSLog(@"MainViewController.historyButtonAction");
}

-(IBAction)captureButtonAction:(id)sender
{
    NSLog(@"MainViewController.captureButtonAction");
    UILabel *label = [[UILabel alloc] init];
    label.text = @"gggggggggg";
    
    historyButton.tintColor = [UIColor whiteColor];
    historyButton.titleLabel.text = @"1111";
    
    //TODO: 安
    // 사진찍기버튼이 눌리면(captureButtonAction) MainViewController로 가서 takePicture가 실행되게 할 것
    // 그리고 historyButton이 초설정 버튼으로 바뀌어야 함
}

@end
