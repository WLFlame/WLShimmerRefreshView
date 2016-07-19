//
//  ExcellentRefreshView.h
//  LLXiaChuFangRefresh
//
//  Created by ywl on 16/7/15.
//  Copyright © 2016年 lauren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcellentRefreshView : UIView

- (instancetype)initWithFrame:(CGRect)frame andScrollView:(UIScrollView *)scrollView andCompleteBlock:(void(^)())complete;

- (void)beginRefreshing;
- (void)endRefreshing;

@end
