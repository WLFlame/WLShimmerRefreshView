//
//  UIScrollView+RefreshView.h
//  LLXiaChuFangRefresh
//
//  Created by ywl on 16/7/15.
//  Copyright © 2016年 lauren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IdentityBlock)();
@interface UIScrollView (RefreshView)
- (void)addHeaderRefreshViewWithBlock:(IdentityBlock)block;
- (void)addFooterRefreshViewWithBlock:(IdentityBlock)block;


- (void)beginRefresh;
- (void)endRefresh;

// Default is 40
@property (nonatomic, assign) NSUInteger refreshTextViewHeight;
// Default is equal screen width
@property (nonatomic, assign) NSUInteger refreshTextViewWidth;



@end
