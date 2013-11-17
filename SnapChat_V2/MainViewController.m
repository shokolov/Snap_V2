//
//  MainViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/10/20.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "MainViewController.h"
#import "CameraViewController.h"
#import "UploadViewController.h"
#import "FriendViewController.h"

#define CAMERA_SCALAR 1.12412 // scalar = (480 / (2048 / 480))

@interface MainViewController ()

@end

@implementation MainViewController
{
    UIStoryboard *storyboard;
    UIImagePickerController *imagePickerController;
    UIImage *savedImage;
}

@synthesize cameraViewController, uploadViewController, friendViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"MainViewController.initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"MainViewController.viewDidLoad");

    imagePickerController = [[UIImagePickerController alloc]init];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if(nil == cameraViewController){
        cameraViewController = (CameraViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    }
    if(nil == uploadViewController){
        uploadViewController = (UploadViewController*)[storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
    }
    if(nil == friendViewController){
        friendViewController = (FriendViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPreviewPictureViewController:)
                                                 name:@"SHOW_PREVIEW_PICTURE"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(retakePicture:)
                                                 name:@"RETAKE_PICTURE"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFriendList:)
                                                 name:@"SHOW_FRIEND_LIST"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MainViewController.didReceiveMemoryWarning");
}

- (IBAction)openCamera:(id)sender
{
    [self cameraDidLoad];
}

- (void)showPreviewPictureViewController:(NSNotification*)notification
{
    if(notification)
    {
        NSDictionary* infoToObject = [notification userInfo];
        UIImage *image = (UIImage *)[infoToObject valueForKey:@"uiimage"];

        [uploadViewController setImageSource:image];
        [uploadViewController.imagePicture setImage:image];

        [self previewPictureDidLoad];
    }
    
}

- (void)showFriendList:(NSNotification*)notification
{
    if(notification)
    {
        [self friendListDifLoad];
    }
}

- (void)retakePicture:(NSNotification*)notification
{
    
    if(notification)
    {
        [uploadViewController setImageSource:nil];
        [uploadViewController.imagePicture setImage:nil];
        
        [uploadViewController dismissViewControllerAnimated:NO completion:^(void){
            [self presentViewController:cameraViewController.imagePickerController animated:YES completion:nil];
        }];
    }
    
}

- (void)previewPictureDidLoad
{
    // Hide Camera View after show next view
    [cameraViewController.imagePickerController dismissViewControllerAnimated:NO completion:^(void){
        // Show PreviewPictureController
        [self presentViewController:uploadViewController animated:YES completion:nil];
    }];
}

- (void)friendListDifLoad
{
    // Hide Camera View after show next view
    [cameraViewController.imagePickerController dismissViewControllerAnimated:NO completion:^(void){
        // Show PreviewPictureController
        [self presentViewController:friendViewController animated:YES completion:nil];
    }];
}

- (void)cameraDidLoad
{
    [cameraViewController setImagePickerController: imagePickerController];
    [cameraViewController.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [cameraViewController.imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    [cameraViewController.imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    [cameraViewController.imagePickerController setDelegate:cameraViewController.self];
    [cameraViewController.imagePickerController setAllowsEditing:NO];
    [cameraViewController.imagePickerController setShowsCameraControls:NO];
    
    [cameraViewController.view setBackgroundColor:[UIColor clearColor]];
    
    [cameraViewController.imagePickerController setCameraOverlayView: cameraViewController.view];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float cameraAspectRatio = 4.0 / 3.0;
    float imageWidth = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
    
    cameraViewController.imagePickerController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    
    [self presentViewController:cameraViewController.imagePickerController animated:YES completion:^(void){
    }];
}

- (void)previewPictureDidUnLoad
{
    [uploadViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidUnload
{
    [cameraViewController.imagePickerController dismissViewControllerAnimated:YES completion:NO];
}


@end
