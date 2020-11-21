# MKMap
iOS 原生地图，简单的路线规划



![路线规划.png](https://github.com/Kanthine/MKMap/blob/main/1.png)

使用 `MapKit` 库进行路线规划，主要涉及两个类：
* `MKDirectionsRequest`：提供的起点、终点，规划交通路线的请求！
* `MKDirections` : 根据提供的起点、终点等信息，向苹果服务器请求交通路线！

##### 1、请求信息 `MKDirectionsRequest`


```
@interface MKDirectionsRequest : NSObject
///起点
@property (nonatomic, strong, nullable) MKMapItem *source;
- (void)setSource:(nullable MKMapItem *)source NS_AVAILABLE(10_9, 7_0);
///终点
@property (nonatomic, strong, nullable) MKMapItem *destination;
- (void)setDestination:(nullable MKMapItem *)destination NS_AVAILABLE(10_9, 7_0);

/** 指定交通方式：驾车|步行|公交|任何方式
 * 默认 MKDirectionsTransportTypeAny
 */
@property (nonatomic) MKDirectionsTransportType transportType; 

///是否需要多条可用的路线 ，默认为 NO
@property (nonatomic) BOOL requestsAlternateRoutes; 

///设置出发（到达）时间，用于优化路线规划。例如，上下班时间的高峰期，服务器可能会考虑躲避拥堵！
@property (nonatomic, copy, nullable) NSDate *departureDate;
@property (nonatomic, copy, nullable) NSDate *arrivalDate;

@end
```


##### 2、发送请求`MKDirections`

```
@interface MKDirections : NSObject
/** 根据指定的请求实例化一个类
 * @param request 封装了起点、终点、交通方式等信息；该参数被复制，所以在实例化之后，不能再修改这些信息
*/
- (instancetype)initWithRequest:(MKDirectionsRequest *)request;

/** 异步规划交通路线
 * @note 如果 .calculating = YES ，则该方法会发生错误
 * @param completionHandler 操作完成的回调，返回路线信息或者错误
 */
- (void)calculateDirectionsWithCompletionHandler:(MKDirectionsHandler)completionHandler;

/** 异步计算从起点到终点的时间
 * @note 如果 .calculating = YES ，则该方法会发生错误
 * 由于预估时间比规划交通路线所花费的时间要少的多，所以在只需要估计时间的情况下使用这种方法；
 * @param completionHandler 操作完成的回调，返回预估时间或者错误
 */
- (void)calculateETAWithCompletionHandler:(MKETAHandler)completionHandler;

/* 取消一个请求
 * 取消一个请求之后，可以再次调用上述方法发送请求
 */
- (void)cancel;

///是否正在请求
@property (nonatomic, readonly, getter=isCalculating) BOOL calculating;

@end
```

##### 3、Demo：简单的路线规划

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
