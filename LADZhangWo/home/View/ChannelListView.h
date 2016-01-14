//
//  ChannelListView.h
//  LADZhangWo
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
@class ChannelListView;
@protocol ChannelViewDelegate <NSObject>

@optional
- (void)channelView:(ChannelListView *)channelView didSelectItemAtTag:(NSString *)tag;

@end

@interface ChannelListView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    @private
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,readonly)UICollectionView *collectionView;
@property(nonatomic)NSArray *channelList;
@property(nonatomic,assign)id<ChannelViewDelegate>delegate;

@end
