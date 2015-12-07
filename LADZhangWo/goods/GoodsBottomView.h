//
//  GoodsBottomView.h
//  LADZhangWo
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface GoodsBottomView : UIView{
    @private
    AFHTTPRequestOperationManager *_afmanager;
}
- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,readonly)UIButton *cartButton;
@property(nonatomic,readonly)UIButton *buyButton;
@end
