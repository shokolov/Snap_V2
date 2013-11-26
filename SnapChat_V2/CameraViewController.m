//
//  CameraViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "CameraViewController.h"
#import "UploadViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController {
    UIStoryboard *storyboard;
    UIImagePickerController *imagePickerController;
    UIImage *takenImage;
}

@synthesize flashButton, frontButton;

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
                                             selector:@selector(showPreviewPictureViewController:)
                                                 name:@"SHOW_PREVIEW_PICTURE"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(retakePicture:)
                                                 name:@"RETAKE_PICTURE"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadPicture:)
                                                 name:@"UPLOAD_PICTURE"
                                               object:nil];
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
    
    //[self presentViewController:imagePickerController animated:YES completion:^(void){ }];
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
        //[self performSegueWithIdentifier:@"friendSegue" sender:self]; // push일때는 필요없음
        NSLog(@"desc2.1: %@", [[self navigationController] childViewControllers]);
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:image, @"uiimage", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PREVIEW_PICTURE" object:nil userInfo:infoToObject];
     */
    
    takenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imagePickerController dismissViewControllerAnimated:NO completion:^(void){
        [[self navigationController] setNavigationBarHidden:NO];
        [self performSegueWithIdentifier:@"updateSegue" sender:self];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
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
    }
}

#pragma mark - NSNotificationCenter

- (void)showPreviewPictureViewController:(NSNotification*)notification
{
    if(notification)
    {
        /*
         NSDictionary* infoToObject = [notification userInfo];
         takenImage = (UIImage *)[infoToObject valueForKey:@"uiimage"];
         
         [uploadViewController setImageSource:takenImage];
         [uploadViewController.imagePicture setImage:takenImage];
         
         [imagePickerController dismissViewControllerAnimated:NO completion:^(void){
         [self presentViewController:uploadViewController animated:NO completion:nil];
         }];
         */
    }
}

- (void)retakePicture:(NSNotification*)notification
{
    
    if(notification)
    {
        /*
         [uploadViewController setImageSource:nil];
         [uploadViewController.imagePicture setImage:nil];
         
         [uploadViewController dismissViewControllerAnimated:NO completion:^(void){
         [self presentViewController:imagePickerController animated:YES completion:nil];
         }];
         */
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

- (void)uploadPicture:(NSNotification*)notification
{
    if(notification)
    {
        NSLog(@"desc5: %@", [[self navigationController] childViewControllers]);
        
        NSDictionary* infoToObject = [notification userInfo];
        NSArray *friendList = (NSArray *)[infoToObject valueForKey:@"selectedFriends"];
        NSInteger secInfo = [[infoToObject valueForKey:@"selectedSec"] intValue];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        //[self upload:friendList secInfo:secInfo];
    }
    
}

#pragma mark - private

- (void)upload:(NSArray*)friendList secInfo:(NSInteger)secInfo  {
    // 서버설정
    //NSString *urlString = @"http://211.239.124.234:13405/test";
    NSString *urlString = @"http://192.168.1.10:3000/test";
    
    NSString *boundary = @"SpecificString";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    
    // 이미지크기 조절
    UIImage *image_ = takenImage;
    float resizeWidth = 150;
    float resizeHeight = image_.size.width/(image_.size.height/150);
    
    CGSize newSize=CGSizeMake(resizeWidth, resizeHeight);
    UIGraphicsBeginImageContext(newSize);
    [image_ drawInRect:CGRectMake(0,0,resizeWidth,resizeHeight)];
    
    UIImage* scaledImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // 파일:uploadedfile, 파일명:filename
    
    // 해상도 조절, 파일이름을 만들기 : 서버에 보내기위한 준비작업
    NSData *imageData2 =UIImageJPEGRepresentation(scaledImage2, 0.7);
    NSString *tFileName=@"img";
    NSString *imageFileName= [NSString stringWithFormat:@"%@.jpg",tFileName];
    
    // http해더
    [body appendData:[[NSString stringWithFormat:
                       @"\r\n--%@\r\n",
                       boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:
                       @"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%@\"\r\n",
                       imageFileName]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData2]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",
                       boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 전송
    [request setHTTPBody:body];
    
    // 보낸결과
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"server upload done. %@", returnString);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

@end
