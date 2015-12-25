//
//  ContactusViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ContactusViewController.h"
#import "MyAnnotation.h"

@implementation ContactusViewController
@synthesize mapView = _mapView;
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"联系我们"];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBackWhite target:self action:@selector(back)];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLRegion *region = [[CLRegion alloc] init];
    [geocoder geocodeAddressString:@"贵州省 六盘水市 钟山区 金水港湾" inRegion:region completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            CLLocation *location = placeMark.location;
            
            MyAnnotation *annotation = [[MyAnnotation alloc] init];
            annotation.title = @"力爱迪科技有限公司";
            annotation.coordinate = [location coordinate];
            annotation.subtitle = @"电话:0858-8772117 六盘水钟山区金水港湾C座1102室";
            [_mapView addAnnotation:annotation];
            [_mapView selectAnnotation:annotation animated:YES];
            MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
            MKCoordinateRegion regin = MKCoordinateRegionMake([location coordinate], span);
            [_mapView setRegion:regin animated:YES];
        }else {
            
        }
        
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
