//
//  DataSource.m
//  RKInputAccessoryView
//
//  Created by Renat on 12/11/14.
//  Copyright (c) 2014 Softeam. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
#pragma mark - UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        return UITableViewAutomaticDimension;
    else
        return 160.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.numberOfLines = indexPath.row + 5;
    
    return cell;
}
@end
