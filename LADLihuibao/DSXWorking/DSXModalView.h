//
//  DSXModalView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSXModalView : UIView{
    @private
    UIView *_modalView;
}

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)hide;

@property(nonatomic,retain)UIView *contentView;

@end
