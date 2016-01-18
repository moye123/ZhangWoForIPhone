//
//  TechanViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TechanViewController.h"
#import "GoodsDetailViewController.h"

@implementation TechanViewController
@synthesize tableView = _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"名优特产"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_tableView registerClass:[BlankCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView registerClass:[BlankCell class] forCellReuseIdentifier:@"galleryCell"];
    [_tableView registerClass:[TitleCell class] forCellReuseIdentifier:@"titleCell"];
    [self.view addSubview:_tableView];
    
    _sliderView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    _sliderView.num = 2;
    _sliderView.groupid = 1;
    [_sliderView loaddata];
    
    _tableView.tableHeaderView = _sliderView;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake((SWIDTH-200)/2, 7, 200, 35)];
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.backgroundImage = [UIImage imageNamed:@"bg.png"];
    _searchBar.placeholder = @"搜索你喜欢的商家，商品";
    for (UIView *subview in _searchBar.subviews) {
        for (UIView *view in subview.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
                //NSLog(@"%@",view);
            }
        }
    }
    
    CGSize cellSize = CGSizeMake((SWIDTH-36)/3, (SWIDTH-36)/3+62);
    _galleryView = [[TechanGalleryView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, cellSize.height*4+40)];
    _galleryView.cellSize  = cellSize;
    _galleryView.imageSize = CGSizeMake(cellSize.width, cellSize.height-62);
    _galleryView.scrollEnabled = NO;
    _galleryView.touchDelegate = self;
    
    [[AFHTTPSessionManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=goods&a=showlist&pagesize=12"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _galleryView.dataList = responseObject;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - gallery view delegate
- (void)techanGalleryView:(TechanGalleryView *)galleryView didSelectedItemWithData:(NSDictionary *)data{
    GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc] init];
    detailView.goodsid = [[data objectForKey:@"id"] integerValue];
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else {
        if (indexPath.row == 0) {
            return 45;
        }else {
            return _galleryView.frame.size.height;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:_searchBar];
        return cell;
    }else {
        if (indexPath.row == 0) {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.image = [UIImage imageNamed:@"icon-hot.png"];
            cell.title = @"热门特产";
            cell.detail = @"查看更多";
            return cell;
        }else {
            BlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"galleryCell" forIndexPath:indexPath];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
            cell.separatorInset  = UIEdgeInsetsMake(10, SWIDTH, 0, -SWIDTH);
            [cell addSubview:_galleryView];
            return cell;
        }
        
    }
    
}

- (void)viewWillLayoutSubviews{
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins  = UIEdgeInsetsZero;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
