//
//  ZJNavController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJImagePickerController.h"
#import "ZJAlbumTableViewController.h"
#import "ZJAlbum.h"

@implementation ZJImagePickerController{

    ZJAlbumTableViewController *_tableViewController;
    NSMutableArray *_selectedAssets; // 存放选中的图片的数组
}

/**
 * 初始化方法
 */
- (instancetype)initWithSelectedAssets:(NSArray *)selectedAssets{
    
    if (self = [super init]) {
    
        if (selectedAssets == nil) {
            _selectedAssets = @[].mutableCopy;
        } else {
            _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        }
        self.maxPickerCount = 9; // 默认最大选择图像数量
        _tableViewController = [[ZJAlbumTableViewController alloc] initWithSelectedAssets:_selectedAssets];
        [self pushViewController:_tableViewController animated:NO];
        
        //监听选择完成的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageSelectedDone:) name:@"ZJImagesSelectedDoneNotification" object:nil];
    }
    return self;
}

#pragma mark - 图片选择完成触发
- (void)imageSelectedDone:(NSNotification *)notification{
    
    NSArray *selectedAssets = notification.userInfo[@"ZJSelectedAssetsKey"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ZJAsset *asset in selectedAssets) {
        [tempArray addObject:asset.thumbImage];
    }
   
    if ([self.imagePickerdelegate respondsToSelector:@selector(imagePickerController:didFinishSelectedImages:selectedAssets:)]) {
        [self.imagePickerdelegate imagePickerController:self didFinishSelectedImages:tempArray.copy selectedAssets:selectedAssets];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 重写setter、getter方法 设置最大限制
- (void)setMaxPickerCount:(NSInteger)maxPickerCount {
    _tableViewController.maxPickerCount = maxPickerCount;
}
- (NSInteger)maxPickerCount{
    return _tableViewController.maxPickerCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];

}

- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backBtnClick)];
}

- (void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     NSLog(@"%s销毁了",__func__);
}


@end
