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

@synthesize imageSource, imagePicture;

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
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 0.0;
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

- (IBAction)saveAction:(id)sender
{
    UIImage *image = imagePicture.image;
    if(nil != image ) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
                                                    message:@"Complete"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)retakePicture:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];  // MEMO 安: 이건 push일 경우, 여기선 modal이라 해당 안 됨
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)timeAction:(id)sender {
    [self.secPicker setDelegate:self];
    [self.secPicker setDataSource:self];
    
    [self.secPicker setHidden:NO];
}

- (IBAction)sendAction:(id)sender
{
    [[self navigationController] setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"selectSegue" sender:self];
}

- (IBAction)pancilAction:(id)sender {
    opacity = 1.0;
}

- (IBAction)eraserAction:(id)sender {
    self.imagePicture.image = imageSource;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 설정한 초값 전달
    if ([[segue identifier] isEqualToString:@"selectSegue"])
    {
        SelectViewController *selectViewController = [segue destinationViewController];
        
        NSInteger secRow = [self.secPicker selectedRowInComponent:0];
        [selectViewController setSecInfo: [secArray objectAtIndex:secRow]];
        [selectViewController setSendImage:imagePicture.image];
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
    [self.secPicker setHidden:YES];
    
    NSString *buttonTitle = [[secArray objectAtIndex:row] stringByAppendingString:@" Sec"];
    [self.timeButton setTitle:buttonTitle forState:UIControlStateNormal];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[secArray objectAtIndex:row] stringByAppendingString:@" Sec"];
}

#pragma mark - Paint

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.imagePaint.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imagePaint.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.imagePaint setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.imagePaint.image drawInRect:CGRectMake(0,
                                                     0,
                                                     self.view.frame.size.width,
                                                     self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.imagePaint.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.imagePicture.frame.size);
    [self.imagePicture.image drawInRect:CGRectMake(0,
                                                   0,
                                                   self.imagePicture.frame.size.width,
                                                   self.imagePicture.frame.size.height)
                              blendMode:kCGBlendModeNormal
                                  alpha:1.0];
    [self.imagePaint.image drawInRect:CGRectMake(0,
                                                 0,
                                                 self.imagePaint.frame.size.width,
                                                 self.imagePaint.frame.size.height)
                            blendMode:kCGBlendModeNormal
                                alpha:opacity];
    self.imagePicture.image = UIGraphicsGetImageFromCurrentImageContext();
    self.imagePaint.image = nil;
    UIGraphicsEndImageContext();
}

@end
