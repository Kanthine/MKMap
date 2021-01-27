//
//  YLMapTools.m
//  MKMap
//
//  Created by 苏沫离 on 2020/10/21.
//

#import "YLMapTools.h"

@implementation YLMapTools

@end



@implementation YLMapTools (Route)

+ (NSString *)arriveTimeByRoute:(MKRoute *)route{
    ///YYYY-MM-dd HH:mm:ss
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:route.expectedTravelTime];
    NSLog(@"expectedTravelTime === %@",[formatter stringFromDate:date]);
    return [formatter stringFromDate:date];
}


///获取路程最短的路线
+ (MKRoute *)getShortestDistanceRouteWithRoutes:(NSArray<MKRoute *> *)routes{
    MKRoute *resultRoute = routes.firstObject;
    for (MKRoute *route in routes) {
        if (route.distance < resultRoute.distance) {
            resultRoute = route;
        }
    }
    return resultRoute;
}

///获取时间最快的路线
+ (MKRoute *)getFastestTimeRouteWithRoutes:(NSArray<MKRoute *> *)routes{
    MKRoute *resultRoute = routes.firstObject;
    for (MKRoute *route in routes) {
        if (route.expectedTravelTime < resultRoute.expectedTravelTime) {
            resultRoute = route;
        }
    }
    return resultRoute;
}

/** MKDirectionsTransportType   路线检索类型
 * MKDirectionsTransportTypeAutomobile  驾车
 * MKDirectionsTransportTypeWalking     步行
 * MKDirectionsTransportTypeTransit     公交
 * MKDirectionsTransportTypeAny         任何
 */
+ (void)routePlanWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end handler:(MKDirectionsHandler)completionHandler{
    //1.创建方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.requestsAlternateRoutes = YES;//是否需要多条可用的路线
    request.transportType = MKDirectionsTransportTypeAutomobile;
    //2.设置起点
    MKPlacemark *startPlace = [[MKPlacemark alloc] initWithCoordinate:start];
    request.source = [[MKMapItem alloc] initWithPlacemark:startPlace];
    
    //3.设置终点
    MKPlacemark *endPlace = [[MKPlacemark alloc] initWithCoordinate:end];
    request.destination = [[MKMapItem alloc] initWithPlacemark:endPlace];
    
    //4.创建方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //5.计算所有路线
    [directions calculateDirectionsWithCompletionHandler:completionHandler];
}


@end


@implementation YLMapTools (Geocode)

+ (void)getPlacemarkByLocation:(CLLocation *)location place:(void(^)(CLPlacemark *placeMark))handler{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
            handler(placemarks.firstObject);
        }
    }];
}

@end
