//
//  DSXStarView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSXStarView : UIView{
    @private
    UIImageView *_starView;
}

- (instancetype)init;
- (instancetype)initWithStarNum:(NSInteger)starNum position:(CGPoint)position;

@property(nonatomic,assign)NSInteger starNum;
@property(nonatomic,assign)CGPoint position;

@end
