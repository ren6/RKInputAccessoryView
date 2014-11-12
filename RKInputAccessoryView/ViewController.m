//
//  ViewController.m
//  RKInputAccessoryView
//
//  Created by Renat on 22.10.14.
//  Copyright (c) 2014 Softeam. All rights reserved.
//

#import "ViewController.h"
#import "RKInputAccessoryView.h"
#import "DataSource.h"
@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RKInputAccessoryView *textViewContainer;
@end

@implementation ViewController
{
    DataSource *_dataSource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = [DataSource new];
    self.tableView.dataSource = _dataSource;
    self.tableView.delegate = _dataSource;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.textViewContainer = [RKInputAccessoryView view];
    [self.textViewContainer.sendButton addTarget:self action:@selector(sendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)inputAccessoryView
{
    return self.textViewContainer;
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)sendButtonTapped:(id)sender
{
    NSLog(@"send tapped!");
}

@end
