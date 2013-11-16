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

@interface MainViewController ()

@end

@implementation MainViewController
{
    UIStoryboard *storyboard;
    UIImagePickerController *imagePickerController;
    UIImage *savedImage;
}

@synthesize cameraViewController, uploadViewController;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPreviewPictureViewController:)
                                                 name:@"SHOW_PREVIEW_PICTURE"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(retakePicture:)
                                                 name:@"RETAKE_PICTURE"
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
