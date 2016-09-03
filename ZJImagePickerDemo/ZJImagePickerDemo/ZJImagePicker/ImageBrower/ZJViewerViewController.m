//
//  ZJViewerViewController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/26.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJViewerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZJAlbum.h"

@interface ZJViewerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZJViewerViewController


- (void)setAsset:(ZJAsset *)asset{
    
    _asset = asset;

    [self.scrollView addSubview:self.imageView];
    [self.imageView setImage:asset.originImage];
    [self setImageViewPosition]; // 设置图片位置、大小

}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImageViewPosition];
    });
}
- (void)setImageViewPosition {
    
    CGSize size = [self displaySize:_imageView.image];
    
    _imageView.transform = CGAffineTransformIdentity;
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    _scrollView.contentSize = size;
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (size.height < _scrollView.bounds.size.height) {
        
        CGFloat y = (_scrollView.bounds.size.height - size.height) * 0.5;
        
        _scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    }
}
/// 根据视图大小，等比例计算图像缩放大小
///
/// @param image 图像
///
/// @return 缩放后的大小
- (CGSize)displaySize:(UIImage *)image {
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = image.size.height * w / image.size.width;
    
    return CGSizeMake(w, h);
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGFloat offsetY = (_scrollView.bounds.size.height - view.frame.size.height) * 0.5;
    CGFloat offsetX = (_scrollView.bounds.size.width - view.frame.size.width) * 0.5;
    
    offsetY = offsetY < 0 ? 0 : offsetY;
    offsetX = offsetX < 0 ? 0 : offsetX;
    
    _scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0);
}

@end
