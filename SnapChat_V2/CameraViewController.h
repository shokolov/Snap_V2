//
//  CameraViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/04.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController

- (IBAction)historyButtonAction:(id)sender;
- (IBAction)captureButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@end
