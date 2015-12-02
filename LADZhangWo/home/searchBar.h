//
//  searchBar.h
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface searchBar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UITextField *textField;

@end
