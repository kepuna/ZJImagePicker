//
//  ZJAssetsLibraryManager.h
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

/**
 
 ALAssetsLibrary 提供了访问iOS设备下”照片”应用下所有照片和视频的接口；
 
 1. 从 ALAssetsLibrary 中可读取所有的相册数据,即 ALAssetsGroup 对象列表；
 2. 从每个 ALAssetsGroup 中可获取到其中包含的照片或视频列表,即 ALAsset 对象列表；
 3. 每个 ALAsset 可能有多个representations表示,即 ALAssetRepresentation 对象，使用其 defaultRepresentation 方法可获得其默认representations，使用[asset valueForProperty: ALAssetPropertyRepresentations ]可获取其所有representations的 UTI 数组。
 4. 从ALAsset对象可获取缩略图 thumbnail 或 aspectRatioThumbnail ；
 5. 从 ALAssetRepresentation 对象可获取全尺寸图片（ fullResolutionImage ），全屏图片（ fullScreenImage ）及图片的各种属性: orientation ， dimensions， scale ， url ， metadata 等。
 */

//  ALAssetsLibrary -> ALAssetsGroup -> ALAsset ->ALAssetRepresentation
//通过ALAssetsLibrary对象获取的其他对象只在该ALAssetsLibrary对象生命期内有效，若ALAssetsLibrary对象被销毁，则其他从它获取的对象将不能被访问

#import <Foundation/Foundation.h>
#import "ZJAlbum.h"

// 回调
@interface ZJAssetsLibraryManager : NSObject


+ (instancetype)manager;

/** 获取所有组对应的图片 */
- (void)getAlbumList:(void(^)(NSArray *albumList) )callBack;

/**
 * 获取所有组对应的Videos
 */
//- (void)getAllGroupWithVideos:(groupCallBackBlock )callBack;

/**
 *  传入一个组获取组里面的Asset
 */
- (void)getAssetWithAlbum:(ZJAlbum *)album finished:(void(^)(NSArray *assets))callBack;

/**
 *  传入一个AssetsURL来获取UIImage
 */
//- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(groupCallBackBlock ) callBack;

@end
