//
//  ZJAlumTableViewController.h
//  CameraDemo
//
//  Created by 郑佳 on 16/8/17.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 相册列表控制器 */
@interface ZJAlbumTableViewController : UITableViewController

/** 初始化方法 */
- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets;
/** 最大选择图像数量 */ 
@property (nonatomic) NSInteger maxPickerCount;

@end
