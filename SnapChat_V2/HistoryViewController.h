//
//  HistoryViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *historyList;

- (IBAction)chatAction:(id)sender;

@end
