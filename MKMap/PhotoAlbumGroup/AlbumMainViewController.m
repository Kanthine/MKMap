//
//  AlbumMainViewController.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import "AlbumMainViewController.h"
#import "AlbumGroupViewController.h"
#import "AlbumPhotoViewController.h"

@interface AlbumMainViewController ()

@end

@implementation AlbumMainViewController

- (instancetype)init{
    self = [super init];
    if (self){
        self.albumType = AlbumResourcesTypeLibrary;
        self.allowSelectCount = 1;
        self.selectedCount = 0;
        self.clipType = PhotoClipTypeNone;
    }
    return self;
}

- (instancetype)initWithAlbumResourcesType:(AlbumResourcesType)albumType{
    self = [super init];
    if (self){
        self.albumType = albumType;
        self.allowSelectCount = 1;
        self.selectedCount = 0;
        self.clipType = PhotoClipTypeNone;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_albumType == AlbumResourcesTypeCamera){
        [self initCameraUI];
    }else if (_albumType == AlbumResourcesTypeLibrary){
        [self initLibraryUI];
    }
    self.navBarColor = [UIColor colorWithRed:219/255.0 green:0/255.0 blue:8/255.0 alpha:1.0];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCameraUI{
//    PhotoPickerViewController *groupVC = [[PhotoPickerViewController alloc]init];
//    self.viewControllers = @[groupVC];
}

- (void)initLibraryUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相册";
    
    __weak typeof(self) weakSelf = self;
    AlbumGroupViewController *groupVC = [[AlbumGroupViewController alloc]init];
    groupVC.selectedImagesHanlder = ^(NSMutableArray<PHAsset *> *selectedArray) {
        [weakSelf selectFinishWithItem:selectedArray];
    };
    AlbumPhotoViewController *photoVC = [[AlbumPhotoViewController alloc]init];
    photoVC.selectedImagesHanlder = ^(NSMutableArray<PHAsset *> *selectedArray) {
        [weakSelf selectFinishWithItem:selectedArray];
    };
    self.viewControllers = @[groupVC,photoVC];
}

// 完成操作
- (void)selectFinishWithItem:(NSMutableArray<PHAsset *> *)selestedArray{
    if (self.selectedImagesHanlder) {
        self.selectedImagesHanlder(selestedArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavBarColor:(UIColor *)navBarColor{
    _navBarColor = navBarColor;
    [self.navigationBar setBackgroundImage:[AlbumMainViewController imageWithColor:navBarColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:UIColor.whiteColor}];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillRect(ctx, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
