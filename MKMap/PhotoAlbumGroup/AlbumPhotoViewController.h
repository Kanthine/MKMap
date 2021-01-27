//
//  AlbumPhotoViewController.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumPhotoViewController : UIViewController

/* 选中的照片列表
 */
@property (nonatomic ,copy) void(^selectedImagesHanlder)(NSMutableArray<PHAsset *> *selectedArray);

/* 初始化相册列表
 * @param assetCollection 相册源数据
 * @param selectedArray 已经选择的照片；可为 nil
 */
- (instancetype)initWithPHAssetCollection:(PHAssetCollection *)assetCollection SelectedArray:(NSMutableArray<PHAsset *> *)selectedArray;

@end
