//
//  UIBarButtonItem+PhotoBarLeftItem.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import "UIBarButtonItem+PhotoBarLeftItem.h"


@implementation UIBarButtonItem (PhotoBarLeftItem)
+ (instancetype)leftPhotoBackItemWithTarget:(nullable id)target action:(nullable SEL)action{
//    return [UIBarButtonItem leftItemWithImage:[UIImage imageNamed:@"navBar_left_back_white"] target:target action:action];
    return nil;
}

+ (instancetype)leftPhotoItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.frame = CGRectMake(0, 0, 50, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return leftBarItem;
}
    
    
@end



@implementation UIBarButtonItem (PhotoBarRightItem)

+ (instancetype)rightPhotoItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barItem;
}

@end
