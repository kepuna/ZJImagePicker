//
//  ZJImagePickerController.h
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJAlbum;


/** 多图选择控制器 */
@interface ZJImageGridViewController : UIViewController

// 初始化多图选择控制器
- (instancetype)initWithAlbum:(ZJAlbum *)album maxPickerCount:(NSInteger)maxPickerCount;
//- (instancetype)initWithAlbum:(ZJAlbum *)album
//               selectedAssets:(NSMutableArray *)selectedAssets
//               maxPickerCount:(NSInteger)maxPickerCount;


@end
