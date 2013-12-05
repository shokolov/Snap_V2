//
//  CameraViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadViewController;

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property (nonatomic, strong) UploadViewController *uploadViewController;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

- (IBAction)captureAction:(id)sender;

- (IBAction)flashAction:(id)sender;
- (IBAction)frontAction:(id)sender;

- (IBAction)historyAction:(id)sender;
- (IBAction)friendAction:(id)sender;

@end
