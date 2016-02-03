//
//  ChooseToolbar.h
//  LADZhangWo
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@class ChooseToolbar;
@protocol ChooseToolbarDelegate <NSObject>
@optional
- (void)chooseBar:(ChooseToolbar *)choosebar filterByCatID:(NSInteger)catid;
- (void)chooseBar:(ChooseToolbar *)choosebar sortBySold:(BOOL)asc;
- (void)chooseBar:(ChooseToolbar *)choosebar sortByPrice:(BOOL)asc;

@end

@interface ChooseToolbarCatCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic,readwrite)NSString *text;

@end

@interface ChooseToolbar : UIToolbar<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    @private
    CGFloat _buttonWidth;
    UIView *_line1,*_line2;
    BOOL _asc;
    NSArray *_categoryList;
    CGFloat _originHeight;
    UIImageView *_arrow1,*_arrow2;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame fid:(NSInteger)fid;

@property(nonatomic,assign)NSInteger fid;
@property(nonatomic,readonly)UIButton *button1;
@property(nonatomic,readonly)UIButton *button2;
@property(nonatomic,readonly)UIButton *button3;
@property(nonatomic,readonly)UICollectionView *collectionView;
@property(nonatomic,assign)id<ChooseToolbarDelegate>filterDelegate;

@end
