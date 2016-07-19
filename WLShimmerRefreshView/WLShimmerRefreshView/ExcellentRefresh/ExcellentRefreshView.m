//
//  ExcellentRefreshView.m
//  LLXiaChuFangRefresh
//
//  Created by ywl on 16/7/15.
//  Copyright © 2016年 lauren. All rights reserved.
//

#import "ExcellentRefreshView.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "FBShimmeringView.h"

static CGFloat const headerHeight = 35.f;
@interface ExcellentRefreshView()

@property (nonatomic, assign) CGFloat originRefreshY;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic,strong) CALayer *animationLayer;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) FBShimmeringView *shimmeringView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *logoLabel;

@property (nonatomic, copy) void (^refreshBlock)();

@end

@implementation ExcellentRefreshView

- (instancetype)initWithFrame:(CGRect)frame andScrollView:(UIScrollView *)scrollView andCompleteBlock:(void (^)())complete
{
    if (self = [super initWithFrame:frame]) {
        self.refreshBlock = complete;
        self.scrollView = scrollView;
        self.isRefresh = NO;
        [self addObserver];
        
        _originRefreshY = frame.origin.y;
        self.animationLayer = [CALayer layer];
        self.animationLayer.frame = CGRectMake(0.0f, 0.0f,CGRectGetWidth(frame),CGRectGetHeight(frame));
        [self.layer addSublayer:self.animationLayer];
        self.animationLayer.hidden = NO;
        //开始加载动画
        [self setupShimmeringView];
        [self setupTextLayer];
        [self startAnimation];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:object];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"scrollView:%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    // 判断是否在拖动_scrollView
//    CGRect rect = self.frame;
//    rect.origin.y = _originRefreshY - scrollView.contentOffset.y;
//    self.frame = rect;
//    NSLog(@"%f %f", rect.origin.y, scrollView.contentOffset.y);
    //    LxDBAnyVar(scrollView.contentOffset.y);
    
    CGFloat moveY = scrollView.contentOffset.y;
    if (moveY < -20) {
        NSLog(@"%f", moveY);
        if (scrollView.dragging) {
            
            // offset 从20开始
            if (moveY > -70) {
                [self progressDragChangeValue:fabs(moveY + 20)/5.0f];
            }else if(moveY <= -70){
                [self progressDragChangeValue:10.0f];
            }
        }else{
            
            if (moveY > -60) {
                [self progressDragChangeValue:fabs(moveY + 20)/5.0f];
            }else{
                [self beginRefreshing];
            }
        }
    }
    
    
}

- (void)setupShimmeringView
{
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    _valueLabel.textColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.numberOfLines = 0;
    _valueLabel.alpha = 0.0;
    _valueLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_valueLabel];
    
    _valueLabel.hidden = YES;
    
    _shimmeringView = [[FBShimmeringView alloc] init];
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringBeginFadeDuration = 0.3;
    _shimmeringView.shimmeringOpacity = 0.17;
    _shimmeringView.shimmeringSpeed = 230;
    [self addSubview:_shimmeringView];
    
    _shimmeringView.hidden = YES;
    
    _logoLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    _logoLabel.text = @"Design for the life";
    _logoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
//    _logoLabel.textColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1];
    _logoLabel.textColor = [UIColor blackColor];
    _logoLabel.textAlignment = NSTextAlignmentCenter;
    _logoLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = _logoLabel;
    
    _logoLabel.hidden = YES;
}

- (void)progressDragChangeValue:(CGFloat)vlaue{
    
    NSLog(@"value %f", vlaue);
    self.pathLayer.timeOffset = vlaue;
}


- (void) stopAnimation
{
    self.animationLayer.hidden = YES;
}

- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

#pragma mark 下拉刷新开始和暂停
/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing
{
    if (!_isRefresh) {
        _isRefresh=YES;
//        [self activeBGViewIsHidden:NO];
        
        // 设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            //修改有时候refresh contentOffset 还在0，0的情况 20150723
            CGPoint point = self.scrollView.contentOffset;
            if (point.y >- headerHeight*1.5) {
                 self.scrollView.contentOffset = CGPointMake(0, point.y-headerHeight*1.5);
            }
             self.scrollView.contentInset =  UIEdgeInsetsMake(headerHeight*1.5, 0, 0, 0);
        }];
        
        // 模拟网络数据请求
//        [self simulateHTTPRequest];
        
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        
        [self stopAnimation];
        
        self.logoLabel.hidden = NO;
        self.valueLabel.hidden = NO;
        self.shimmeringView.hidden = NO;
    }
    
    
}

- (void)simulateHTTPRequest{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self endRefreshing];
    });
}

- (void)endRefreshing
{
    //    LxDBAnyVar(isRefresh);
    _isRefresh=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint point= self.scrollView.contentOffset;
            if (point.y!=0) {
                self.scrollView.contentOffset=CGPointMake(0, point.y+headerHeight*1.5);
            }
            self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            
            
//            [_activityView stopAnimating];
//            [self activeBGViewIsHidden:YES];
            
            
        } completion:^(BOOL finished) {
            _animationLayer.hidden = NO;
            self.logoLabel.hidden = YES;
            self.valueLabel.hidden = YES;
            self.shimmeringView.hidden = YES;
        }];
        
        
    });
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) {
        
        CGRect frame = CGRectMake(0, self.frame.origin.y, newSuperview.frame.size.width, self.frame.size.height);
        self.frame = frame;
         self.animationLayer.frame = CGRectMake(0.0f, 0.0f,CGRectGetWidth(frame),CGRectGetHeight(frame));
        self.pathLayer.frame = CGRectMake((newSuperview.frame.size.width - self.pathLayer.bounds.size.width) * 0.5, (self.frame.size.height - self.pathLayer.bounds.size.height) * 0.5, self.pathLayer.bounds.size.width, self.pathLayer.bounds.size.height);
        
        _valueLabel.frame = CGRectMake(0, 0, newSuperview.bounds.size.width,self.frame.size.height);
        _logoLabel.frame = _valueLabel.frame;
        _shimmeringView.frame = _valueLabel.frame;
        [self addObserver];
    }
}

- (void)addObserver
{
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark ---- 文字效果核心代码
- (void) setupTextLayer
{
    //原 Demo 地址:https://github.com/ole/Animated-Paths
    if (self.pathLayer != nil) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
    
    // Create path from text
    // See: http://www.codeproject.com/KB/iPhone/Glyph.aspx
    // License: The Code Project Open License (CPOL) 1.02 http://www.codeproject.com/info/cpol10.aspx
    CGMutablePathRef letters = CGPathCreateMutable();
    
    //    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 28.0f, NULL);//Helvetica-Bold
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 24.0f, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Excellent Design"
                                                                     attributes:attrs];
    //C'est La Vie
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;//设置位置
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);//设置位置
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
//    pathLayer.strokeColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1].CGColor;
    pathLayer.strokeColor = [UIColor blackColor].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel; //TODO 好像没啥用?
    
    pathLayer.speed = 0;
    pathLayer.timeOffset = 0;
    
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
}


@end
