//
//  VHSLocatServicer.m
//  GongYunTong
//
//  Created by pingjun lin on 16/9/2.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSLocatServicer.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VHSLocatServicer ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation VHSLocatServicer

+ (VHSLocatServicer *)shareLocater {
    static VHSLocatServicer *locater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locater = [[VHSLocatServicer alloc] init];
    });
    return locater;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];
        
        _manager.distanceFilter = 200;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)startUpdatingLocation {
    [_manager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [_manager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    
    NSString *latitudeAndLongitude = [NSString stringWithFormat:@"%f;%f", latitude, longitude];
    [VHSCommon saveUserDefault:latitudeAndLongitude forKey:k_LATITUDE_LONGITUDE];
    
    CLog(@"经纬度---->%@", [NSString stringWithFormat:@"%f;%f", latitude, longitude]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    CLog(@"%@", error.description);
}

@end
