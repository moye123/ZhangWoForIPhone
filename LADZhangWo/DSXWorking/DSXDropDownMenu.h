//
//  DSXDropDownMenu.h
//  LADZhangWo
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSXDropDownMenu;
@protocol DSXDropDownMenuDelegate<NSObject>
@optional
- (void)dropDownMenu:(DSXDropDownMenu *)dropDownMenu didSelectedAtCellItem:(UITableViewCell *)cellItem withData:(NSDictionary *)data;
@end

@interface DSXDropDownMenu : UIView<UITableViewDelegate,UITableViewDataSource>{
    @private
    CGRect _frame;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)slideDown;
- (void)slideUp;
- (void)toggle;

@property(nonatomic,readonly)UITableView *tableView;
@property(nonatomic,readonly)UIImageView *arrowView;
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,assign)id<DSXDropDownMenuDelegate>delegate;

@end
