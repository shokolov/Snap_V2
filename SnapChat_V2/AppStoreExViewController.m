//
//  AppStoreExViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "AppStoreExViewController.h"
#import "CameraViewController.h"

@interface AppStoreExViewController ()

@end

@implementation AppStoreExViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *oldUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_ID"];
    NSLog(@"UserName:%@", oldUsername);
    if(oldUsername !=NULL) {
        cameraController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
        [self.navigationController pushViewController:cameraController animated:YES];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
