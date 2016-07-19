//
//  ViewController.m
//  WLShimmerRefreshView
//
//  Created by ywl on 16/7/19.
//  Copyright © 2016年 ywl. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+RefreshView.h"
static NSString *const CellID = @"CellID";
static CGFloat const tableViewCellHeight = 60.f;
static CGFloat const tableViewHeaderViewHeight = 150.f;
static CGFloat const headerHeight = 35.f;
static int const tableViewRowOfNumber = 15;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    __weak typeof(self) weak_self = self;
    [self.tableView addHeaderRefreshViewWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"test");
            [weak_self.tableView endRefresh];
        });
        
    }];
}

#pragma mark UItableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableViewRowOfNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"LeftTableView:%zd",indexPath.row];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableViewCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"LeftTableView 点击了 %zd-------%zd",indexPath.section,indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableViewHeaderViewHeight;
}

@end
