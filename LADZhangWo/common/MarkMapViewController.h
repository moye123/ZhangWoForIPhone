//
//  MarkMapViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/19.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZWCommon.h"
#import "MyAnnotation.h"

@interface MarkMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocation *_myLocation;
}

- (instancetype)init;

@property(nonatomic,retain)NSString *address;
@property(nonatomic,retain)MKMapView *mapView;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain)CLGeocoder *geocoder;

@end
