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

@property (weak, nonatomic) IBOutlet UIButton *flashButton;

- (IBAction)captureAction:(id)sender;

- (IBAction)flashAction:(id)sender;
- (IBAction)frontAction:(id)sender;

- (IBAction)historyAction:(id)sender;
- (IBAction)friendAction:(id)sender;

@end
