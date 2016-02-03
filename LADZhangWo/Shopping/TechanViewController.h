//
//  TechanViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "SliderView.h"
#import "GalleryView.h"
#import "TechanGalleryView.h"
#import "TitleCell.h"
#import "BlankCell.h"
#import "ShowAdModel.h"

@interface TechanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UISearchBarDelegate,TechanGalleryViewDelegate,DSXSliderViewDelegate>{
    @private
    DSXSliderView *_sliderView;
    TechanGalleryView *_galleryView;
    UILabel *_localLabel;
    UISearchBar *_searchBar;
}

@property(nonatomic)UITableView *tableView;
@end
