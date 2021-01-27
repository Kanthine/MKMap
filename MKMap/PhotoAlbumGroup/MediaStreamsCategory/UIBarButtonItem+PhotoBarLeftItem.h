//
//  UIBarButtonItem+PhotoBarLeftItem.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (PhotoBarLeftItem)

+ (instancetype)leftPhotoBackItemWithTarget:(nullable id)target action:(nullable SEL)action;

+ (instancetype)leftPhotoItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;
    
@end

@interface UIBarButtonItem (PhotoBarRightItem)

+ (instancetype)rightPhotoItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END
