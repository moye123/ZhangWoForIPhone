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

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"本地资讯"];
    [self.view setBackgroundColor:[UIColor backColor]];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack2 target:self action:@selector(back)];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, SWIDTH, 50)];
    [self.toolbar setHidden:YES];
    [self.toolbar setBackgroundColor:[UIColor whiteColor]];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.navigationController.view addSubview:self.toolbar];
    UIView *toolbarLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SWIDTH, 1)];
    toolbarLine.backgroundColor = [UIColor colorWithHexString:@"0xC9C9C9"];
    [self.toolbar addSubview:toolbarLine];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y + 50;
    frame.size.height = frame.size.height - 50;
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsColumns" ofType:@"plist"];
    self.columns = [NSArray arrayWithContentsOfFile:path];
    self.columnButtons = [NSMutableArray array];
    CGFloat buttonWith = (SWIDTH-20)/3;
    for (int i = 0; i < [self.columns count]; i++) {
        NSDictionary *column = self.columns[i];
        //添加导航按钮
        UIButton *columnButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWith*i+10, 10, buttonWith, 30)];
        [columnButton.layer setCornerRadius:3.0];
        [columnButton.layer setMasksToBounds:YES];
        [columnButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [columnButton setTag:[[column objectForKey:@"catid"] integerValue]];
        [columnButton setTitle:[column objectForKey:@"cname"] forState:UIControlStateNormal];
        [columnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [columnButton setTitleColor:[UIColor colorWithRed:0.45 green:0.81 blue:0.76 alpha:1] forState:UIControlStateSelected];
        [columnButton addTarget:self action:@selector(columnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbar addSubview:columnButton];
        [self.columnButtons addObject:columnButton];
        
        //添加列表视图
        NewsListView *listView = [[NewsListView alloc] initWithFrame:CGRectMake(SWIDTH*i, 0, SWIDTH, self.mainScrollView.frame.size.height)];
        listView.catid = [[column objectForKey:@"catid"] intValue];
        listView.showNewsDelegate = self;
        [self.mainScrollView addSubview:listView];
        [listView loadData];
    }
    
    [self.columnButtons[0] setSelected:YES];
    
    self.mainScrollView.contentSize = CGSizeMake(SWIDTH*[self.columns count], 0);
    [self.view addSubview:self.mainScrollView];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    [self.mainScrollView setContentOffset:CGPointMake(SWIDTH*index, self.mainScrollView.contentOffset.y) animated:YES];
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
    NSInteger index = ceil(scrollView.contentOffset.x/SWIDTH);
    for (int i=0; i<[self.columnButtons count]; i++) {
        UIButton *button = self.columnButtons[i];
        if (i == index) {
            [button setSelected:YES];
        }else {
            [button setSelected:NO];
        }
    }
}

@end
