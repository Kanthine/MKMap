//
//  AlbumPhotoCollectionCell.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAsset+MediaStreams.h"


@interface AlbumPhotoCollectionAddCell : UICollectionViewCell

@end


@interface AlbumPhotoCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *assetImageView;
@property (nonatomic ,strong) PHAsset *asset;
@property (nonatomic, strong) UILabel *indexLable;


- (void)startDownLoad;
- (void)stopDownLoad;

@end
