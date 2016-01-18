//
//  NewsDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "MyMessageViewController.h"

@implementation NewsDetailViewController
@synthesize newsID = _newsID;
@synthesize contentWebView = _contentWebView;
@synthesize commentWebView = _commentWebView;
@synthesize scrollView  = _scrollView;
@synthesize commentView = _commentView;
@synthesize articleData = _articleData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"正文"];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    CGRect frame = self.view.frame;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(frame.size.width*2, 0);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    NSURLRequest *request;
    NSString *urlString;
    //正文
    _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _contentWebView.backgroundColor = [UIColor backColor];
    _contentWebView.delegate = self;
    _contentWebView.hidden = YES;
    [_scrollView addSubview:_contentWebView];
    
    urlString = [SITEAPI stringByAppendingFormat:@"&c=post&a=showdetail&id=%ld",(long)_newsID];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_contentWebView loadRequest:request];
    
    [[AFHTTPSessionManager sharedManager] GET:[urlString stringByAppendingString:@"&datatype=json"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _articleData = responseObject;
            _contentWebView.hidden = NO;
            NSString *stringNum = [self.articleData objectForKey:@"commentnum"];
            [commButton setTitle:stringNum forState:UIControlStateNormal];
            commentNum = [stringNum intValue];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //评论列表
    _commentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    _commentWebView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_commentWebView];
    
    urlString = [SITEAPI stringByAppendingFormat:@"&c=comment&a=showlist&idtype=aid&dataid=%ld",(long)_newsID];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_commentWebView loadRequest:request];
    
    //评论窗口
    UITextView *commTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, SWIDTH-90, 34)];
    commTextField.text = @"我来说两句..";
    commTextField.font = [UIFont systemFontOfSize:14.0];
    commTextField.editable = NO;
    commTextField.layer.cornerRadius = 3.0;
    commTextField.layer.masksToBounds = YES;
    commTextField.layer.borderWidth = 0.6;
    commTextField.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.00].CGColor;
    [self.navigationController.toolbar addSubview:commTextField];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCommentView)];
    [commTextField addGestureRecognizer:singleTap];
    
    //评论数
    commButton = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-70, 5, 60, 34)];
    commButton.tag = 300;
    commButton.layer.cornerRadius = 4.0;
    commButton.layer.masksToBounds = YES;
    commButton.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.00].CGColor;
    commButton.layer.borderWidth = 0.6;
    commButton.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    commButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [commButton setTitle:@"0" forState:UIControlStateNormal];
    [commButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    [commButton addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:commButton];
    
    _commentView = [[CommentView alloc] init];
    _commentView.delegate = self;
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showPopMenu{
    [_popMenu toggle];
}

- (void)dropDownMenu:(DSXDropDownMenu *)dropDownMenu didSelectedAtCellItem:(UITableViewCell *)cellItem withData:(NSDictionary *)data{
    [dropDownMenu slideUp];
    NSString *action = [data objectForKey:@"action"];
    if ([action isEqualToString:@"shownotice"]) {
        MyMessageViewController *messageView = [[MyMessageViewController alloc] init];
        [self.navigationController pushViewController:messageView animated:YES];
    }
    
    if ([action isEqualToString:@"showfavorite"]) {
        if ([[ZWUserStatus sharedStatus] isLogined]) {
            NSString *title = [NSString stringWithString:[_articleData objectForKey:@"title"]];
            NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                                     @"username":[ZWUserStatus sharedStatus].username,
                                     @"dataid":@(_newsID),
                                     @"idtype":@"aid",
                                     @"title":title};
            [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=favorite&a=save"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"收藏成功"];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
        }else {
            [self showLogin];
        }
    }
    
    if ([action isEqualToString:@"showhome"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
    [_popMenu slideUp];
    //[self.commentView remove];
}

- (void)showLogin{
    [[ZWUserStatus sharedStatus] showLoginFromViewController:self];
}

- (void)showCommentView{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        [_commentView show];
    }else {
        [self showLogin];
    }
}

- (void)switchButton:(UIButton *)sender{
    UIButton *button = sender;
    CGPoint offset = _scrollView.contentOffset;
    if (button.tag == 300) {
        button.tag = 301;
        offset.x = SWIDTH;
        [button setTitle:@"原文" forState:UIControlStateNormal];
    }else {
        button.tag = 300;
        offset.x = 0;
        NSString *title = [NSString stringWithFormat:@"%ld",(long)commentNum];
        [button setTitle:title forState:UIControlStateNormal];
    }
    [_scrollView setContentOffset:offset animated:YES];
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"网络连接失败"];
}

- (void)sendComment{
    NSString *message = self.commentView.textView.text;
    if (message.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(_newsID) forKey:@"dataid"];
        [params setObject:@"aid" forKey:@"idtype"];
        [params setObject:@([ZWUserStatus sharedStatus].uid) forKey:@"uid"];
        [params setObject:[ZWUserStatus sharedStatus].username forKey:@"username"];
        [params setObject:message forKey:@"message"];
        
        [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=comment&a=save"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject objectForKey:@"cid"]) {
                    commentNum++;
                    NSString *title = [NSString stringWithFormat:@"%ld",(long)commentNum];
                    [commButton setTitle:title forState:UIControlStateNormal];
                    
                    _commentView.textView.text = @"";
                    [_commentWebView reload];
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"评论发表成功"];
                }else {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"内部系统错误"];
                }
            }
            [_commentView hide];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{
        [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"不能发表空评论"];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        if (_scrollView.contentOffset.x == SWIDTH) {
            commButton.tag = 301;
            [commButton setTitle:@"原文" forState:UIControlStateNormal];
        }else {
            commButton.tag = 300;
            NSString *stringNum = [NSString stringWithFormat:@"%ld",(long)commentNum];
            [commButton setTitle:stringNum forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
