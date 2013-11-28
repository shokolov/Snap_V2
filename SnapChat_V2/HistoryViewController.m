//
//  HistoryViewController.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "HistoryViewController.h"
#import "History.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *history = (self.historyList)[indexPath.row];
    NSString *type = @"";
    if ([[history valueForKey:@"type"] intValue] < 1) {
        type = @"RECE: ";
    } else {
        type = @"SEND: ";
    }
    cell.textLabel.text = [type stringByAppendingString:[history valueForKey:@"code"]];
    cell.detailTextLabel.text = [history valueForKey:@"time"];
    
    return cell;
}

@end
