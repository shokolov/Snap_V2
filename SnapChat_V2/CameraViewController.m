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
    NSMutableArray *missArray;
}

@synthesize flashButton, frontButton, historyButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
        [historyViewController setMissList:missArray];
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
    
    // 확인한 챗은 _id를 서버로 전송
    NSLog(@"%@", _id);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *loginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOGIN_ID"];
    
    NSDictionary *parameters = @{@"code":loginId, @"msghistoryseq":_id};
    [manager POST:@"http://54.238.237.80/updateReadStatus"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *string = [[NSString alloc] initWithData:responseObject
                                                       encoding:NSUTF8StringEncoding];
              NSLog(@"JSON2: %@", string);
              
              NSError *error;
              NSMutableArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&error];
              if(error) {
                  NSLog(@"%@", [error localizedDescription]);
                  
              } else {
                  NSMutableArray *paramList = [responseJson valueForKey:@"params"];
                  NSString *result = [paramList valueForKey:@"message"];
                  NSLog(@"JSON: %@", result);
                  
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
}

- (void)uploadPicture:(NSNotification*)notification
{
    if(notification) {
        NSDictionary* infoToObject = [notification userInfo];
        NSArray *friendList = (NSArray *)[infoToObject valueForKey:@"target"];
        NSInteger secInfo = [[infoToObject valueForKey:@"sec"] intValue];
        UIImage *sendImage = (UIImage *)[infoToObject valueForKey:@"img"];
        bool missUpload = [infoToObject valueForKey:@"missUpload"];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        [self upload:friendList secInfo:secInfo sendImage:sendImage isReUpload:missUpload];
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

- (void)upload:(NSArray*)friendList secInfo:(NSInteger)secInfo sendImage:(UIImage*)sendImage isReUpload:(Boolean)isReUpload
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *secString = [@(secInfo) stringValue];
    
    NSString *loginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOGIN_ID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICE_TOKEN"];
    
    NSDictionary *parameters = @{@"send_code ": loginId,
                                 @"target": [friendList objectAtIndex:0],
                                 //@"target": friendList,
                                 @"sec":secString,
                                 @"token":token};
    
    NSData *imageData = UIImageJPEGRepresentation(sendImage, 0.5);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:@"http://54.238.237.80/sendMsg_"
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
           
           // 전송 실패시에는, 첫 전송일 경우에만 전송 실패 목록에 추가를 한다.
           //if (!isReUpload) {
               
               // TODO 安: 서버쪽에서 friendList 리스트 파라메타 대응 후에는, 1명당 송신 실패 이력이 나오도록 for문을 추가해 준다.
               NSURL *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
               NSURL *tmpDir = [[documentDir URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"tmp" isDirectory:YES];
               
               NSLog(@"tmpDir: %@", [tmpDir path]);
               
               NSNumber *now = [NSNumber numberWithDouble:CACurrentMediaTime()];
               NSString *fileName = now.stringValue;
               NSURL *fileURL = [tmpDir URLByAppendingPathComponent:fileName isDirectory:NO];
               fileURL = [fileURL URLByAppendingPathExtension:@"jpg"];
               
               if ([imageData writeToFile:[fileURL path] atomically:YES]) {
                   NSLog(@"Oh, no~~~~~");
               }
               
               // 히스토리 버튼의 뱃지 카운트를 +1
               historyBadge.value++;
               
               // 어플 아이콘의 뱃지 카운트를 +1
               [UIApplication sharedApplication].applicationIconBadgeNumber++;
               
               // 전송 실패의 셀 정보를 만들어준다.
               NSDictionary *missInfo = @{@"type": @"99",
                                          @"target": [friendList objectAtIndex:0],
                                          //@"target": friendList,
                                          @"createdt":[@(CACurrentMediaTime()) stringValue],
                                          @"sec":secString,
                                          @"img":fileURL};
               
               // 로컬에 저장되어 있는 전송 실패 리스트를 가져와서, 이번 전송 실패건을 추가해준다
               NSMutableArray *missList = [[NSUserDefaults standardUserDefaults] objectForKey:@"MISS_LIST"];
               if (missList == nil) {
                   missArray = [[NSMutableArray alloc] init];
               }
               
               [missList addObject:missInfo];
               [[NSUserDefaults standardUserDefaults] setObject:missList forKey:@"MISS_LIST"];
               
               // 테이블뷰에 넣어준다.
               [missArray addObject:missInfo];
           //}
       }
     ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

- (void)updateBadge
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *loginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOGIN_ID"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"USERNAME"];
    NSDictionary *parameters = @{@"code": username};
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
                 
                 // 미확인 메시지 건수를 취득해서, 히스토리 버튼의 뱃지 카운트를 갱신한다.
                 int newChatCount = 0;
                 for (int i = 0; i < historyArray.count; i++) {
                     NSString *chatType = [[historyArray objectAtIndex:i] valueForKey:@"type"];
                     if ([chatType isEqualToString:@"1"]) {
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
