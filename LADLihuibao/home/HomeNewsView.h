//
//  HomeNewsView.h
//  LADLihuibao
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol showNewsDelegate <NSObject>

@optional
- (void)showNewsDetailWhithID:(NSInteger)newsID;

@end

@interface HomeNewsView : UIView

@property(nonatomic,assign)id<showNewsDelegate> delegate;
@property(nonatomic,retain)UIView *contentView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
