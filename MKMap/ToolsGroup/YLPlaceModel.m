//
//  YLPlaceModel.m
//  MKMap
//
//  Created by 苏沫离 on 2020/10/21.
//

#import "YLPlaceModel.h"
#import <MapKit/MapKit.h>

NSString *const kYLPlaceModellCity = @"city";
NSString *const kYLPlaceModellCountry = @"country";
NSString *const kYLPlaceModellSubLocality = @"subLocality";
NSString *const kYLPlaceModellFormattedAddress = @"formattedAddress";
NSString *const kYLPlaceModellSpace = @"space";
NSString *const kYLPlaceModellName = @"name";
NSString *const kYLPlaceModellPlaceID = @"placeID";
NSString *const kYLPlaceModellCoordinate = @"coordinate";
NSString *const kYLPlaceModellLongitude = @"longitude";
NSString *const kYLPlaceModellLatitude = @"latitude";
NSString *const kYLPlaceModelltThoroughfare = @"thoroughfare";
NSString *const kYLPlaceModellPostalCode = @"postalCode";

@implementation YLPlaceModel

@synthesize city = _city;
@synthesize country = _country;
@synthesize subLocality = _subLocality;
@synthesize formattedAddress = _formattedAddress;
@synthesize space = _space;
@synthesize name = _name;
@synthesize placeID = _placeID;
@synthesize coordinate = _coordinate;
@synthesize thoroughfare = _thoroughfare;
@synthesize postalCode = _postalCode;


+ (instancetype)modelObjectWithCLPlacemark:(CLPlacemark *)placeMark{
    YLPlaceModel *model = [[YLPlaceModel alloc] init];
    model.coordinate = placeMark.location.coordinate;
    model.country = placeMark.country;
    model.city = placeMark.locality;
    model.subLocality = placeMark.subLocality;
    model.thoroughfare = placeMark.thoroughfare;
    model.name = placeMark.name;
    
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:placeMark.locality];
    [string appendString:placeMark.subLocality];
    [string appendString:placeMark.thoroughfare];
    [string appendString:placeMark.name];
    model.formattedAddress = string;
    return model;
}

+ (instancetype)modelObjectWithSearchDict:(NSDictionary *)dict{
    
    YLPlaceModel *model = [[YLPlaceModel alloc] init];
    model.placeID = dict[@"place_id"];
    model.name = dict[@"name"];
    
    NSDictionary *locationDict = dict[@"geometry"][@"location"];
    double lat = [[NSString stringWithFormat:@"%@",locationDict[@"lat"]] doubleValue];
    double lng = [[NSString stringWithFormat:@"%@",locationDict[@"lng"]] doubleValue];
    model.coordinate = CLLocationCoordinate2DMake(lat, lng);
    
    NSString *formatted_address = dict[@"formatted_address"];
    if([formatted_address containsString:@" 邮政编码:"]){
        model.formattedAddress = [formatted_address componentsSeparatedByString:@" 邮政编码:"].firstObject;
    }else{
        model.formattedAddress = formatted_address;
    }
    return model;
}

- (NSString *)description{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.country forKey:kYLPlaceModellCountry];
    [mutableDict setValue:self.city forKey:kYLPlaceModellCity];
    [mutableDict setValue:self.subLocality forKey:kYLPlaceModellSubLocality];
    [mutableDict setValue:self.thoroughfare forKey:kYLPlaceModelltThoroughfare];
    [mutableDict setValue:self.postalCode forKey:kYLPlaceModellPostalCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.space] forKey:kYLPlaceModellSpace];
    [mutableDict setValue:[NSNumber numberWithDouble:self.coordinate.latitude] forKey:kYLPlaceModellLatitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.coordinate.longitude] forKey:kYLPlaceModellLongitude];
    [mutableDict setValue:self.formattedAddress forKey:kYLPlaceModellFormattedAddress];
    [mutableDict setValue:self.name forKey:kYLPlaceModellName];
    [mutableDict setValue:self.placeID forKey:kYLPlaceModellPlaceID];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDict options:NSJSONWritingPrettyPrinted  error:&error];
    if (error) {
        return [NSString stringWithFormat:@"%@", mutableDict];
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.country = [aDecoder decodeObjectForKey:kYLPlaceModellCountry];
    self.city = [aDecoder decodeObjectForKey:kYLPlaceModellCity];
    self.subLocality = [aDecoder decodeObjectForKey:kYLPlaceModellSubLocality];
    self.thoroughfare = [aDecoder decodeObjectForKey:kYLPlaceModelltThoroughfare];
    self.postalCode = [aDecoder decodeObjectForKey:kYLPlaceModellPostalCode];
    self.formattedAddress = [aDecoder decodeObjectForKey:kYLPlaceModellFormattedAddress];
    self.space = [aDecoder decodeDoubleForKey:kYLPlaceModellSpace];
    self.coordinate = CLLocationCoordinate2DMake([aDecoder decodeDoubleForKey:kYLPlaceModellLatitude], [aDecoder decodeDoubleForKey:kYLPlaceModellLongitude]);
    self.name = [aDecoder decodeObjectForKey:kYLPlaceModellName];
    self.placeID = [aDecoder decodeObjectForKey:kYLPlaceModellPlaceID];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_city forKey:kYLPlaceModellCity];
    [aCoder encodeObject:_country forKey:kYLPlaceModellCountry];
    [aCoder encodeObject:_subLocality forKey:kYLPlaceModellSubLocality];
    [aCoder encodeObject:_thoroughfare forKey:kYLPlaceModelltThoroughfare];
    [aCoder encodeObject:_postalCode forKey:kYLPlaceModellPostalCode];
    [aCoder encodeObject:_formattedAddress forKey:kYLPlaceModellFormattedAddress];
    [aCoder encodeDouble:_space forKey:kYLPlaceModellSpace];
    [aCoder encodeObject:_name forKey:kYLPlaceModellName];
    [aCoder encodeObject:_placeID forKey:kYLPlaceModellPlaceID];
    [aCoder encodeDouble:_coordinate.latitude forKey:kYLPlaceModellLatitude];
    [aCoder encodeDouble:_coordinate.longitude forKey:kYLPlaceModellLongitude];
}

- (id)copyWithZone:(NSZone *)zone{
    YLPlaceModel *copy = [[YLPlaceModel alloc] init];
    if (copy) {
        copy.city = [self.city copyWithZone:zone];
        copy.country = [self.country copyWithZone:zone];
        copy.subLocality = [self.subLocality copyWithZone:zone];
        copy.postalCode = [self.postalCode copyWithZone:zone];
        copy.thoroughfare = [self.thoroughfare copyWithZone:zone];
        copy.formattedAddress = [self.formattedAddress copyWithZone:zone];
        copy.space = self.space;
        copy.coordinate = self.coordinate;
        copy.name = [self.name copyWithZone:zone];
        copy.placeID = [self.placeID copyWithZone:zone];
    }
    return copy;
}




/* 根据关键词获取指定位置
 */
- (void)fetchLocationWithKeyword:(NSString *)keyword city:(NSString *)city results:(void(^)(NSMutableArray<YLPlaceModel *> *places))handler{
        
    MKCoordinateRegion region ;//= MKCoordinateRegionMakeWithDistance(self.place.coordinate,1000, 1000);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.region = region;
    request.naturalLanguageQuery = @"Restaurants";
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
         if (!error) {
             
             NSMutableArray<YLPlaceModel *> *resultArray = [NSMutableArray array];
             [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 YLPlaceModel *model = [YLPlaceModel modelObjectWithCLPlacemark:obj.placemark];
                 //model.space = getSpaceFromeCoordinate(self.place.coordinate, model.coordinate);
                 [resultArray addObject:model];
                 NSLog(@"response ==== %@",model);
             }];
             [resultArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"space" ascending:YES]]];

             if (handler) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     handler(resultArray);
                 });
             }
         }else{
                //do something.
         }
     }];
}

@end
