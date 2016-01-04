//
//  IncomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface IncomeViewController : UIViewController<DSXSliderViewDelegate>{
    @private
    DSXSliderView *_slideView;
}

@property(nonatomic,strong)NSString *income;
@property(nonatomic,retain)UIScrollView *scrollView;

@end
