//
//  ChaoshiViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ChaoshiCatViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    CGFloat _itemWith;
}

- (instancetype)init;
@property(nonatomic,assign)NSInteger shopid;
@property(nonatomic,strong)NSMutableArray *categoryList;

@end
