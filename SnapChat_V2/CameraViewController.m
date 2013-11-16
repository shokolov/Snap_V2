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

- (IBAction)takePicture:(id)sender
{
    [imagePickerController takePicture];
}

- (IBAction)configureFlash:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flash"
                                                    message:@"Configure your own flash type (Auto/Off/On)!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)historyButton:(id)sender {
}

- (IBAction)friendButton:(id)sender {
}

- (IBAction)configureCameraDevice:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera device"
                                                    message:@"Configure your own camera device (Rear/Front)"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:image, @"uiimage", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PREVIEW_PICTURE" object:nil userInfo:infoToObject];
    
}

@end
