//
//  MKMarkerView.h
//  MKMap
//
//  Created by 苏沫离 on 2019/5/27.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

///标记
@interface MKMarker : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;
@end



@interface MKMarkerView : MKAnnotationView

+ (instancetype)dequeueMarkerViewWithMap:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end

NS_ASSUME_NONNULL_END
