//
//  PHAsset+MediaStreams.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/9.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import "PHAsset+MediaStreams.h"

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
@implementation PHAsset (MediaStreams)

- (void)setOriginalImage:(UIImage *)originalImage{
    objc_setAssociatedObject(self, @selector(originalImage), originalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)originalImage{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setClipImage:(UIImage *)clipImage{
    objc_setAssociatedObject(self, @selector(clipImage), clipImage,OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)clipImage{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setVideoURL:(NSURL *)videoURL{
    objc_setAssociatedObject(self, @selector(videoURL), videoURL,OBJC_ASSOCIATION_RETAIN);
}

- (NSURL *)videoURL{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSelectedIndex:(int)selectedIndex{
    objc_setAssociatedObject(self, @selector(selectedIndex), @(selectedIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)selectedIndex{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

@end
