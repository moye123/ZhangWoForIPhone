//
//  TravelViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface TravelViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>{
    AFHTTPRequestOperationManager *_afmanager;
}

- (instancetype)init;

@property(nonatomic,strong)NSArray *categoryList;
@property(nonatomic,retain)DSXSliderView *slideView;

@end
