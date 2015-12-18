//
//  NewsViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"

@implementation NewsViewController
@synthesize columnView;
@synthesize toolbar;
@synthesize columnButtons;
@synthesize navView = _navView;
@synthesize scrollView = _scrollView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"新闻资讯"];
    [self.view setBackgroundColor:[UIColor backColor]];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    UIBarButtonItem *moreButton = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    self.navigationItem.rightBarButtonItem = moreButton;
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, SWIDTH, 50)];
    [self.toolbar setHidden:YES];
    [self.toolbar setBackgroundColor:[UIColor whiteColor]];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.navigationController.view addSubview:self.toolbar];
    UIView *toolbarLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SWIDTH, 1)];
    toolbarLine.backgroundColor = [UIColor colorWithHexString:@"0xC9C9C9"];
    [self.toolbar addSubview:toolbarLine];
    
    _popMenu = [[DSXPopMenu alloc] init];
    _popMenu.frame = CGRectMake(SWIDTH-110, -150, 100, 150);
    _popMenu.hidden = YES;
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y + 50;
    frame.size.height = frame.size.height - 50;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    //导航栏
    _navView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, self.toolbar.frame.size.height)];
    _navView.showsVerticalScrollIndicator = NO;
    _navView.showsHorizontalScrollIndicator = NO;
    [self.toolbar addSubview:_navView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsColumns" ofType:@"plist"];
    self.columns = [NSArray arrayWithContentsOfFile:path];
    self.columnButtons = [NSMutableArray array];
    CGFloat buttonWith = 80.0;
    _navView.contentSize = CGSizeMake(buttonWith*[self.columns count], 0);
    for (int i = 0; i < [self.columns count]; i++) {
        NSDictionary *column = self.columns[i];
        //添加导航按钮
        UIButton *columnButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWith*i, 10, buttonWith, 30)];
        [columnButton.layer setCornerRadius:3.0];
        [columnButton.layer setMasksToBounds:YES];
        [columnButton.titleLabel setFont:[UIFont fontWithName:DSXFontStyleMedinum size:16.0]];
        [columnButton setTag:[[column objectForKey:@"catid"] integerValue]];
        [columnButton setTitle:[column objectForKey:@"cname"] forState:UIControlStateNormal];
        [columnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [columnButton setTitleColor:[UIColor colorWithRed:0.45 green:0.81 blue:0.76 alpha:1] forState:UIControlStateSelected];
        [columnButton addTarget:self action:@selector(columnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:columnButton];
        [self.columnButtons addObject:columnButton];
        
        //添加列表视图
        NewsListView *listView = [[NewsListView alloc] initWithFrame:CGRectMake(SWIDTH*i, 0, SWIDTH, _scrollView.frame.size.height)];
        listView.catid = [[column objectForKey:@"catid"] intValue];
        listView.showNewsDelegate = self;
        [listView showTableView];
        [_scrollView addSubview:listView];
    }
    
    [self.columnButtons[0] setSelected:YES];
    
    _scrollView.contentSize = CGSizeMake(SWIDTH*[self.columns count], 0);
    [self.view addSubview:_scrollView];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showPopMenu{
    [_popMenu toggle];
}
//栏目按钮点击事件
- (void)columnButtonClick:(UIButton *)button{
    NSInteger index = 0;
    for (int i=0; i<[self.columnButtons count]; i++) {
        if (self.columnButtons[i] == button) {
            index = i;
        }
        [self.columnButtons[i] setSelected:NO];
    }
    [button setSelected:YES];
    [_scrollView setContentOffset:CGPointMake(SWIDTH*index, _scrollView.contentOffset.y) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.toolbar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.toolbar.hidden = YES;
}


#pragma mark - show news delegate
- (void)showNewsDetailWithID:(NSInteger)newsID{
    NewsDetailViewController *detailController = [[NewsDetailViewController alloc] init];
    detailController.newsID = newsID;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger index = scrollView.contentOffset.x/SWIDTH;
        UIButton *button = self.columnButtons[index];
        for (int i=0; i<[self.columnButtons count]; i++) {
            [self.columnButtons[i] setSelected:NO];
        }
        [button setSelected:YES];
        CGFloat scaleWith = button.frame.origin.x - _navView.contentOffset.x;
        if ((scaleWith + 80)> SWIDTH) {
            [_navView setContentOffset:CGPointMake(_navView.contentOffset.x+80, _navView.contentOffset.y) animated:YES];
        }
        if (scaleWith<0) {
            [_navView setContentOffset:CGPointMake(_navView.contentOffset.x+scaleWith, _navView.contentOffset.y) animated:YES];
        }
    }
    
}

@end
