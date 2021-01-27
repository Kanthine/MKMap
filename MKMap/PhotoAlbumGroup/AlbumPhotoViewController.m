//
//  AlbumPhotoViewController.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#define CellIdentifer @"AlbumPhotoCollectionCell"
#define CellAddIdentifer @"AlbumPhotoCollectionAddCell"

#import "AlbumPhotoViewController.h"
#import "PhotosManager.h"
#import "AlbumPhotoCollectionCell.h"
#import "AlbumMainViewController.h"
#import "UIBarButtonItem+PhotoBarLeftItem.h"
#import "EditPhotoViewController.h"

@interface AlbumPhotoViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate
,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSInteger _allowSelectCount;
    NSString *_titleStr;
}

/** 未授权时调用 计时器 */
@property (nonatomic, strong) NSTimer *authorizationTimer;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *dataArray;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedArray;

@end

@implementation AlbumPhotoViewController

- (void)dealloc{
    _authorizationTimer = nil;
    _collectionView = nil;
    _dataArray = nil;
}

/* 加载全部照片
 */
- (instancetype)init{
    self = [super init];
    if (self){
        _titleStr = @"所有照片";
        [self loadAllPhotosResource];
    }
    return self;
}

/* 加载相册相片
 */
- (instancetype)initWithPHAssetCollection:(PHAssetCollection *)assetCollection SelectedArray:(NSMutableArray<PHAsset *> *)selectedArray{
    self = [super init];
    if (self){
        _titleStr = assetCollection.localizedTitle;
        _selectedArray = selectedArray;
        [self loadPhotosPHAssetCollection:assetCollection];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _titleStr;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftPhotoBackItemWithTarget:self action:@selector(leftNavBarButtonClick)];

    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AlbumMainViewController *mainNav = (AlbumMainViewController *)self.navigationController;
    _allowSelectCount = mainNav.allowSelectCount;
    
    if (_allowSelectCount > 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightPhotoItemWithTitle:@"确定" target:self action:@selector(finishButtonClick)];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightPhotoItemWithTitle:@"取消" target:self action:@selector(rightNavBarButtonClick)];
    }
}

#pragma mark - response Click
- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//取消按钮
- (void)rightNavBarButtonClick{
    AlbumMainViewController *mainNav = (AlbumMainViewController *)self.navigationController;
    [mainNav selectFinishWithItem:nil];
}

//完成按钮
- (void)finishButtonClick{
    
    if (self.selectedArray.count > 0) {
        if (self.selectedImagesHanlder) {
            self.selectedImagesHanlder(self.selectedArray);
        }
    }else{
//        [self.view makeToast:@"请选择至少1张图片" duration:1.5 position:CSToastPositionCenter];
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1 + self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AlbumPhotoCollectionAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellAddIdentifer forIndexPath:indexPath];
        return cell;
    }
    
    AlbumPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    PHAsset *asset = self.dataArray[indexPath.item -1];
    cell.asset = asset;
    if (_allowSelectCount == 1) {
        cell.indexLable.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//相机
        if (PhotosManager.cameraAuthorization) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        }else{
            [PhotosManager requestCameraAuthorization];
        }
        return;
    }
    
    PHAsset *asset = self.dataArray[indexPath.item - 1];
    if (_allowSelectCount == 1) {//仅仅选择一张照片
        [self selectedPHAsset:asset indexPath:indexPath];
        return;
    }
    
    if ([_selectedArray containsObject:asset]) {//取消选中
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
        
        //后面的顺序，挨个减 1
        NSUInteger index = [_selectedArray indexOfObject:asset];
        [_selectedArray enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > index) {
                obj.selectedIndex --;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:obj] + 1 inSection:0];
                [indexPaths addObject:indexPath];
            }
        }];
        //从选中状态消去
        asset.selectedIndex = -1;
        [self.selectedArray removeObject:asset];
        [collectionView reloadItemsAtIndexPaths:indexPaths];
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    
    //判断添加的数量
    if (_selectedArray.count == _allowSelectCount){
        NSString *tip = [NSString stringWithFormat:@"照片最多不超过%ld张",_allowSelectCount];
//        [self.view makeToast:tip duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if (asset.originalImage == nil){
        AlbumPhotoCollectionCell *cell = (AlbumPhotoCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
        PHImageManager *imageManager = [PHImageManager defaultManager];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.networkAccessAllowed = YES;
        
        [cell startDownLoad];
        
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds) * 2, CGRectGetHeight(UIScreen.mainScreen.bounds) * 2) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info){
             BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            
             if (downloadFinined){
                 asset.originalImage = result;
                 [weakSelf.selectedArray addObject:asset];
                 asset.selectedIndex = (int)weakSelf.selectedArray.count;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [cell stopDownLoad];
                     [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                 });
             }
         }];
    }else{
        [self.selectedArray addObject:asset];
        asset.selectedIndex = (int)self.selectedArray.count;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}


/************************  选择单张图片的流程 *************************/

- (void)selectedPHAsset:(PHAsset *)asset indexPath:(NSIndexPath *)indexPath{
    if (asset.originalImage == nil){
        AlbumPhotoCollectionCell *cell = (AlbumPhotoCollectionCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
        PHImageManager *imageManager = [PHImageManager defaultManager];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.networkAccessAllowed = YES;
        [cell startDownLoad];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds) * 2, CGRectGetHeight(UIScreen.mainScreen.bounds) * 2) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info){
             BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
             if (downloadFinined){
                 asset.originalImage = result;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self climtImageWithImage:asset];
                     [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                 });
             }
         }];
    }else{
        [self climtImageWithImage:asset];
        if (indexPath) {
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

/*  裁剪图片
 */
- (void)climtImageWithImage:(PHAsset *)asset{
    AlbumMainViewController *mainNav = (AlbumMainViewController *)self.navigationController;
    
    if (mainNav.clipType == PhotoClipTypeNone) {
        if (self.selectedImagesHanlder) {
            self.selectedImagesHanlder([NSMutableArray arrayWithObject:asset]);
        }
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        EditPhotoViewController *editVC = [[EditPhotoViewController alloc] initWithImage:asset.originalImage];
        editVC.clipType = mainNav.clipType;
        editVC.widthAndHieghtRatio = mainNav.widthAndHieghtRatio;
        editVC.navigationItem.title = mainNav.clipPageTitle;
        editVC.saveHanlder = ^(UIImage *clipImage) {
            asset.clipImage = clipImage;
            
            if (weakSelf.selectedImagesHanlder) {
                weakSelf.selectedImagesHanlder([NSMutableArray arrayWithObject:asset]);
            }
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            
        } else {
            [PhotosManager fetchLatestAssetCompletionBlock:^(PHAsset *asset) {
                asset.originalImage = image;
                [self.dataArray insertObject:asset atIndex:0];
                [self.collectionView reloadData];
                if (_allowSelectCount == 1) {//仅仅选择一张照片
                    [self selectedPHAsset:asset indexPath:nil];
                }
            }];
        }
    }];
    
        

}

#pragma mark - Load Resources

- (void)loadPhotosPHAssetCollection:(PHAssetCollection *)assetCollection{
    __weak __typeof__(self) weakSelf = self;
    [PhotosManager loadPhotosPHAssetCollection:assetCollection CompletionBlock:^(NSMutableArray<PHAsset *> *listArray) {
        weakSelf.dataArray = listArray;
        if (weakSelf.collectionView){
            [weakSelf.collectionView reloadData];
        }
    }];
    
    if (PhotosManager.libraryAuthorization == NO){
        [PhotosManager requestLibraryAuthorization];
        
        //计时，每隔0.2s判断一次改程序是否被允许访问相册，当允许访问相册的时候，计时器停止工作
        self.authorizationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(authorizationStateChange) userInfo:nil repeats:YES];
    }
}

/*
 *默认 加载所有的照片
 */
- (void)loadAllPhotosResource{
    __weak __typeof__(self) weakSelf = self;
    [PhotosManager loadAllPhotosCompletionBlock:^(NSMutableArray<PHAsset *> *listArray){
         weakSelf.dataArray = listArray;
         if (weakSelf.collectionView){
             [weakSelf.collectionView reloadData];
         }
     }];
    
    if (PhotosManager.libraryAuthorization == NO){
        [PhotosManager requestLibraryAuthorization];
        
        //计时，每隔0.2s判断一次改程序是否被允许访问相册，当允许访问相册的时候，计时器停止工作
        self.authorizationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(authorizationStateChange) userInfo:nil repeats:YES];
    }
}

/* 计时器的方法，来监测改程序是否被授权访问相册，如果授权访问相册了，那么计时器停止工作
 */
- (void)authorizationStateChange{
    if (PhotosManager.libraryAuthorization){
        //允许访问相册，计时器停止工作
        [self.authorizationTimer invalidate];
        self.authorizationTimer = nil;
        
        if (self.dataArray.count == 0){
            __weak __typeof__(self) weakSelf = self;
            
            [PhotosManager loadAllPhotosCompletionBlock:^(NSMutableArray<PHAsset *> *listArray){
                 weakSelf.dataArray = listArray;
                 
                 if (listArray && listArray.count){
                     
                 }
                 if (weakSelf.collectionView){
                     [weakSelf.collectionView reloadData];
                 }
             }];
        }
    }
}

#pragma mark - setter and getters

- (NSMutableArray<PHAsset *>*)dataArray{
    if (_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<PHAsset *>*)selectedArray{
    if (_selectedArray == nil){
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        CGFloat itemSpace = 5.0;
        CGFloat itemWidth = (CGRectGetWidth(UIScreen.mainScreen.bounds) - itemSpace * 5) / 4.0;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = itemSpace;
        layout.minimumInteritemSpacing = itemSpace;
        layout.sectionInset = UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace, itemSpace);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
            
        [_collectionView registerClass:[AlbumPhotoCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
        [_collectionView registerClass:AlbumPhotoCollectionAddCell.class forCellWithReuseIdentifier:CellAddIdentifer];
    }
    
    return _collectionView;
}

@end
