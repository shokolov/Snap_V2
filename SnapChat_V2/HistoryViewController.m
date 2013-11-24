//
//  HistoryViewController.m
//  SnapChat_V2
//
//  Created by A12325 on 2013/11/17.
//  Copyright (c) 2013年 KimByungyoon. All rights reserved.
//

#import "HistoryViewController.h"
#import "History.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

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
    
    NSMutableArray *_historyList = [NSMutableArray arrayWithCapacity:20];
    
    History *history = [[History alloc] init];
    history.code = @"000001";
    history.name = @"あなたがBに配信";
    [_historyList addObject:history];
    
    history = [[History alloc] init];
    history.code = @"000002";
    history.name = @"Bから３秒受信";
    [_historyList addObject:history];
    
    self.historyList = _historyList;
    
    NSLog(@"HistoryViewController.viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    History *history = (self.historyList)[indexPath.row];
    cell.textLabel.text = history.name;
    cell.detailTextLabel.text = history.code;
    
    return cell;
}

@end
