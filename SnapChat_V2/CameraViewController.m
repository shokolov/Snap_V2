//
//  CameraViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "CameraViewController.h"
#import "UploadViewController.h"
#import "AFHTTPRequestOperationManager.h"

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
        
        //[self presentViewController:imagePickerController animated:YES completion:nil];
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
        
        [self upload:friendList secInfo:secInfo];
    }
    
}

#pragma mark - private

- (void)upload:(NSArray*)friendList secInfo:(NSInteger)secInfo  {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"friendList": friendList, @"secInfo":@"secInfo"};
    
    // 이미지크기 조절
    /*
     UIImage *image_ = takenImage;
     float resizeWidth = 150;
     float resizeHeight = image_.size.width/(image_.size.height/150);
     
     CGSize newSize=CGSizeMake(resizeWidth, resizeHeight);
     UIGraphicsBeginImageContext(newSize);
     [image_ drawInRect:CGRectMake(0,0,resizeWidth,resizeHeight)];
     
     UIImage* scaledImage2 = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     */
    
    NSData *imageData = UIImageJPEGRepresentation(takenImage, 0.5);
    NSURL *filePath = [NSURL fileURLWithPath:@"file:/tmp/aa.jpg"];
    [manager POST:@"http://211.239.124.234:13405/test" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"name11" fileName:@"fineName22" mimeType:@"mimeType"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // 서버에는 이런식으로 전달됨
    /*
     body: { friendList: [ [Object] ], secInfo: 'secInfo' },
     files:
        { name11:
            { originalFilename: 'fineName22',
                path: '/tmp/1859-1yf6uco',
                headers: [Object],
                ws: [Object],
                size: 506540,
                name: 'fineName22' 
            } 
        },
     _body: true,
     
     [an_nodejs@youngmo server]$ ll /tmp
     合計 1076
     -rw-rw-r-- 1 an_nodejs an_nodejs   4726 11月 27 00:20 2013 1859-1kfmfya.jpg
     -rw-rw-r-- 1 an_nodejs an_nodejs   1872 11月 27 00:23 2013 1859-1veqd49.jpg
     -rw-rw-r-- 1 an_nodejs an_nodejs 506540 11月 27 01:13 2013 1859-1yf6uco
     -rw-rw-r-- 1 an_nodejs an_nodejs   3608 11月 27 00:21 2013 1859-abph5p.jpg
     -rw-rw-r-- 1 an_nodejs an_nodejs 486181 11月 27 01:11 2013 1859-mv0cu5
     -rw-rw-r-- 1 an_nodejs an_nodejs   6365 11月 27 00:19 2013 1859-ztcbmt.jpg
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

@end
