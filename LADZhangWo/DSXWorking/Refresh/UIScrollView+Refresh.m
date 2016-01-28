//
//  UIScrollView+Refresh.m
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

static NSString *const DSXRefreshKey = @"dsxrefreshView";
@implementation UIScrollView (Refresh)

- (DSXRefreshHeader *)refreshView{
    return objc_getAssociatedObject(self, &DSXRefreshKey);
}

- (void)setRefreshView:(DSXRefreshHeader *)refreshView{
    if (self.refreshView != refreshView) {
        [self.refreshView removeFromSuperview];
        [self insertSubview:refreshView atIndex:0];
        refreshView.size = CGSizeMake(self.width, 50);
        refreshView.originY = -refreshView.height - self.contentInset.top;
        [self willChangeValueForKey:@"refrshView"];
        objc_setAssociatedObject(self, &DSXRefreshKey, refreshView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"refreshView"];
    }
}

@end
