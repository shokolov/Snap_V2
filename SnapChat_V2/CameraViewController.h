//
//  CameraViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/04.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, retain) IBOutlet UIImagePickerController *imagePickerController;

- (IBAction)takePicture:(id)sender;
- (IBAction)configureFlash:(id)sender;
- (IBAction)configureCameraDevice:(id)sender;

- (IBAction)historyButton:(id)sender;
- (IBAction)friendButton:(id)sender;

@end
