//
//  NewsDetailViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "CommentView.h"

@interface NewsDetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,CommentViewDelegate,DSXDropDownMenuDelegate>{
    UIButton *commButton;
    NSInteger commentNum;
    DSXDropDownMenu *_popMenu;
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,assign)NSInteger newsID;
@property(nonatomic,retain)UIWebView *contentWebView;
@property(nonatomic,retain)UIWebView *commentWebView;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)CommentView *commentView;
@property(nonatomic,strong)NSDictionary *articleData;

@end
