//
//  MarkMapViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/19.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MarkMapViewController.h"

@implementation MarkMapViewController
@synthesize city = _city;
@synthesize address = _address;
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;

- (instancetype)init{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _myLocation = [_locationManager location];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"地图"];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    if (!_address) {
        _address = @"金水港湾 力爱迪科技";
    }
    
    if (!_city) {
        _city = [[NSUserDefaults standardUserDefaults] objectForKey:@"locality"];
        if (_city) {
            _city = @"六盘水";
        }
    }
    
    //初始化地图
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.view addSubview:_mapView];
    
    [self markPlace];
}

- (void)markPlace{
    _geocoder = [[CLGeocoder alloc] init];
    CLRegion *region = [[CLRegion alloc] init];
    [_geocoder geocodeAddressString:[NSString stringWithFormat:@"%@ %@",_city,_address] inRegion:region completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            CLLocation *location = placeMark.location;
            
            MyAnnotation *annotation = [[MyAnnotation alloc] init];
            annotation.title = _address;
            annotation.coordinate = [location coordinate];
            [_mapView addAnnotation:annotation];
            [_mapView selectAnnotation:annotation animated:YES];
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
            MKCoordinateRegion regin = MKCoordinateRegionMake([location coordinate], span);
            [_mapView setRegion:regin animated:YES];
        }else {
        }
        
    }];
    
    /*
    [_geocoder reverseGeocodeLocation:_myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            NSDictionary *placeDict = [[placemarks firstObject] addressDictionary];
            NSDictionary *addressDict = @{@"City":[placeDict objectForKey:@"City"],@"Country":[placeDict objectForKey:@"Country"],@"Thoroughfare":_address};
            [_geocoder geocodeAddressDictionary:addressDict completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *placeMark = [placemarks firstObject];
                CLLocation *location = placeMark.location;
                
                MyAnnotation *annotation = [[MyAnnotation alloc] init];
                annotation.title = _address;
                annotation.subtitle = [NSString stringWithFormat:@"%@ %@",[placeDict objectForKey:@"State"],[placeDict objectForKey:@"City"]];
                annotation.coordinate = [location coordinate];
                [_mapView addAnnotation:annotation];
                
                MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
                MKCoordinateRegion regin = MKCoordinateRegionMake([location coordinate], span);
                [_mapView setRegion:regin animated:YES];
                
            }];
        }else {
            [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:[NSString stringWithFormat:@"%@定位失败",_address]];
            MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
            MKCoordinateRegion regin = MKCoordinateRegionMake([_myLocation coordinate], span);
            [_mapView setRegion:regin animated:YES];
        }
    }];
    */
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark - mapView delegate

@end
