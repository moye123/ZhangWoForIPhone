//
//  ChaoshiIndexViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ChaoshiIndexViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    CGFloat _cellWith;
    CGFloat _cellHeight;
    DSXSliderView *_slideView;
}

- (instancetype)init;
@property(nonatomic,strong)NSMutableArray *chaoshiList;

@end
