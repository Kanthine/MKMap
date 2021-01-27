//
//  AlbumMainViewController.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPhotoViewController.h"
#import "PhotosManager.h"
#import "PHAsset+MediaStreams.h"

typedef NS_ENUM(NSUInteger ,AlbumResourcesType ) {
    AlbumResourcesTypeCamera = 0,//拍照
    AlbumResourcesTypeLibrary//相册
};

@interface AlbumMainViewController : UINavigationController

/******************* UI 的设置 *******************/
@property (nonatomic ,strong) UIColor *navBarColor;//导航栏背景色

/******************* 功能 的配置 *******************/
@property (nonatomic ,assign) AlbumResourcesType albumType;//相册或者相机
@property (nonatomic ,assign) NSInteger allowSelectCount;//允许选取的图片数量，默认为 1
@property (nonatomic ,assign) NSInteger selectedCount;//已经选取的图片数量（若大于0，则禁止再选视频）

/* 当 clipType = PhotoClipTypeRectangle 使用该值
 * 裁剪自定义比列的矩形，该值表示 “宽：高”
 * 如：4：3  、 16： 9 ， 1：1 等宽高比
 */
@property (nonatomic ,assign) float widthAndHieghtRatio;//宽比高
@property (nonatomic ,assign) PhotoClipType clipType;//裁剪类型
@property (nonatomic ,strong) NSString *clipPageTitle;


@property (nonatomic ,copy) void(^selectedImagesHanlder)(NSMutableArray<PHAsset *> *selectedArray);//选中的照片列表

- (instancetype)initWithAlbumResourcesType:(AlbumResourcesType)albumType;

- (void)selectFinishWithItem:(NSMutableArray<PHAsset *> *)selestedArray;

@end
