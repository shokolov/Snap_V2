//
//  LogInViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "LogInViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SFHFKeychainUtils.h"

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
	
    // TODO 安
    // 테스트용으로 유저 아이디를 입력(유저 아이디:알림 토큰의 10자리, 비밀번호는 무시)
    // 등록된 유저 아이디가 없을 경우, 서버에서는 자동으로 신규 등록을 해버린다.
    NSString *testLoginId = @"shokolov";
    [account setText:testLoginId];
    
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
                     NSError *error;
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     NSString *oldUsername = [defaults objectForKey:@"USERNAME"];
                     if (![oldUsername isEqualToString:account.text]) {
                          [SFHFKeychainUtils deleteItemForUsername:oldUsername andServiceName:@"SnapChatApp" error:&error];
                     }
                     [defaults setObject:account.text forKey:@"USERNAME"];
                     [SFHFKeychainUtils storeUsername:account.text andPassword:password.text forServiceName:@"SnapChatApp" updateExisting:YES error:&error];

                     [self performSegueWithIdentifier:@"cameraSegue" sender:self];
                 } else {
                     
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
