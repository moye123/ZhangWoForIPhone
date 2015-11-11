//
//  HomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
#import "HomeCategoryView.h"
#import "HomeFoodView.h"
#import "HomeNewsView.h"
#import "localView.h"
#import "searchBar.h"
#import "DistrictViewController.h"

@interface HomeViewController : UIViewController<showNewsDelegate,showCategoryDelegate,HomeFoodViewDelegate,LocationChangeDelegate>

@property(nonatomic,retain)localView *local;

@end
