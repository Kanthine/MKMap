//
//  PHAsset+MediaStreams.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/9.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (MediaStreams)

@property (nonatomic ,strong) UIImage *originalImage;

@property (nonatomic ,strong) UIImage *clipImage;

@property (nonatomic ,strong) NSURL *videoURL;

@property (nonatomic ,assign) int selectedIndex;//选中的位置

@end

NS_ASSUME_NONNULL_END
