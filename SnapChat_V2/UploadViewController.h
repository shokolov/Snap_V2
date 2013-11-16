//
//  UploadViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/16.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController
{
    UIImage *imageSource;
}

@property (nonatomic, retain) IBOutlet UIImageView *imagePicture;
@property (nonatomic, retain) UIImage *imageSource;

-(IBAction)saveAction:(id)sender;
-(IBAction)retakePicture:(id)sender;
- (IBAction)timeAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
