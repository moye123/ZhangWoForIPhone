//
//  HomeSearchView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface HomeSearchView : UIView
- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,readonly)UIImageView *imageView;
@property(nonatomic,readonly)UITextField *textField;
@end
