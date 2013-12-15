//
//  LogInViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "LogInViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

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
	
    NSString *testLoginId = @"shokolov";
    [account setText:testLoginId];
    [password setText:testLoginId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doButtonDown:(id)sender {
    NSLog(@"account:%@", account.text);
    NSLog(@"password:%@", password.text);
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICE_TOKEN"];
        NSDictionary *parameters = @{@"code": account.text,
                                     @"password": password.text,
                                     @"token": token};
        
        [manager POST:@"http://54.238.237.80/login"
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {

                 NSString *string = [[NSString alloc] initWithData:responseObject
                                                          encoding:NSUTF8StringEncoding];
                 NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
                 NSLog(@"RESPONSE: %@", [[jsonObject valueForKey:@"params"] valueForKey:@"login"]);
                 if([[[jsonObject valueForKey:@"params"] valueForKey:@"login"]
                     isEqualToString:@"success"]) {
                     
                     [[NSUserDefaults standardUserDefaults] setObject:account.text forKey:@"LOGIN_ID"];
                     
                     [self performSegueWithIdentifier:@"cameraSegue" sender:self];
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle:@"ログイン情報ちがうで！"
                                           message:@"IDとpassword確認してね"
                                           delegate:self
                                           cancelButtonTitle:@"OK！" otherButtonTitles:nil];
                     [alert show];

                 }

             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }
         ];
        
    } else {
        // 카메라가 없으면 로그인 거부
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please use the camera phone."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
