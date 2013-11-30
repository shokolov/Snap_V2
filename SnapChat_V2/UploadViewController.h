//
//  UploadViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *secArray;
}

@property (nonatomic, retain) IBOutlet UIImageView *imagePicture;
@property (nonatomic, retain) UIImage *imageSource;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *secPicker;

- (IBAction)saveAction:(id)sender;
- (IBAction)retakePicture:(id)sender;
- (IBAction)timeAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
