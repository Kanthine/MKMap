//
//  YLPlaceModel.h
//  MKMap
//
//  Created by 苏沫离 on 2020/10/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPlaceModel : NSObject<NSCoding, NSCopying>

@property (nonatomic ,assign) double space;//距离
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//经纬度
@property (nonatomic ,copy) NSString *country;//国家：中国
@property (nonatomic ,copy) NSString *city;//城市：上海市
@property (nonatomic ,copy) NSString *subLocality;//城区：普陀区
@property (nonatomic ,copy) NSString *thoroughfare;//路名：中江路 879 号
@property (nonatomic ,copy) NSString *postalCode;//邮编：200335

@property (nonatomic ,copy) NSString *formattedAddress;
@property (nonatomic ,copy) NSString *name;//
@property (nonatomic ,copy) NSString *placeID;//谷歌的位置 id

/** 苹果地址转模型
 */
+ (instancetype)modelObjectWithCLPlacemark:(CLPlacemark *)placeMark;

+ (instancetype)modelObjectWithSearchDict:(NSDictionary *)dict;


@end


NS_ASSUME_NONNULL_END
