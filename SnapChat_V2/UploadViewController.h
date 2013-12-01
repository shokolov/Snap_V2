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
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

@property (nonatomic, retain) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UIImageView *imagePaint;

@property (nonatomic, retain) UIImage *imageSource;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *secPicker;

- (IBAction)saveAction:(id)sender;
- (IBAction)retakePicture:(id)sender;
- (IBAction)timeAction:(id)sender;
- (IBAction)sendAction:(id)sender;
- (IBAction)pancilAction:(id)sender;
- (IBAction)eraserAction:(id)sender;

@end
