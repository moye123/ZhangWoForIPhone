//
//  UIScrollView+Refresh.m
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

static NSString *const DSXRefreshKeyHeader = @"dsx_headerView";
static NSString *const DSXRefreshKeyFooter = @"dsx_footerView";
@implementation UIScrollView (Refresh)

- (DSXRefreshHeader *)dsx_headerView{
    return objc_getAssociatedObject(self, &DSXRefreshKeyHeader);
}

- (void)setDsx_headerView:(DSXRefreshHeader *)dsx_headerView{
    if (self.dsx_headerView != dsx_headerView) {
        [self.dsx_headerView removeFromSuperview];
        [self insertSubview:dsx_headerView atIndex:0];
        
        [self willChangeValueForKey:DSXRefreshKeyHeader];
        objc_setAssociatedObject(self, &DSXRefreshKeyHeader, dsx_headerView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:DSXRefreshKeyHeader];
    }
}

- (DSXRefreshFooter *)dsx_footerView{
    return objc_getAssociatedObject(self, &DSXRefreshKeyFooter);
}

- (void)setDsx_footerView:(DSXRefreshFooter *)dsx_footerView{
    if (self.dsx_footerView != dsx_footerView) {
        [self.dsx_footerView removeFromSuperview];
        [self addSubview:dsx_footerView];
        
        dsx_footerView.size = CGSizeMake(self.width, 50);
        dsx_footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        
        [self willChangeValueForKey:DSXRefreshKeyFooter];
        objc_setAssociatedObject(self, &DSXRefreshKeyFooter, dsx_footerView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:DSXRefreshKeyFooter];
    }
}

@end
