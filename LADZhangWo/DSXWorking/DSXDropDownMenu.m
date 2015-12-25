//
//  DSXDropDownMenu.m
//  LADZhangWo
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXDropDownMenu.h"

@implementation DSXDropDownMenu
@synthesize tableView = _tableView;
@synthesize arrowView = _arrowView;
@synthesize dataList = _dataList;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)]) {
        _frame = frame;
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35, 0, 23, 18)];
        [_arrowView setImage:[UIImage imageNamed:@"pop-arrow.png"]];
        [self addSubview:_arrowView];
        
        _dataList = @[@{@"pic":@"pop-notice.png",@"title":@"消息",@"action":@"shownotice"},
                      @{@"pic":@"pop-favor.png",@"title":@"收藏",@"action":@"showfavorite"},
                      @{@"pic":@"pop-home.png",@"title":@"首页",@"action":@"showhome"}
                      ];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 18, frame.size.width, frame.size.height-18)];
        _tableView.layer.cornerRadius = 10.0;
        _tableView.layer.masksToBounds = YES;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pop-bg.png"]];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [self setHidden:YES];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_tableView reloadData];
}

- (void)slideDown{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = _frame;
    }];
}

- (void)slideUp{
    self.hidden = YES;
    self.frame  = CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, 0);
}

- (void)toggle{
    if (self.hidden == YES) {
        [self slideDown];
    }else {
        [self slideUp];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSDictionary *menu = [_dataList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[menu objectForKey:@"pic"]];
    cell.textLabel.text = [menu objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(dropDownMenu:didSelectedAtCellItem:withData:)]) {
        [_delegate dropDownMenu:self didSelectedAtCellItem:cell withData:data];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        [self slideUp];
    }
}

@end
