# MKMap
iOS 原生地图，简单的路线规划

[路线规划.png](https://github.com/Kanthine/MKMap/blob/main/1.png) 


```
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
```
