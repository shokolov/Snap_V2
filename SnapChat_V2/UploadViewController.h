//
//  UploadViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/16.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIImage *imageSource;
    NSArray *secArray;
}

@property (nonatomic, retain) IBOutlet UIImageView *imagePicture;
@property (nonatomic, retain) UIImage *imageSource;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *secPicker;

-(IBAction)saveAction:(id)sender;
-(IBAction)retakePicture:(id)sender;
- (IBAction)timeAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
