//
//  MainViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/10/20.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController, UploadViewController;

@interface MainViewController : UIViewController

@property (nonatomic, strong) CameraViewController *cameraViewController;
@property (nonatomic, strong) UploadViewController *uploadViewController;

- (IBAction)openCamera:(id)sender;

@end
