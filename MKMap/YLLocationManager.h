//
//  YLLocationManager.h
//  MKMap
//
//  Created by long on 2021/1/25.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取两个经纬度之间的直线距离
FOUNDATION_EXPORT double getSpaceFromeCoordinate(CLLocationCoordinate2D coordinate1 ,CLLocationCoordinate2D coordinate2);


@interface YLLocationManager : NSObject

/** 更新定位
 */
- (void)updatingLocation;


@end

NS_ASSUME_NONNULL_END
