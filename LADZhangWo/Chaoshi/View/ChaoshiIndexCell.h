//
//  ChaoshiIndexCell.h
//  LADZhangWo
//
//  Created by Apple on 16/1/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaoshiIndexCell : UITableViewCell

@property(nonatomic)UITableView *menuView;
@property(nonatomic)UICollectionView *collectionView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
