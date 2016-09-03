//
//  ZJPreviewViewController.h
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/26.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJAlbum,ZJAsset,ZJPreviewViewController;


@protocol ZJPreviewViewControllerDelegate <NSObject>

/// 预览控制器修改资源选中状态
///
/// @param previewViewController 预览控制器
/// @param asset                 资源
/// @param selected              是否选中
///
/// @return 是否允许修改
- (BOOL)previewViewController:(ZJPreviewViewController *)previewViewController didChangedAsset:(ZJAsset *)asset selected:(BOOL)selected;

/** @return 选中资源数组  */
- (NSMutableArray *)previewViewControllerSelectedAssets;

@end

@interface ZJPreviewViewController : UIViewController

- (instancetype)initWithAlbum:(ZJAlbum *)album selectedAssets:(NSMutableArray *)selectedAssets maxPickerCount:(NSInteger)maxPickerCount indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<ZJPreviewViewControllerDelegate> delegate;

@end
