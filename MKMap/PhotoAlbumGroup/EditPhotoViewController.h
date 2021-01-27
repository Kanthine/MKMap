//
//  EditPhotoViewController.h
//  YLAlbumTool
//
//  Created by 龙 on 2017/8/15.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <UIKit/UIKit.h>

//裁剪类型
typedef NS_ENUM(NSUInteger ,PhotoClipType) {
    PhotoClipTypeNone = 0,//不裁剪
    PhotoClipTypeCircular, //圆形
    PhotoClipTypeRectangle ,//矩形 : 需要再进一步设置宽高比
};

@interface EditPhotoViewController : UIViewController

@property (nonatomic ,strong) UIImage *image;//原始图片
@property (nonatomic ,assign) PhotoClipType clipType;//裁剪类型

/* @note 当 clipType = PhotoClipTypeRectangle 时该值有效
 * 裁剪自定义比列的矩形，该值表示 “宽：高”
 * 如：4：3  、 16： 9 ， 1：1 等宽高比
 */
@property (nonatomic ,assign) float widthAndHieghtRatio;//宽比高

@property (nonatomic ,copy) void(^saveHanlder)(UIImage *clipImage);//切片

- (instancetype)initWithImage:(UIImage *)image;

@end
