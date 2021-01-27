//
//  AlbumPhotoCollectionCell.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import "AlbumPhotoCollectionCell.h"
#import "PhotosManager.h"

@implementation AlbumPhotoCollectionAddCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MediaStreamsResource.bundle/albumPhoto_add"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 10;
        imageView.frame = CGRectMake(0, 0, 36, 30);
        [self.contentView addSubview:imageView];

        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
        lable.text = @"拍摄照片";
        lable.tag = 11;
        [self.contentView addSubview:lable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView viewWithTag:10].center = CGPointMake(CGRectGetWidth(self.contentView.frame) / 2.0, CGRectGetHeight(self.contentView.frame) / 2.0 - 10);
    [self.contentView viewWithTag:11].frame = CGRectMake(0, CGRectGetMaxY([self.contentView viewWithTag:10].frame), CGRectGetWidth(self.contentView.frame), 16);
}

@end










@interface AlbumPhotoCollectionCell ()
@property (nonatomic, strong) UIActivityIndicatorView *activityView;//云图片下载
@property (nonatomic, strong) UILabel *tipLable;
@property (nonatomic ,assign) int selectedIndex;

@end

@implementation AlbumPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self){

        [self.contentView addSubview:self.assetImageView];
        [self.contentView addSubview:self.indexLable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.assetImageView.frame = self.contentView.bounds;
    self.indexLable.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 18 - 6, 6, 18, 18);

}

//[asset.creationDate isEqualToDate:obj.creationDate]

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info){
         self.assetImageView.image = result;
     }];
    
    self.selectedIndex = asset.selectedIndex;
}


- (void)startDownLoad{
    if (_activityView == nil){
        [self.contentView addSubview:self.activityView];
        self.activityView.center = CGPointMake(CGRectGetWidth(self.contentView.frame) / 2.0, CGRectGetHeight(self.contentView.frame) / 2.0 - 10);
      [self.contentView addSubview:self.tipLable];
      self.tipLable.frame = CGRectMake(0, CGRectGetMaxY(self.activityView.frame), CGRectGetWidth(self.contentView.frame), 16);
    }
    [self.activityView startAnimating];
}

- (void)stopDownLoad{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    _activityView = nil;
    
    [self.tipLable removeFromSuperview];
    _tipLable = nil;
}

#pragma mark - setter and getters

- (void)setSelectedIndex:(int)selectedIndex{
    _selectedIndex = selectedIndex;
    if (selectedIndex > 0) {
        self.indexLable.text = [NSString stringWithFormat:@"%d",selectedIndex];
        self.indexLable.layer.backgroundColor = [UIColor colorWithRed:219/255.0 green:0/255.0 blue:8/255.0 alpha:1.0].CGColor;
    }else{
        self.indexLable.text = @"";
        self.indexLable.layer.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3].CGColor;
    }
}

- (UIActivityIndicatorView *)activityView{
    if (_activityView == nil){
       _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.frame = CGRectMake(0, 0, 20, 20);
    }
    return _activityView;
}

- (UILabel *)tipLable{
    if (_tipLable == nil){
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = [UIColor blackColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"云下载中...";
        _tipLable = lable;
    }
    return _tipLable;
}

- (UIImageView *)assetImageView{
    if (_assetImageView == nil){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _assetImageView = imageView;
    }
    return _assetImageView;
}

- (UILabel *)indexLable{
    if (_indexLable == nil) {
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = UIColor.whiteColor;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.frame = CGRectMake(6, 6, 18, 18);
        lable.layer.borderWidth = 1;
        lable.layer.borderColor = UIColor.whiteColor.CGColor;
        lable.layer.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3].CGColor;
        lable.layer.cornerRadius = CGRectGetWidth(lable.frame) / 2.0;
        lable.clipsToBounds = YES;
        _indexLable = lable;
    }
    return _indexLable;
}


@end


