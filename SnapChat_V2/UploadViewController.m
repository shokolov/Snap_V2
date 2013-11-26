//
//  UploadViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "UploadViewController.h"
#import "SelectViewController.h"

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

    secArray = [[NSArray alloc] initWithObjects:@"3", @"5", @"10", @"30", @"60", nil];
    
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
                                                    message:@"Complete"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)retakePicture:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];  // 이건 push일 경우, 여기선 modal이라 해당 안 됨
    [self dismissViewControllerAnimated:NO completion:nil];
        
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

- (IBAction)timeAction:(id)sender {
    [secPicker setDelegate:self];
    [secPicker setDataSource:self];
    
    [secPicker setHidden:NO];
}

- (IBAction)sendAction:(id)sender
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"SELECT_FRIEND" object:nil userInfo:nil];
    
    NSLog(@"desc4: %@", [[self navigationController] description]);
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"selectSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 설정한 초값 전달
    if ([[segue identifier] isEqualToString:@"selectSegue"])
    {
        SelectViewController *selectViewController = [segue destinationViewController];
        
        NSInteger secRow = [secPicker selectedRowInComponent:0];
        [selectViewController setSecInfo: [secArray objectAtIndex:secRow]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_CAMERA_AND_PREVIEW" object:nil userInfo:nil];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [secArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [secPicker setHidden:YES];
    
    NSString *buttonTitle = [[secArray objectAtIndex:row] stringByAppendingString:@" Sec"];
    [timeButton setTitle:buttonTitle forState:UIControlStateNormal];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[secArray objectAtIndex:row] stringByAppendingString:@" Sec"];
}

@end
