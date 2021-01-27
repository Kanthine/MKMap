//
//  AlbumGroupTableCell.h
//  YLAlbumTool
//
//  Created by 苏沫离 on 2019/8/8.
//  Copyright © 2019 YLAlbumTool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumGroupTableCell : UITableViewCell

- (void)updateCellWithAssetCollection:(PHAssetCollection *)assetCollection;

@end
