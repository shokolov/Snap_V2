//
//  FriendViewController.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/17.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *friends;

- (IBAction)backAction:(id)sender;

@end
