//
//  LeftMenuView.m
//  LADZhangWo
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LeftMenuView.h"

@implementation LeftMenuCell
@synthesize picView = _picView;
@synthesize nameLabel = _nameLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView removeFromSuperview];
        _picView = [[UIImageView alloc] init];
        [self addSubview:_picView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        _nameLabel.highlightedTextColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.24 green:0.75 blue:0.68 alpha:1];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [_picView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"pic"]]];
    [_picView setHighlightedImage:_picView.image];
    [_nameLabel setText:[data objectForKey:@"cname"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _picView.frame = CGRectMake(5, (self.height-16)/2, 16, 16);
    _nameLabel.frame = CGRectMake(26, 0, self.width-30, self.height);
}

@end

@implementation LeftMenuView
@synthesize tableView1 = _tableView1;
@synthesize tableView2 = _tableView2;
@synthesize delegate   = _delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.backgroundColor = self.backgroundColor;
        _tableView1.showsVerticalScrollIndicator = NO;
        _tableView1.showsHorizontalScrollIndicator = NO;
        _tableView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_tableView1 registerClass:[LeftMenuCell class] forCellReuseIdentifier:@"cell1"];
        
        _tableView2 = [[UITableView alloc] initWithFrame:_tableView1.frame];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView2.backgroundColor = [UIColor colorWithRed:0.24 green:0.75 blue:0.68 alpha:1];
        _tableView2.width = 100;
        _tableView2.showsHorizontalScrollIndicator = NO;
        _tableView2.showsVerticalScrollIndicator = NO;
        _tableView2.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_tableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
        [self addSubview:_tableView2];
        [self addSubview:_tableView1];
        [self loadDataSourceByFid:0];
    }
    return self;
}

- (void)loadDataSourceByFid:(NSInteger)fid{
    NSString *urlString = [NSString stringWithFormat:@"&c=chaoshi&a=showcategorybyfid&fid=%ld",(long)fid];
    [[DSXHttpManager sharedManager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                if (fid == 0) {
                    _menuList = [responseObject objectForKey:@"data"];
                    [_tableView1 reloadData];
                }
                else {
                    _subMenuList = [responseObject objectForKey:@"data"];
                    [_tableView2 reloadData];
                    [self showSubmenu];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)showSubmenu{
    if (_tableView2.originX == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _tableView2.originX = _tableView1.width;
            self.width = _tableView1.width + _tableView2.width;
        }];
    }
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return [_menuList count];
    }else {
        return [_subMenuList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        NSDictionary *menuData1 = [_menuList objectAtIndex:indexPath.row];
        LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.data = menuData1;
        return cell;
    }else {
        NSDictionary *menuData2 = [_subMenuList objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.textLabel.text = [menuData2 objectForKey:@"cname"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.tintColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        NSDictionary *menuData1 = [_menuList objectAtIndex:indexPath.row];
        [self loadDataSourceByFid:[[menuData1 objectForKey:@"catid"] integerValue]];
    }
    if (tableView == _tableView2) {
        NSDictionary *menuData2 = [_subMenuList objectAtIndex:indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(leftMenuDidSelectedItemWithData:)]) {
            [_delegate leftMenuDidSelectedItemWithData:menuData2];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.originX = -self.width;
        }];
    }
}

@end
