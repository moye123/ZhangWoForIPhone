//
//  AddToCartView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface AddToCartView : UIView{
@private
    UIView *_modalView;
    int _buyNum;
    UITextField *_buyNumField;
    LHBUserStatus *_userStatus;
}

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)hide;

@property(nonatomic,retain)UIView *contentView;
@property(nonatomic,strong)NSDictionary *goodsData;

@end
