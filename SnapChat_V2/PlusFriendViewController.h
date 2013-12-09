//
//  PlusFriendViewController.h
//  SnapChat_V2
//
//  Created by KimByungyoon on 2013/12/08.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlusFriendViewController : UIViewController <UINavigationControllerDelegate, UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *friendTableView;
@property (nonatomic, strong) NSMutableArray *friends;

@end
