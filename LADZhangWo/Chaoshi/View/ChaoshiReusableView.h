//
//  ChaoshiReusableView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaoshiReusableView : UICollectionReusableView{
    @private
    UIView *_line;
}

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic)NSString *text;

@end
