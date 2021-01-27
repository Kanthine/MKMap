//
//  AlbumGroupViewController.m
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#define CellIdentifer @"AlbumGroupTableCell"

#import "AlbumGroupViewController.h"
#import "AlbumGroupTableCell.h"
#import "AlbumPhotoViewController.h"
#import "AlbumMainViewController.h"
#import "UIBarButtonItem+PhotoBarLeftItem.h"

@interface AlbumGroupViewController ()
<UITableViewDelegate,UITableViewDataSource>

/** 未授权时调用 计时器 */
@property (nonatomic, strong) NSTimer *authorizationTimer;
/** 保存相册文件夹 */
@property (nonatomic, strong) NSMutableArray<PHAssetCollection *> *fetchAlbumArray;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation AlbumGroupViewController

- (instancetype)init{
    self = [super init];
    if (self){
        [self loadAllPhotosResource];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavBar];
    [self.view addSubview:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

- (void)customNavBar{
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相簿列表";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightPhotoItemWithTitle:@"取消" target:self action:@selector(rightNavBarButtonClick)];
}

- (void)rightNavBarButtonClick{
    AlbumMainViewController *mainNav = (AlbumMainViewController *)self.navigationController;
    [mainNav selectFinishWithItem:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchAlbumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumGroupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    PHAssetCollection *album = self.fetchAlbumArray[indexPath.row];
    [cell updateCellWithAssetCollection:album];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self) weakSelf = self;
    PHAssetCollection *album = self.fetchAlbumArray[indexPath.row];
    AlbumPhotoViewController *photosVC = [[AlbumPhotoViewController alloc]initWithPHAssetCollection:album SelectedArray:_selestedArray];
    photosVC.selectedImagesHanlder = ^(NSMutableArray<PHAsset *> *selectedArray) {
        if (weakSelf.selectedImagesHanlder) {
            weakSelf.selectedImagesHanlder(selectedArray);
        }
    };
    [self.navigationController pushViewController:photosVC animated:YES];
}

#pragma mark - AlbumPhotoViewControllerDelegate

- (void)leftBackButtonClick:(NSMutableArray<PHAsset *> *)selectedArray{
    _selestedArray = selectedArray;
}

#pragma mark - Load Resources


#pragma mark - private method

/* 默认 加载所有的相册
 */
- (void)loadAllPhotosResource{
    __weak __typeof__(self) weakSelf = self;
    
    [PhotosManager loadPhotoAlbumCompletionBlock:^(NSMutableArray<PHAssetCollection *> *listArray){
         weakSelf.fetchAlbumArray = listArray;
         [weakSelf.tableView reloadData];
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
        
        if (self.fetchAlbumArray.count == 0){
            __weak __typeof__(self) weakSelf = self;
            
            [PhotosManager loadPhotoAlbumCompletionBlock:^(NSMutableArray<PHAssetCollection *> *listArray){
                 weakSelf.fetchAlbumArray = listArray;
                 [weakSelf.tableView reloadData];
             }];
        }
    }
}

#pragma mark - setter and getters

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AlbumGroupTableCell class] forCellReuseIdentifier:CellIdentifer];
    }
    return _tableView;
}

@end
