//
//  NewsDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsDetailViewController.h"

@implementation NewsDetailViewController
@synthesize newsID = _newsID;
@synthesize contentWebView = _contentWebView;
@synthesize commentWebView = _commentWebView;
@synthesize scrollView = _scrollView;
@synthesize afmanager = _afmanager;
@synthesize userStatus;
@synthesize commentView = _commentView;
@synthesize articleData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"本地资讯"];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    UIImage *moreImage = [[UIImage imageNamed:@"icon-more2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:moreImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    //初始化用户登录状态
    self.userStatus = [[LHBUserStatus alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    //初始化网络操作对象
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
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
    self.contentWebView.delegate = self;
    [_scrollView addSubview:_contentWebView];
    
    urlString = [SITEAPI stringByAppendingFormat:@"&mod=post&ac=showdetail&id=%ld",(long)_newsID];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_contentWebView loadRequest:request];
    
    //评论列表
    _commentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    _commentWebView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_commentWebView];
    
    urlString = [SITEAPI stringByAppendingFormat:@"&mod=comment&ac=showlist&idtype=aid&id=%ld",(long)_newsID];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
    //[self.commentView remove];
}

- (void)addLike{
    
}

- (void)showLogin{
    [[DSXUI sharedUI] showLoginFromViewController:self];
}

- (void)showCommentView{
    if (self.userStatus.isLogined) {
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

- (void)userStatusChanged{
    self.userStatus = [LHBUserStatus status];
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView == _contentWebView) {
        NSString *json = [_contentWebView stringByEvaluatingJavaScriptFromString:@"getArticle()"];
        id article = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([article isKindOfClass:[NSDictionary class]]) {
            self.articleData = article;
        }
        NSString *stringNum = [self.articleData objectForKey:@"commentnum"];
        [commButton setTitle:stringNum forState:UIControlStateNormal];
        commentNum = [stringNum intValue];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"网络连接失败"];
}

- (void)sendComment{
    NSString *message = self.commentView.textView.text;
    if (message.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(_newsID) forKey:@"id"];
        [params setObject:@"aid" forKey:@"idtype"];
        [params setObject:@(self.userStatus.uid) forKey:@"uid"];
        [params setObject:self.userStatus.username forKey:@"username"];
        [params setObject:message forKey:@"message"];
        [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=comment&ac=save"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            id dictionary = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                if ([dictionary objectForKey:@"cid"]) {
                    commentNum++;
                    NSString *title = [NSString stringWithFormat:@"%ld",(long)commentNum];
                    [commButton setTitle:title forState:UIControlStateNormal];
                    
                    _commentView.textView.text = @"";
                    [_commentWebView reload];
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDone Message:@"评论发表成功"];
                }else {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"内部系统错误"];
                }
            }
            [_commentView hide];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{
        [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"不能发表空评论"];
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
