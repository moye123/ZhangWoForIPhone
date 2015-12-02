//
//  DistrictViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
@protocol LocationChangeDelegate<NSObject>
- (void)locationChangeWithName:(NSString *)name;
@end

@interface DistrictViewController : UITableViewController

@property(nonatomic,assign)int fid;
@property(nonatomic,strong)NSArray *districtList;
@property(nonatomic,assign)id<LocationChangeDelegate>delegate;

@end
