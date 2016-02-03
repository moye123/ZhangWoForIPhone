//
//  LeftMenuView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@protocol LeftMenuViewDelegate <NSObject>
@optional
- (void)leftMenuDidSelectedItemWithData:(NSDictionary *)data;

@end

@interface LeftMenuCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,readonly)UIImageView *picView;
@property(nonatomic,readonly)UILabel *nameLabel;

@end

@interface LeftMenuView : UIView<UITableViewDelegate,UITableViewDataSource>{
    @private
    NSArray *_menuList;
    NSArray *_subMenuList;
}

@property(nonatomic,readonly)UITableView *tableView1;
@property(nonatomic,readonly)UITableView *tableView2;
@property(nonatomic,assign)id<LeftMenuViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
