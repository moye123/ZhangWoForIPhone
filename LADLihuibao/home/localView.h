//
//  localView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface localView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,retain)UILabel *textLabel;
@property(nonatomic,retain)UIImageView *imageView;

@end
