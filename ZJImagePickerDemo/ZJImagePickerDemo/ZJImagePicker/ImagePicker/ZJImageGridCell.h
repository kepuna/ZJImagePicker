//
//  ZJImageGridCell.h
//  CameraDemo
//
//  Created by 郑佳 on 16/8/17.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJImageGridCell,ZJImageSelectButton;
@protocol ZJImageGridCellDelegate <NSObject>

/** 图像选中代理事件 ：selected标记是否选中*/
- (void)imageGridCell:(ZJImageGridCell *)cell didSelected:(BOOL)selected;

@end

@interface ZJImageGridCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView; // 一张相片
@property (nonatomic, strong) ZJImageSelectButton *selectedButton;//选择按钮
@property (nonatomic, weak) id<ZJImageGridCellDelegate> delegate;//代理

@end

