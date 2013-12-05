//
//  ChatViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryCell.h"

@interface ChatViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imagePicture;
@property (nonatomic, retain) UIImage *imageSource;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property HistoryCell *historyCell;

@end
