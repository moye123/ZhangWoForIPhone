//
//  RefreshHeadView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshHeadView : UIView

@property(nonatomic,retain)UIActivityIndicatorView *indicatorView;
@property(nonatomic,retain)UILabel *textLabel;
@property(nonatomic,retain)UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
