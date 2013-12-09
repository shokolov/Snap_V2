//
//  SignInViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "SignInViewController.h"
#import "AFHTTPRequestOperationManager.h"

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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICE_TOKEN"];
    NSDictionary *parameters = @{@"code": account.text,
                                 @"password": password.text,
                                 @"token": token};
    
    [manager POST:@"http://54.238.237.80/signIn"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *string = [[NSString alloc] initWithData:responseObject
                                                       encoding:NSUTF8StringEncoding];
              NSLog(@"RESPONSE: %@", string);
              
              cameraController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
              [self.navigationController pushViewController:cameraController animated:YES];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
    
}
@end
