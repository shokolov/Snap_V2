//
//  HistoryViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "HistoryViewController.h"
#import "History.h"
#import "HistoryCell.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize historyList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"desc7: %@", [[self navigationController] childViewControllers]);
    NSLog(@"HistoryViewController.viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *history = (self.historyList)[indexPath.row];
    
    if ([[history valueForKey:@"type"] intValue] == 0) {
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = NO;
    } else if ([[history valueForKey:@"type"] intValue] == 1) {
        cell.typeLabel.text = @"⇒";
        cell.getButton.hidden = YES;
    } else {
        cell.typeLabel.text = @"←";
        cell.getButton.hidden = YES;
    }
    
    NSString *content = [history valueForKey:@"sec"];
    content = [content stringByAppendingString:@"sec ID:"];
    content = [content stringByAppendingString:[history valueForKey:@"code"]];
    content = [content stringByAppendingString:@"("];
    content = [content stringByAppendingString:[history valueForKey:@"time"]];
    content = [content stringByAppendingString:@")"];
    cell.contentLabel.text = content;
    
    return cell;
}

@end
