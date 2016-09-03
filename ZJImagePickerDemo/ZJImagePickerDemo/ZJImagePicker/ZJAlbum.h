//
//  ZJAlbum.h
//  CameraDemo
//
//  Created by 郑佳 on 16/8/17.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>


/** 类用于ALAsset对象（一个对象代表一张图片）以及图片状态的封装 */
@interface ZJAsset : NSObject

/** 照片是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 缩略图 */
@property (nonatomic, strong) UIImage *thumbImage;
/** 原图 */
@property (nonatomic, strong) UIImage *originImage;


/** 记录ALAsset对象,为了获取原图时用到*/
@property (nonatomic, strong) ALAsset *asset;

//- (void)passAsset:(void (^)(ALAsset *as))asset;

@end

/** 相册模型*/
@interface ZJAlbum : NSObject

/** 相册的名称*/
@property (nonatomic, copy) NSString *albumName;
/** 相册封面缩略图 */
@property (nonatomic, strong) UIImage *coverThumbImage;
/** 相册下面图片个数*/
@property (nonatomic, assign) NSInteger assetsCount;
/** 一个ALAssetsGroup对象相当于一个相册 */
@property (nonatomic, strong) ALAssetsGroup *group;
/** 记录相册下‘存放的图片数组’（数组里是ZJAsset对象）*/
@property (nonatomic, strong) NSArray *assets;

/** 返回相册中index对应的图片 */
- (ZJAsset *)assetWithIndex:(NSInteger)index;

/** 返回对应图片在相册中的index */
- (NSUInteger)indexWithAsset:(ZJAsset *)asset;

@end
