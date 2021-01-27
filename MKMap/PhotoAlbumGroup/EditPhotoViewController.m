//
//  EditPhotoViewController.m
//  YLAlbumTool
//
//  Created by 龙 on 2017/8/15.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "UIBarButtonItem+PhotoBarLeftItem.h"

@interface EditPhotoViewController ()
{
    CGRect _cutoutRect;
}
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIView *maskView;
@property (nonatomic ,strong) UIBezierPath *cutoutBezierPath;//镂空部分的贝塞尔曲线

@end

@implementation EditPhotoViewController

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self){
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftPhotoBackItemWithTarget:self action:@selector(leftNavBarButtonClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightPhotoItemWithTitle:@"保存" target:self action:@selector(rightNavBarButtonClick)];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.maskView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.maskView.frame = self.view.bounds;
    self.imageView.frame = self.view.bounds;
    
    CGFloat space = 30.0f;
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) - space * 2.0;
    if (_clipType == PhotoClipTypeNone) {
        [self.maskView removeFromSuperview];
    }else if (_clipType == PhotoClipTypeCircular){
        _cutoutRect = CGRectMake(space, _maskView.center.y - width / 2.0, width, width);
        _cutoutBezierPath = [UIBezierPath bezierPathWithArcCenter:_maskView.center radius:width / 2.0 startAngle:0 endAngle:2 * M_PI clockwise:NO];//clockwise (顺时针方向) 要选为NO,保留圆以外的部分
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:_maskView.bounds];
        [bezierPath appendPath:_cutoutBezierPath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        _maskView.layer.mask = shapeLayer;
    }else if (_clipType == PhotoClipTypeRectangle){
        CGFloat height = width / _widthAndHieghtRatio;
        if (height > (CGRectGetHeight(self.imageView.frame) - space * 2.0)) {
            height = (CGRectGetHeight(self.imageView.frame) - space * 2.0);
            width = height * _widthAndHieghtRatio;
        }
        _cutoutRect = CGRectMake((CGRectGetWidth(self.imageView.frame) - width) / 2.0, (CGRectGetHeight(self.imageView.frame) - height) / 2.0, width, height);
        _cutoutBezierPath = [UIBezierPath bezierPathWithRect:_cutoutRect];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:_maskView.bounds];
        [bezierPath appendPath:[_cutoutBezierPath bezierPathByReversingPath]];//矩形需要反方向绘制path
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        _maskView.layer.mask = shapeLayer;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - response Click

//返回按键
- (void)leftNavBarButtonClick{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.navigationController.viewControllers.firstObject isEqual:self]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightNavBarButtonClick{
    
    UIImage *image = [self imageByCaptureScreen];//截取屏幕
    
    if (_clipType != PhotoClipTypeNone) {//裁剪图片
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_cutoutRect.size.width,_cutoutRect.size.height), NO, 0);

        if (_clipType == PhotoClipTypeCircular){//切圆形
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_cutoutRect.size.width / 2.0, _cutoutRect.size.height / 2.0) radius:_cutoutRect.size.width / 2.0 startAngle:0 endAngle:2 * M_PI clockwise:NO];
            [bezierPath addClip];
        }else if (_clipType == PhotoClipTypeRectangle){//切矩形
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _cutoutRect.size.width, _cutoutRect.size.height)];
            [bezierPath addClip];
        }
        [image drawAtPoint:CGPointMake(-_cutoutRect.origin.x, -_cutoutRect.origin.y)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    if (self.saveHanlder) {
        self.saveHanlder(image);
    }
    [self leftNavBarButtonClick];
}

/* 截取当前屏幕
 */
-(UIImage *)imageByCaptureScreen {
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)),NO,0);
    CGContextRef context = UIGraphicsGetCurrentContext();//2.获取当前上下文
    [self.view.layer renderInContext:context];//3.截屏
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//4、获取新图片
    UIGraphicsEndImageContext();//5、关闭上下文
    return image;
}


#pragma mark - gesture Click

//旋转手势
- (void)rotationGestureRecognizerClick:(UIRotationGestureRecognizer *)rotationGesture{
    UIView *view = rotationGesture.view;
    if (rotationGesture.state == UIGestureRecognizerStateBegan || rotationGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGesture.rotation);
        [rotationGesture setRotation:0];
        //log下查看view.transform是怎么处理原理
    }
}

//缩放手势
- (void)pinchGestureRecognizerClick:(UIPinchGestureRecognizer *)pinchGesture{
    UIView *view = pinchGesture.view;
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
        if (CGRectGetWidth(self.imageView.frame) <= 0.5 * CGRectGetWidth(self.view.frame)){
            // 最小 0.5 倍
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5f];
            view.transform = CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0);
            [UIView commitAnimations];
        }
        if (CGRectGetWidth(self.imageView.frame) > 3 * CGRectGetWidth(self.view.frame)) {
            //最大 3 倍
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5f];
            view.transform = CGAffineTransformMake(3, 0, 0, 3, 0, 0);
            [UIView commitAnimations];
        }
        pinchGesture.scale = 1;
    }
}

// 处理拖拉
-(void)panGestureRecognizerClick:(UIPanGestureRecognizer *)panGesture{
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
}

#pragma mark - setters and getters

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

- (UIImageView *)imageView{
    if (_imageView == nil){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = _image;
        imageView.userInteractionEnabled = YES;
        
        // 旋转手势
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureRecognizerClick:)];
        [imageView addGestureRecognizer:rotationGesture];
        
        // 缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizerClick:)];
        [imageView addGestureRecognizer:pinchGesture];
        
        // 移动手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerClick:)];
        [imageView addGestureRecognizer:panGesture];

        _imageView = imageView;
    }
    return _imageView;
}

- (UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds))];
        _maskView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        _maskView.userInteractionEnabled = NO;
    }
    return _maskView;
}

@end
