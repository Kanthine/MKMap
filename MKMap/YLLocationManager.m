//
//  YLLocationManager.m
//  MKMap
//
//  Created by long on 2021/1/25.
//

#import "YLLocationManager.h"
#import <CoreLocation/CoreLocation.h>

/// 获取两个经纬度之间的直线距离
double getSpaceFromeCoordinate(CLLocationCoordinate2D coordinate1 ,CLLocationCoordinate2D coordinate2){
    CLLocation *userLoca = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    double space = [userLoca distanceFromLocation:otherLocation];
    return space;
}


@interface YLLocationManager ()
<CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *locationManager;

@end

@implementation YLLocationManager


- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

+ (instancetype)shareManager{
    static YLLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLLocationManager alloc] init];
    });
    return manager;
}

- (void)requestUserAuthorization{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App需要你的同意,访问位置" preferredStyle:UIAlertControllerStyleAlert];
//    
//    __weak typeof(self) weakSelf = self;
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        weakSelf.isShowedAlert = NO;
//        //weakSelf.nearbyPlaces = nil;
//        //[self setPlace:nil];
//    }];
//    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        weakSelf.isShowedAlert = NO;
//        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
//        if( [[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:agreeAction];
//    [LocationManager.getCurrentViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate

/// 获取位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
}


- (void)locationManager:(CLLocationManager *)manager
    didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    } else if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    } else {
        NSLog(@"定位失败,请检查手机网络以及定位");
    }
}

/// 定位权限检查
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未决定授权");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 此时使用主动获取方法也不能申请定位权限
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    
}


#pragma mark - setter and getters

- (CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        CLLocationManager *locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        
        /// 控制定位精度,越高耗电量越
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10.0f;

        _locationManager = locationManager;
    }
    return _locationManager;
}

@end
