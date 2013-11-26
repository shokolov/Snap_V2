//
//  SelectViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *friends;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)sendButtonAction:(id)sender;

@end
