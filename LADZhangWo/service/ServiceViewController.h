//
//  ServiceViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ServiceViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    CGFloat _cellWidth;
    CGFloat _cellHeight;
    DSXSliderView *_slideView;
}

- (instancetype)init;
@property(nonatomic,strong)NSMutableArray *serviceList;

@end
