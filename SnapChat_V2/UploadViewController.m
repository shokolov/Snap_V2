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
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float cameraAspectRatio = 4.0 / 3.0;
    float imageWidth = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETAKE_PICTURE" object:nil userInfo:nil];
}

- (IBAction)timeAction:(id)sender {
}

- (IBAction)sendAction:(id)sender {
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
    UIImage *image_ = imageSource;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_CAMERA_AND_PREVIEW" object:nil userInfo:nil];
}

@end
