//
//  ZJViewerViewController.h
//  CameraDemo
//
//  Created by 郑佳 on 16/8/25.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJAsset;

@interface ZJViewerViewController : UIViewController

/** 图像索引 */
@property (nonatomic, assign) NSUInteger index;
/** 图像资源 */
@property (nonatomic, strong) ZJAsset *asset;

@end
