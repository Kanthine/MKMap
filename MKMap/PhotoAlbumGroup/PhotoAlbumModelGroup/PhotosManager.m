//
//  PhotosManager.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//



#import "PhotosManager.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <UIKit/UIKit.h>

NSString * const kIsShowLibraryAlertKey = @"PhotosManager.isShowLibraryAlert";
NSString * const kIsShowCameraAlertKey = @"PhotosManager.isShowCameraAlert";


@interface PhotosManager ()

+ (UIViewController *)yl_PA_getCurrentViewController;

@end

@implementation PhotosManager

+ (BOOL)libraryAuthorization{
    //授权成功、或者从未授权，调用相册
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized ||
        PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined){
        return YES;
    }else{
        return NO;
    }
}

/* 请求相册授权
 */
+ (void)requestLibraryAuthorization{
    
    if ([[NSUserDefaults.standardUserDefaults objectForKey:kIsShowLibraryAlertKey] boolValue]) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:@(YES) forKey:kIsShowLibraryAlertKey];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App需要你的同意,访问相册,选择照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@(NO) forKey:kIsShowLibraryAlertKey];
    }];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@(NO) forKey:kIsShowLibraryAlertKey];
        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:agreeAction];
    [PhotosManager.yl_PA_getCurrentViewController presentViewController:alertController animated:YES completion:nil];
}

/* 判断相机是否授权
 * @return YES 授权成功；NO 没有授权
 */
+ (BOOL)cameraAuthorization{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized ||
        status == AVAuthorizationStatusNotDetermined){
        return YES;
    }else{
        return NO;
    }
}

/** 请求相机授权
 */
+ (void)requestCameraAuthorization{
    
    if ([[NSUserDefaults.standardUserDefaults objectForKey:kIsShowCameraAlertKey] boolValue]) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:@(YES) forKey:kIsShowCameraAlertKey];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App需要你的同意,访问相机,拍摄照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@(NO) forKey:kIsShowCameraAlertKey];
    }];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@(NO) forKey:kIsShowCameraAlertKey];
        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:agreeAction];
    [PhotosManager.yl_PA_getCurrentViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)loadAllPhotosCompletionBlock:(void (^) (NSMutableArray <PHAsset*>*listArray))block{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //获取所有照片
       PHFetchOptions *timeOptions = [[PHFetchOptions alloc] init];
       timeOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //时间从近到远
       timeOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];//只加载图片
       PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:timeOptions];
       
       for (int i = 0; i < assetsFetchResults.count; i ++){
           PHAsset *asset = assetsFetchResults[i];
           NSLog(@"location ===== %@",asset.location);
           [resultArray addObject:asset];
       }
       
       dispatch_async(dispatch_get_main_queue(), ^{
           block(resultArray);
       });
   });
    
}

+ (void)loadPhotosPHAssetCollection:(PHAssetCollection *)assetCollection CompletionBlock:(void (^) (NSMutableArray <PHAsset*>*listArray))block{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //只加载图片
       PHFetchOptions *option = [[PHFetchOptions alloc] init];
       option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //时间从近到远
       option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
       PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
       
       for (int i = 0; i < albumResult.count; i++){
           PHAsset *asset = albumResult[i];
           [resultArray addObject:asset];
       }
       
       dispatch_async(dispatch_get_main_queue(), ^{
                          block(resultArray);
       });
   });
}

+ (void)loadPhotoAlbumCompletionBlock:(void (^) (NSMutableArray <PHAssetCollection*>*listArray))block{
    NSMutableArray *resultArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //1，PHAssetCollectionTypeSmartAlbum
       PHFetchResult *albumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
       
       // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
       for (NSInteger i = 0; i < albumsFetchResult.count; i++){
           // 获取一个相册（PHAssetCollection）
           PHCollection *collection = albumsFetchResult[i];
           
           if ([collection isKindOfClass:[PHAssetCollection class]]) {
               
               PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
               
               if ([assetCollection.localizedTitle isEqualToString:@"Videos"]){
                   //过滤掉视频
                   continue;
               }
               
               //只加载图片
               PHFetchOptions *option = [[PHFetchOptions alloc] init];
               option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
               // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
               PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
               
               if (fetchResult.count > 0){
                   [resultArray addObject:assetCollection];
               }
           }
       }
       
       
       //2，PHAssetCollectionTypeAlbum
       PHFetchResult *ownAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
       // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
       for (NSInteger i = 0; i < ownAlbumsFetchResult.count; i++) {
           // 获取一个相册（PHAssetCollection）
           PHCollection *collection = ownAlbumsFetchResult[i];
           
           if ([collection isKindOfClass:[PHAssetCollection class]]) {
               
               PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
               if ([assetCollection.localizedTitle isEqualToString:@"Videos"]) {//过滤掉视频
                   continue;
               }
               //只加载图片
               PHFetchOptions *option = [[PHFetchOptions alloc] init];
               option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
               // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
               PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
               
               if (fetchResult.count > 0){
                   [resultArray addObject:assetCollection];
               }
           }
       }
       
       
       
       dispatch_async(dispatch_get_main_queue(), ^{
                          block(resultArray);
       });
   });
}


+ (void)fetchLatestAssetCompletionBlock:(void (^) (PHAsset *asset))block;{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // 获取所有资源的集合，并按资源的创建时间排序
       PHFetchOptions *options = [[PHFetchOptions alloc] init];
       options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
       PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
       PHAsset *asset = [assetsFetchResults firstObject];
       dispatch_async(dispatch_get_main_queue(), ^{
           block(asset);
       });
   });
}

#pragma mark - helper Method

/** 把英文的文件夹名称转换为中文
 */
+ (NSString *)getchineseAlbum:(NSString *)name{
    NSString *newName = @"";
    if ([name rangeOfString:@"Roll"].location != NSNotFound)         newName = @"相机胶卷";
    else if ([name rangeOfString:@"Stream"].location != NSNotFound)  newName = @"我的照片流";
    else if ([name rangeOfString:@"Added"].location != NSNotFound)   newName = @"最近添加";
    else if ([name rangeOfString:@"Selfies"].location != NSNotFound) newName = @"自拍";
    else if ([name rangeOfString:@"shots"].location != NSNotFound)   newName = @"截屏";
    else if ([name rangeOfString:@"Videos"].location != NSNotFound)  newName = @"视频";
    else if ([name rangeOfString:@"Panoramas"].location != NSNotFound)  newName = @"全景照片";
    else if ([name rangeOfString:@"Favorites"].location != NSNotFound)  newName = @"个人收藏";
    else if ([name rangeOfString:@"All Photos"].location != NSNotFound)  newName = @"所有照片";
    else newName = name;
    return newName;
}

+ (UIViewController *)yl_PA_getCurrentViewController{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}


@end

