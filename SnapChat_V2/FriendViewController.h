//
//  FriendViewController.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusFriendViewController.h"

@interface FriendViewController : UITableViewController {
    PlusFriendViewController *plusFriendViewController;
}

@property (nonatomic, strong) NSMutableArray *friends;


@end
