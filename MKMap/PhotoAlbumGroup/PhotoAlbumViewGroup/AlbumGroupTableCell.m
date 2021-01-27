//
//  AlbumGroupTableCell.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import "AlbumGroupTableCell.h"

@interface AlbumGroupTableCell()

@property (nonatomic ,strong) UIImageView *homeImageView;
@property (nonatomic ,strong) UILabel *groupNameLable;
@property (nonatomic ,strong) UILabel *photoCountLable;
@property (nonatomic, strong) UILabel *grayLable;

@end

@implementation AlbumGroupTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.homeImageView];
        [self.contentView addSubview:self.groupNameLable];
        [self.contentView addSubview:self.photoCountLable];
        [self.contentView addSubview:self.grayLable];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect contentBounds = self.contentView.bounds;
    
    self.homeImageView.frame = CGRectMake(10, 10, CGRectGetHeight(contentBounds) - 20, CGRectGetHeight(contentBounds) - 20);
    CGFloat max_x = CGRectGetMaxX(self.homeImageView.frame) + 10;
    self.groupNameLable.frame = CGRectMake(max_x, CGRectGetHeight(contentBounds) / 2.0 - 20, CGRectGetWidth(contentBounds) - max_x - 60, 20);
    self.photoCountLable.frame = CGRectMake(max_x, CGRectGetMaxY(self.groupNameLable.frame) + 6, CGRectGetWidth(contentBounds) - max_x - 60, 20);
    self.grayLable.frame = CGRectMake(10, CGRectGetHeight(contentBounds) - 0.5, CGRectGetWidth(contentBounds), 0.5);

}

#pragma mark - public method

- (void)updateCellWithAssetCollection:(PHAssetCollection *)assetCollection{
    //只加载图片
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    //文件夹的名称
    NSString *title = assetCollection.localizedTitle;
    
    //文件夹中的图片有多少张
    NSUInteger albumCount = albumResult.count;
    self.groupNameLable.text = [NSString stringWithFormat:@"%@",title];
    self.photoCountLable.text   = [NSString stringWithFormat:@"%ld 张照片", (long)albumCount];
    
    //取出文件夹中的第一张图片作为文件夹的显示图片
    PHAsset *firstAsset = [albumResult firstObject];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    [imageManager requestImageForAsset:firstAsset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         self.homeImageView.image = result;
     }];
}

#pragma mark - setter and getters

- (UIImageView *)homeImageView{
    if (_homeImageView == nil){
        _homeImageView = [[UIImageView alloc]init];
        _homeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _homeImageView.clipsToBounds = YES;
    }
    return _homeImageView;
}

- (UILabel *)groupNameLable{
    if (_groupNameLable == nil){
        _groupNameLable = [[UILabel alloc]init];
        _groupNameLable.font = [UIFont systemFontOfSize:14];
        _groupNameLable.textColor = [UIColor blackColor];
        _groupNameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _groupNameLable;
}

- (UILabel *)photoCountLable{
    if (_photoCountLable == nil){
        _photoCountLable = [[UILabel alloc]init];
        _photoCountLable.font = [UIFont systemFontOfSize:14];
        _photoCountLable.textColor = [UIColor blackColor];
        _photoCountLable.textAlignment = NSTextAlignmentLeft;
    }
    return _photoCountLable;
}

- (UILabel *)grayLable{
    if (_grayLable == nil){
        _grayLable = [[UILabel alloc]init];
        _grayLable.backgroundColor =  [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    }
    return _grayLable;
}

@end
