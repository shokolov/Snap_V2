//
//  HistoryCell.h
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/30.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *getButton;

@end
