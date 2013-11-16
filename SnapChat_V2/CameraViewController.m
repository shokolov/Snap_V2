//
//  CameraViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/04.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "CameraViewController.h"
#import "MainViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize imagePickerController;
@synthesize flashButton;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
}

- (IBAction)friendAction:(id)sender {
}

- (IBAction)frontAction:(id)sender
{
    if (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        [imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    } else {
        [imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:image, @"uiimage", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PREVIEW_PICTURE" object:nil userInfo:infoToObject];
    
}

@end
