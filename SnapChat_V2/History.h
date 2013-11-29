//
//  History.h
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (weak, nonatomic) IBOutlet UIButton *getChat;

@end
