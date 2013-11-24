//
//  SelectViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/24.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *friends;

- (IBAction)sendButtonAction:(id)sender;

@end
