//
//  ZJNavController.h
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJImagePickerController;
@protocol ZJImagePickerControllerDelegate <NSObject>

/**
 图像选择完成代理方法 
 images : 该数组里存放的是UIImage对象，方便界面展示
 selectedAssets: 该数组存放的是ZJAsset对象，方便重新定位图像
 */

- (void)imagePickerController:(ZJImagePickerController *)picker
      didFinishSelectedImages:(NSArray *)images
               selectedAssets:(NSArray *)selectedAssets;

@end

/** 
 * 图像选择控制器
 */
@interface ZJImagePickerController : UINavigationController

/** 初始化方法 selectedAssets 选中素材数组，可用于预览之前选中的照片集合 */
- (instancetype)initWithSelectedAssets:(NSArray *)selectedAssets;
/** 最大选择图像数量 (默认9张) */
@property (nonatomic, assign) NSInteger maxPickerCount;
@property (nonatomic, weak) id<ZJImagePickerControllerDelegate> imagePickerdelegate;


@end
