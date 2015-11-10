//
//  HomeFoodView.h
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeFoodViewDelegate<NSObject>
@optional
- (void)showFoodDetailWithID:(NSInteger)foodID;
@end

@interface HomeFoodView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,assign)id<HomeFoodViewDelegate>delegate;
@end
