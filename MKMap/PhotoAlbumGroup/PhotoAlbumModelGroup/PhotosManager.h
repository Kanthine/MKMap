//
//  PhotosManager.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotosManager : NSObject


/* 判断相册是否授权
 * @return YES 授权成功；NO 没有授权
 */
+ (BOOL)libraryAuthorization;

/* 请求相册授权
 */
+ (void)requestLibraryAuthorization;

/* 判断相机是否授权
 * @return YES 授权成功；NO 没有授权
 */
+ (BOOL)cameraAuthorization;

/* 请求相机授权
*/
+ (void)requestCameraAuthorization;

/*
 *加载图库所有照片
 */
+ (void)loadAllPhotosCompletionBlock:(void (^) (NSMutableArray <PHAsset*>*listArray))block;

/**
 把英文的文件夹名称转换为中文
 */
+ (NSString *)getchineseAlbum:(NSString *)name;

/*
 *加载相册夹的所属照片
 */
+ (void)loadPhotosPHAssetCollection:(PHAssetCollection *)assetCollection CompletionBlock:(void (^) (NSMutableArray <PHAsset*>*listArray))block;


/*
 *获取最近一张照片
 */
+ (void)fetchLatestAssetCompletionBlock:(void (^) (PHAsset *asset))block;

/*
 *加载图库的相册夹
 */
+ (void)loadPhotoAlbumCompletionBlock:(void (^) (NSMutableArray <PHAssetCollection*>*listArray))block;

@end
