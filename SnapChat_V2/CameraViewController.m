//
//  CameraViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "CameraViewController.h"
#import "UploadViewController.h"
#import "HistoryViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MKNumberBadgeView.h"

@interface CameraViewController ()

@end

@implementation CameraViewController {
    UIStoryboard *storyboard;
    UIImagePickerController *imagePickerController;
    UIImage *takenImage;
    MKNumberBadgeView *historyBadge;
    NSMutableArray *historyArray;
}

@synthesize flashButton, frontButton, historyButton;

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

    NSLog(@"desc99: %@", [[self navigationController] childViewControllers]);
    
    imagePickerController = [[UIImagePickerController alloc]init];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadPicture:)
                                                 name:@"UPLOAD_PICTURE"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completeChat:)
                                                 name:@"COMPLETE_CHAT"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateHistoryStatus:)
                                                 name:@"UPDATE_HISTORY_STATUS"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBadge:)
                                                 name:@"UPDATE_BADGE"
                                               object:nil];
    
    historyBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(50, 00, 30,20)];
    historyBadge.font = [UIFont boldSystemFontOfSize:10];
    historyBadge.value = 0;
    [self updateBadge];
    
    [historyButton addSubview:historyBadge];
}

- (void)viewDidAppear:(BOOL)animated {
    [self cameraDidLoad];
}

// TODO 安: 이유는 모르겠지만, 여기가 두번 호출되고 있음
- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cameraDidLoad
{
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    [imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    [imagePickerController setDelegate:self];
    [imagePickerController setAllowsEditing:NO];
    [imagePickerController setShowsCameraControls:NO];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [imagePickerController setCameraOverlayView: self.view];
    
    imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0.0, 70.0);
    
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

- (IBAction)captureAction:(id)sender
{
    [imagePickerController takePicture];
}

- (IBAction)flashAction:(id)sender
{
    if (imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
        [imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
        [flashButton setTitle:@"On" forState:UIControlStateNormal];
    } else if (imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn) {
        [imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [flashButton setTitle:@"Off" forState:UIControlStateNormal];
    } else {
        [imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
        [flashButton setTitle:@"Auto" forState:UIControlStateNormal];
    }
}

- (IBAction)historyAction:(id)sender {
    [imagePickerController dismissViewControllerAnimated:NO completion:^(void){
        [[self navigationController] setNavigationBarHidden:NO];
    }];
}

- (IBAction)friendAction:(id)sender {
    [imagePickerController dismissViewControllerAnimated:NO completion:^(void){
        [[self navigationController] setNavigationBarHidden:NO];
        //[self performSegueWithIdentifier:@"friendSegue" sender:self]; // MEMO 安: push일때는 필요없음
    }];
}

- (IBAction)frontAction:(id)sender
{
    if (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        [imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        [frontButton setTitle:@"Front" forState:UIControlStateNormal];
    } else {
        [imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            [frontButton setTitle:@"Rear" forState:UIControlStateNormal];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    takenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imagePickerController dismissViewControllerAnimated:NO completion:^(void){
        [[self navigationController] setNavigationBarHidden:NO];
        [self performSegueWithIdentifier:@"updateSegue" sender:self];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
     // 잘못된 예
    UploadViewController *uploadViewController = [segue destinationViewController];
    
    [uploadViewController setImageSource:takenImage];
    [uploadViewController.imagePicture setImage:takenImage];
     */
    
    // 버튼의 이름을 초기치로 돌려준다.
    [frontButton setTitle:@"Front" forState:UIControlStateNormal];
    [flashButton setTitle:@"Auto" forState:UIControlStateNormal];
    
    if ([[segue identifier] isEqualToString:@"updateSegue"]) {
        UINavigationController *navigationController = (UINavigationController*)[segue destinationViewController];
        UploadViewController *uploadViewController_ = (UploadViewController*)[navigationController topViewController];
        
        [uploadViewController_ setImageSource:takenImage];
        [uploadViewController_.imagePicture setImage:takenImage];
        
    } else if ([[segue identifier] isEqualToString: @"historySegue"]) {
        HistoryViewController *historyViewController = (HistoryViewController *)[segue destinationViewController];
        [historyViewController setHistoryList:historyArray];
    }
}

#pragma mark - NSNotificationCenter

- (void)completeChat:(NSNotification*)notification
{
    NSDictionary* infoToObject = [notification userInfo];
    NSString *_id = [infoToObject valueForKey:@"_id"];
    if (historyBadge.value == 0) {
        [historyBadge setHidden:YES];
    } else {
        // 히스토리 버튼의 뱃지 카운트를 -1
        historyBadge.value--;
        
        // 어플 아이콘의 뱃지 카운트를 -1
        [UIApplication sharedApplication].applicationIconBadgeNumber--;
    }
    
    // TODO 安: 확인한 챗은 _id를 서버로 전송할 것
    NSLog(@"%@", _id);
    NSString *completeUrl = @"http://an.just4fun.co.kr:13405/complete/";
    completeUrl = [completeUrl stringByAppendingString:_id];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:completeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)uploadPicture:(NSNotification*)notification
{
    if(notification) {
        NSDictionary* infoToObject = [notification userInfo];
        NSArray *friendList = (NSArray *)[infoToObject valueForKey:@"selectedFriends"];
        NSInteger secInfo = [[infoToObject valueForKey:@"selectedSec"] intValue];
        UIImage *sendImage = (UIImage *)[infoToObject valueForKey:@"sendImage"];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        [self upload:friendList secInfo:secInfo sendImage:sendImage];
    }
    
}

- (void)updateHistoryStatus:(NSNotification*)notification
{
    if(notification) {
        NSDictionary* infoToObject = [notification userInfo];
        NSString *newCount = (NSString*)[infoToObject valueForKey:@"newCount"];
        
        // 히스토리 버튼의 뱃지 카운트를 갱신 시켜준다.
        historyBadge.value = [newCount intValue];
        
        // TODO 安: 히스토리 뷰에 새로도착한 챗의 리스트가 표시되도록, 테이블을 다시 그려줘야 할 듯
        [self updateBadge];
    }
}

- (void)updateBadge:(NSNotification*)notification
{
    // 히스토리 정보를 갱신해 준다.
    [self updateBadge];
}

#pragma mark - private

- (void)upload:(NSArray*)friendList secInfo:(NSInteger)secInfo sendImage:(UIImage*)sendImage
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *secString = [@(secInfo) stringValue];
    
    // TODO 安
    // 테스트용으로 유저 아이디를 입력(유저 아이디:알림 토큰의 10자리, 비밀번호는 무시)
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICE_TOKEN"];
    NSString *testLoginId = [token substringToIndex:10];

    NSDictionary *parameters = @{@"send_code ": testLoginId,
                                 @"receive_code": [friendList objectAtIndex:0],
                                 @"sec":secString };
    
    NSData *imageData = UIImageJPEGRepresentation(sendImage, 0.5);
    [manager POST:@"http://54.238.237.80/sendMsg"
       parameters:parameters
       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
           
           [formData appendPartWithFileData:imageData
                                       name:@"image"
                                   fileName:@"image.jpg"
                                   mimeType:@"image/jpeg"];
       
       } success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"Success: %@", responseObject);
           historyBadge.value++;
       
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
       }
     ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

- (void)updateBadge
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *loginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOGIN_ID"];
    
    NSDictionary *parameters = @{@"code": loginId};
    [manager POST:@"http://54.238.237.80/getNoreadMsgList"
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSString *string = [[NSString alloc] initWithData:responseObject
                                                      encoding:NSUTF8StringEncoding];
             NSLog(@"JSON1: %@", string);
 
             NSError *error;
             NSMutableArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
             if(error) {
                 NSLog(@"%@", [error localizedDescription]);
             
             } else {
                 NSMutableArray *paramList = [responseJson valueForKey:@"params"];
                 historyArray = [paramList valueForKey:@"messageList"];
                 
                 // TODO 安: 비월님 서버 연결하면서 히스토리 뱃지 카운드 갱신 부분은 주석 처리
                 
                 // 미확인 메시지 건수를 취득해서, 히스토리 버튼의 뱃지 카운트를 갱신한다.
                 /*
                 int newChatCount = 0;
                 for (int i = 0; i < historyArray.count; i++) {
                     NSString *chatType = [[historyArray objectAtIndex:i] valueForKey:@"isnew"];
                     if ([chatType isEqualToString:@"0"]) {
                         newChatCount++;
                     }
                 }
                 historyBadge.value = newChatCount;
                 */
                 
                 // 데이터를 가져온 후, 버튼을 활성화 시킨다.
                 historyButton.enabled = YES;
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

@end
