//
//  ChaoshiIndexCell.m
//  LADZhangWo
//
//  Created by Apple on 16/1/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChaoshiIndexCell.h"

@implementation ChaoshiIndexCell
@synthesize menuView = _menuView;
@synthesize collectionView = _collectionView;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
    }
    return self;
}

- (void)setMenuView:(UITableView *)menuView{
    if (_menuView) {
        [_menuView removeFromSuperview];
    }
    _menuView = menuView;
    _menuView.frame = CGRectMake(0, 0, 80, self.frame.size.height);
    [self addSubview:_menuView];
}

- (void)setCollectionView:(UICollectionView *)collectionView{
    if (_collectionView) {
        [_collectionView removeFromSuperview];
    }
    _collectionView = collectionView;
    _collectionView.frame = CGRectMake(80, 0, self.frame.size.width-80, self.frame.size.height);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:_collectionView];
}


@end
