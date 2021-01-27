//
//  YLRouteViewController.m
//  MKMap
//
//  Created by long on 2021/1/27.
//

#import "YLRouteViewController.h"
#import "MKMarkerView.h"
#import "YLMapTools.h"
#import "AlbumMainViewController.h"
#import "PhotosManager.h"

@interface YLRouteViewController ()
<MKMapViewDelegate>

@property (nonatomic ,strong) MKMapView *mapView;
@property (nonatomic ,strong) MKMarker *userMarker;//用户
@property (nonatomic ,strong) MKMarker *horsemanMarker;//骑手
@end

@implementation YLRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.mapView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClock)];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mapView addAnnotation:self.userMarker];
    [self.mapView addAnnotation:self.horsemanMarker];
    
    NSArray *polylines = [self.mapView.overlays copy];
    [polylines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.mapView removeOverlay:obj];
    }];
    
    [YLMapTools routePlanWithStart:self.horsemanMarker.coordinate end:self.userMarker.coordinate handler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"路线条数 ===== %lu", (unsigned long)response.routes.count);
        MKRoute *route = [YLMapTools getFastestTimeRouteWithRoutes:response.routes];
        self.horsemanMarker.title = [NSString stringWithFormat: @"预计 %@ 分送达",[YLMapTools arriveTimeByRoute:route]];
        //添加线路到MapView中
        [self.mapView addOverlay:route.polyline];
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

#pragma mark - response click

- (void)rightBarButtonItemClock{
//    AlbumMainViewController *albumVC = [[AlbumMainViewController alloc] init];
//    albumVC.albumType = AlbumResourcesTypeLibrary;
//    [self presentViewController:albumVC animated:YES completion:nil];
    
    [PhotosManager loadAllPhotosCompletionBlock:^(NSMutableArray<PHAsset *> *listArray) {
       
        [listArray enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"location: %@ ------ date: %@",obj.location,obj.creationDate);
        }];
        
    }];
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:MKMarker.class]) {
        MKMarker *marker = (MKMarker *)annotation;
        MKAnnotationView *markerView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"markerView"];
        markerView.canShowCallout = YES;
        markerView.annotation = marker;
        markerView.image = marker.image;
        return markerView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    for (MKAnnotationView *annotationView in views) {
        NSLog(@"annotationView ==== %@",annotationView);
        if (annotationView.annotation == self.horsemanMarker) {
            [mapView selectAnnotation:annotationView.annotation animated:YES];
        }else{
            [mapView deselectAnnotation:annotationView.annotation animated:YES];
        }
    }
}

/** MKMapView方法：必须重写，将线画到地图上
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    //将线画到地图上
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    //设置线的颜色
    renderer.strokeColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
    return renderer;
}


#pragma mark - setter and getters

//模拟地图
- (MKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds))];
        _mapView.mapType = MKMapTypeStandard;//标准地图
        _mapView.zoomEnabled = YES;   // 是否缩放
        _mapView.scrollEnabled = YES; // 是否滚动
        _mapView.rotateEnabled = YES; // 是否旋转
        _mapView.pitchEnabled = YES; // 是否显示3DVIEW
        _mapView.showsCompass = YES;// 是否显示指南针
        _mapView.showsBuildings = YES; // 是否显示建筑物
        _mapView.showsPointsOfInterest = YES; // 显示兴趣点
        _mapView.showsScale = YES;// 是否显示比例尺
        //_mapView.showsTraffic = YES;// 是否显示交通 : 控制太打印 Compiler error: Invalid library file
        _mapView.showsUserLocation = NO;//不显示当前位置
        [_mapView registerClass:MKAnnotationView.class forAnnotationViewWithReuseIdentifier:@"markerView"];
        
        [_mapView setRegion:MKCoordinateRegionMake(self.userMarker.coordinate, MKCoordinateSpanMake(0.15, 0.15)) animated:YES];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (MKMarker *)userMarker{
    if (_userMarker == nil) {
        _userMarker = [[MKMarker alloc] init];
        _userMarker.title = @"苏先生";
        _userMarker.image = [UIImage imageNamed:@"image_1"];
        _userMarker.coordinate = CLLocationCoordinate2DMake(31.23498368770419, 121.38999714294432);
    }
    return _userMarker;
}

- (MKMarker *)horsemanMarker{
    if (_horsemanMarker == nil) {
        _horsemanMarker = [[MKMarker alloc] init];
        _horsemanMarker.title = @"预计 23:23 分送达";
        _horsemanMarker.image = [UIImage imageNamed:@"address_horseman"];
        _horsemanMarker.coordinate = CLLocationCoordinate2DMake(31.19302735486151, 121.31518353436277);
    }
    return _horsemanMarker;
}

@end
