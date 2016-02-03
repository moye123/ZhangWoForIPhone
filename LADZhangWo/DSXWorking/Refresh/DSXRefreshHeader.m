//
//  DSXRefreshHeader.m
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshHeader.h"
NSString *const DSXRefreshStateNormalText = @"下拉刷新当前内容";
NSString *const DSXRefreshStateWillRefreshText = @"松开手立即刷新";
NSString *const DSXRefreshStateRefreshingText = @"正在努力刷新中..";

@implementation DSXRefreshHeader
@synthesize isRefreshing  = _isRefreshing;
@synthesize updateTimeLabel = _updateTimeLabel;
@synthesize refreshState  = _refreshState;

- (instancetype)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.height = DSXRefreshHeaderHeight;
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        [self addSubview:_arrow];
        
        _updateTimeLabel = [[UILabel alloc] init];
        _updateTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _updateTimeLabel.textColor = [UIColor grayColor];
        _updateTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_updateTimeLabel];
        [self setRefreshState:DSXRefreshStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(willStartRefreshing:)]) {
            [self.delegate willStartRefreshing:self];
        }
        _updateTimeKey = @"DSXRefreshUpdateTimeKey";
        [self updateRefreshTimeForKey:_updateTimeKey];
    }
    return self;
}

- (void)setRefreshState:(DSXRefreshState)refreshState{
    _refreshState = refreshState;
    switch (refreshState) {
        case DSXRefreshStateNormal:
            self.textLabel.text = DSXRefreshStateNormalText;
            _arrow.transform = CGAffineTransformMakeRotation(0);
            break;
        case DSXRefreshStateWillRefresh:
            self.textLabel.text = DSXRefreshStateWillRefreshText;
            _arrow.transform = CGAffineTransformMakeRotation(M_PI);
            break;
            
        case DSXRefreshStateRefreshing:
            self.textLabel.text = DSXRefreshStateRefreshingText;
            break;
        default:
            self.textLabel.text = DSXRefreshStateNormalText;
            break;
    }
}

- (void)beginRefreshing{
    _arrow.hidden = YES;
    _isRefreshing = YES;
    self.refreshState = DSXRefreshStateRefreshing;
    [self.indicatorView startAnimating];
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.top = DSXRefreshHeaderHeight;
    self.scrollView.contentInset = inset;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didStartRefreshing:)]) {
            [self.delegate didStartRefreshing:self];
        }
        [self endRefreshing];
    });
}

- (void)endRefreshing{
    _arrow.hidden = NO;
    _isRefreshing = NO;
    [self.indicatorView stopAnimating];
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentInset = self.scrollViewOriginInset;
    }];
    self.refreshState = DSXRefreshStateNormal;
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:_updateTimeKey];
    [self updateRefreshTimeForKey:_updateTimeKey];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndRefreshing:)]) {
        [self.delegate didEndRefreshing:self];
    }
}

- (void)updateRefreshTimeForKey:(NSString *)key{
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        _updateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    } else {
        _updateTimeLabel.text = @"最后更新：无记录";
    }
}

- (void)setDelegate:(id<DSXRefreshDelegate>)delegate{
    [super setDelegate:delegate];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.refreshState == DSXRefreshStateWillRefresh) {
        self.refreshState = DSXRefreshStateRefreshing;
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.originY = -self.height - self.scrollView.contentInset.top;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //self.originY = -self.height - self.scrollView.contentInset.top;
    self.textLabel.frame = CGRectMake(0, 5, self.scrollView.width, DSXRefreshHeaderHeight/2);
    self.updateTimeLabel.frame = CGRectMake(0, DSXRefreshHeaderHeight/2-5, self.scrollView.width, DSXRefreshHeaderHeight/2);
    self.indicatorView.position  = CGPointMake(self.width/2 - 100, (self.height - self.indicatorView.height)/2);
    _arrow.frame = CGRectMake(self.width/2 - 90, (self.height-40)/2, 17, 40);
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.refreshState == DSXRefreshStateRefreshing) {
        return;
    }
    if (self.scrollView.isDragging) {
        if (-self.scrollView.contentOffset.y - self.scrollView.contentInset.top - 20 > DSXRefreshHeaderHeight) {
            self.refreshState = DSXRefreshStateWillRefresh;
        }
    }else if(self.refreshState == DSXRefreshStateWillRefresh){
        [self beginRefreshing];
    }
}

@end
