//
//  ChaoshiIndexViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "chaoshiIndexCell.h"
#import "CategoryView.h"
#import "ChaoshiReusableView.h"
#import "ShowAdModel.h"

@interface ChaoshiIndexViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DSXSliderViewDelegate>{
    @private
    DSXSliderView *_slideView;
}

@property(nonatomic)NSArray *menuList;
@property(nonatomic)NSArray *categoryList;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UITableView *menuView;
@property(nonatomic)UICollectionView *collectionView;

@end
