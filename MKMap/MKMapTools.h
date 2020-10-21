//
//  MKMapTools.h
//  MKMap
//
//  Created by 苏沫离 on 2020/10/21.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMapTools : NSObject

///获取某条路线的达到时间
+ (NSString *)arriveTimeByRoute:(MKRoute *)route;

///获取路程最短的路线
+ (MKRoute *)getShortestDistanceRouteWithRoutes:(NSArray<MKRoute *> *)routes;

///获取时间最快的路线
+ (MKRoute *)getFastestTimeRouteWithRoutes:(NSArray<MKRoute *> *)routes;

/** 路线规划
 * @param start 起点坐标
 * @param end   终点坐标
 */
+ (void)routePlanWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end handler:(MKDirectionsHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
