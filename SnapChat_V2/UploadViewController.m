//
//  UploadViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/16.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize imageSource, imagePicture, secPicker, timeButton;

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

    secArray = [[NSArray alloc] initWithObjects:@"3秒", @"5秒", @"10秒", @"30秒", @"60秒", nil];
    
    [imagePicture setImage:imageSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES];
}

-(IBAction)saveAction:(id)sender
{
    UIImage *image = imageSource;
    if(nil != image )
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image"
                                                    message:@"Image was saved!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)retakePicture:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];  // 이건 push일 경우, 여기선 modal이라 해당 안 됨
    [self dismissViewControllerAnimated:NO completion:nil];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

- (IBAction)timeAction:(id)sender {
    [secPicker setDelegate:self];
    [secPicker setDataSource:self];
    
    [secPicker setHidden:NO];
}

- (IBAction)sendAction:(id)sender {
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"SELECT_FRIEND" object:nil userInfo:nil];
    
    NSLog(@"desc4: %@", [[self navigationController] description]);
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"selectSegue" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_CAMERA_AND_PREVIEW" object:nil userInfo:nil];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [secArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [secPicker setHidden:YES];
    [timeButton setTitle:[secArray objectAtIndex:row] forState:0];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [secArray objectAtIndex:row];
}

@end
