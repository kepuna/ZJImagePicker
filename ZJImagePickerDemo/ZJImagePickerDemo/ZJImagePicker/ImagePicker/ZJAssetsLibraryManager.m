//
//  ZJAssetsLibraryManager.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJAssetsLibraryManager.h"

@interface ZJAssetsLibraryManager ()

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

@end

@implementation ZJAssetsLibraryManager

+ (instancetype)manager{
   static ZJAssetsLibraryManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];
    });
    return _manager;
}

- (ALAssetsLibrary *)assetLibrary {
    if (_assetLibrary == nil)
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    return _assetLibrary;
}

- (void)getAlbumList:(void (^)(NSArray *))callBack{

    NSMutableArray *albums = [NSMutableArray array];
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group != nil) {
            
            //过滤出图片相册，应为gruop中可能是包含视频相册
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            ZJAlbum *album = [[ZJAlbum alloc] init];
            // 一个相册对应一个ALAssetsGroup对象
            album.group = group;
            // 相册名
            album.albumName = [group valueForProperty:ALAssetsGroupPropertyName];
            // 相册封面
            album.coverThumbImage = [UIImage imageWithCGImage:[group posterImage]];
            // 相册下图片个数
            album.assetsCount = [group numberOfAssets];
            [albums addObject:album];
            
        }else{
            callBack(albums);
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"getAlbum出错:%@",error);
    }];
}

- (void)getAssetWithAlbum:(ZJAlbum *)album finished:(void (^)(NSArray *))callBack{
    
    NSMutableArray *tempArray = [NSMutableArray array];
    //遍历对应的相册，每个group相册里存放的是一个个ALAsset对象，一个ALAsset对象代表一张图片
    [album.group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            [tempArray addObject:asset];
        }else{
            callBack(tempArray.copy);
        }
        
    }];

}


@end
