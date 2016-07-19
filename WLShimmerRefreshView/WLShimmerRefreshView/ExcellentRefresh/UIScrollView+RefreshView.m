//
//  UIScrollView+RefreshView.m
//  LLXiaChuFangRefresh
//
//  Created by ywl on 16/7/15.
//  Copyright © 2016年 lauren. All rights reserved.
//

#import "UIScrollView+RefreshView.h"
#import "ExcellentRefreshView.h"
#import <objc/runtime.h>

static const char *kCurrentHeaderRefreshView = '\0';

@implementation UIScrollView (RefreshView)



- (void)addHeaderRefreshViewWithBlock:(IdentityBlock)block
{
    ExcellentRefreshView *refreshView = [[ExcellentRefreshView alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(self.frame) - self.refreshTextViewHeight, self.refreshTextViewWidth, self.refreshTextViewHeight) andScrollView:self andCompleteBlock:block];
    objc_setAssociatedObject(self, &kCurrentHeaderRefreshView, refreshView, OBJC_ASSOCIATION_RETAIN);
    [self addSubview:refreshView];
    
}

- (void)addFooterRefreshViewWithBlock:(IdentityBlock)block
{
   
    
}

- (void)beginRefresh
{
     ExcellentRefreshView *refreshView = objc_getAssociatedObject(self, &kCurrentHeaderRefreshView);
    [refreshView beginRefreshing];
}

- (void)endRefresh
{
    ExcellentRefreshView *refreshView = objc_getAssociatedObject(self, &kCurrentHeaderRefreshView);
    [refreshView endRefreshing];
}

#pragma mark --- Property
static const char RefreshTextViewWidthKey = '\0';
static const char RefreshTextViewHeightKey = '\0';


- (void)setRefreshTextViewWidth:(NSUInteger)refreshTextViewWidth
{
    if (refreshTextViewWidth != self.refreshTextViewWidth) {
        [self willChangeValueForKey:@"refreshTextViewWidth"];
        objc_setAssociatedObject(self, &RefreshTextViewWidthKey, @(refreshTextViewWidth), OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"refreshTextViewWidth"];
    }
}

- (void)setRefreshTextViewHeight:(NSUInteger)refreshTextViewHeight
{
    if (refreshTextViewHeight != self.refreshTextViewHeight) {
        [self willChangeValueForKey:@"refreshTextViewHeight"];
        objc_setAssociatedObject(self, &RefreshTextViewHeightKey, @(refreshTextViewHeight), OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"refreshTextViewHeight"];
    }
}

- (NSUInteger)refreshTextViewWidth
{
    NSUInteger associateValue = [objc_getAssociatedObject(self, &RefreshTextViewWidthKey) integerValue];
    if (associateValue != 0) {
        return associateValue;
    } else {
        return 40;
    }
    
}

- (NSUInteger)refreshTextViewHeight
{
    NSUInteger associateValue = [objc_getAssociatedObject(self, &RefreshTextViewHeightKey) integerValue];
    if (associateValue != 0) {
        return associateValue;
    } else {
        return 40;
    }
}


@end
