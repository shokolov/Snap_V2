//
//  SignInViewController.m
//  SnapChat_V2
//
//  Created by KimByungyoon on 2013/10/06.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize account;
@synthesize password;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doButtonDown:(id)sender {
    NSLog(@"newAccount:%@", account.text);
    NSLog(@"newPassword:%@", password.text);
    [self performSegueWithIdentifier:@"cameraSegue" sender:self];
    
}
@end
