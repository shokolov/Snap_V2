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

    NSLog(@"desc1: %@", [[self navigationController] childViewControllers]);
    
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
    
    historyBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(50, 00, 30,20)];
    historyBadge.font = [UIFont boldSystemFontOfSize:10];
    historyBadge.value = 0;
    [self updateBadge];
    
    [historyButton addSubview:historyBadge];
}

- (void)viewDidAppear:(BOOL)animated {
    [self cameraDidLoad];
}

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
    NSLog(@"desc2: %@", [[self navigationController] childViewControllers]);
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

// TODO 安: HistoryView, CameraView 두개로 나눠야 할 듯
- (void)completeChat:(NSNotification*)notification
{
    NSDictionary* infoToObject = [notification userInfo];
    NSString *_id = [infoToObject valueForKey:@"_id"];
    if (historyBadge.value == 0) {
        [historyBadge setHidden:YES];   // TODO 安: 테이블을 다시 묘사해야 할 듯
    } else {
        historyBadge.value--;
        // TODO 安: 어플 아이콘 카운트도 -1 할 것
    }
    
    // TODO 安: 확인한 챗은 _id를 서버로 전송할 것
    NSLog(@"%@", _id);
}

- (void)uploadPicture:(NSNotification*)notification
{
    if(notification) {
        NSDictionary* infoToObject = [notification userInfo];
        NSArray *friendList = (NSArray *)[infoToObject valueForKey:@"selectedFriends"];
        NSInteger secInfo = [[infoToObject valueForKey:@"selectedSec"] intValue];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        [self upload:friendList secInfo:secInfo];
    }
    
}

#pragma mark - private

- (void)upload:(NSArray*)friendList secInfo:(NSInteger)secInfo
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *secString = [@(secInfo) stringValue];
    NSDictionary *parameters = @{ @"userCode": @"userCode", @"friendList": friendList, @"secInfo":secString };
    
    NSData *imageData = UIImageJPEGRepresentation(takenImage, 0.5);
    [manager POST:@"http://211.239.124.234:13405/test"
       parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
           
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
    NSDictionary *parameters = @{@"userCode": @"userCode"};
    [manager GET:@"http://211.239.124.234:13405/history"
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"JSON1: %@", string);
             //NSLog(@"JSON2: %@", responseObject);
 
             NSError *error;
             historyArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
             if(error) {
                 NSLog(@"%@", [error localizedDescription]);
             
             } else {
                 // 미확인 메시지 건수를 취득해서, 히스토리 버튼의 뱃지 카운트를 갱신한다.
                 int newChatCount = 0;
                 for (int i = 0; i < historyArray.count; i++) {
                     NSString *chatType = [[historyArray objectAtIndex:i] valueForKey:@"type"];
                     if ([chatType isEqualToString:@"0"]) {
                         newChatCount++;
                     }
                 }
                 historyBadge.value = newChatCount;
                 
                 // 데이터를 가져온 후, 버튼을 활성화 시킨다.
                 historyButton.enabled = YES;
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

@end
