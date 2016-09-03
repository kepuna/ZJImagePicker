//
//  ZJPreviewViewController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/26.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJPreviewViewController.h"
#import "ZJImageSelectButton.h"
#import "ZJCircleCounterButton.h"
#import "ZJViewerViewController.h"
#import "ZJAlbum.h"


@interface ZJPreviewViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) ZJImageSelectButton *selectedButton;
@property (nonatomic, readonly) NSInteger imagesCount;

@end

@implementation ZJPreviewViewController{

    UIPageViewController        *_pageController;
    
    ZJAlbum                     *_album; //相册模型
    NSMutableArray              *_previewAssets; // 选中图片点击预览后的图片数组
    NSMutableArray              *_selectedIndexes;// 选中素材索引记录数组
    NSInteger                   _maxPickerCount; // 最大选择图像数量
    
    BOOL                        _previewAlbum;// 预览相册
    
    UIView                      *_toolBar;
    ZJCircleCounterButton       *_counterButton;// 选择计数按钮
    UIButton                    *_doneBtn; // 完成按钮
}

- (instancetype)initWithAlbum:(ZJAlbum *)album selectedAssets:(NSMutableArray *)selectedAssets maxPickerCount:(NSInteger)maxPickerCount indexPath:(NSIndexPath *)indexPath{
    
    if (self = [super init]) {
        
        _album = album;
        _previewAssets = selectedAssets.mutableCopy;
        _maxPickerCount = maxPickerCount;
        _previewAlbum = (indexPath != nil);//是否是点击的预览
        
        _selectedIndexes = @[].mutableCopy;// 记录选中素材索引
        if (_previewAlbum) {
            for (NSInteger i = 0; i < album.assetsCount; i++) {
                if ([_previewAssets containsObject:[self assetWithIndex:i]]) {
                    [_selectedIndexes addObject:@(YES)];
                } else {
                    [_selectedIndexes addObject:@(NO)];
                }
            }
        } else {
            for (NSInteger i = 0; i < _previewAssets.count; i++) {
                [_selectedIndexes addObject:@(YES)];
            }
        }
        
        NSInteger index = (indexPath != nil) ? indexPath.item : 0;
        [self prepareChildControllersWithIndex:index];
    }
    return self;
}

- (ZJViewerViewController *)viewerControllerWithIndex:(NSInteger)index {
    
    ZJViewerViewController *viewer = [[ZJViewerViewController alloc] init];
    viewer.index = index;
    viewer.asset = [self assetWithIndex:index];//根据index获取到图片
    
    return viewer;
}

#pragma mark - 准备子控制器
- (void)prepareChildControllersWithIndex:(NSInteger)index {
    
    // UIPageViewControllerOptionInterPageSpacingKey:表示的是上一页与下一页的间距
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @(20)};
    // 实例化分页控制器 - 水平分页滚动
    _pageController = [[UIPageViewController alloc]
                       initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                       options:options];
    
    NSArray *viewControllers = @[[self viewerControllerWithIndex:index]];
    self.selectedButton.selected = [_selectedIndexes[index] boolValue];
    
    // 添加分页控制器的子视图控制器数组
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    
    /**
     当从一个视图控制容器中添加或者移除viewController后，该方法被调用。
     
     parent：父视图控制器，如果没有父视图控制器，将为nil

     当我们向我们的视图控制器容器（就是父视图控制器，它调用addChildViewController方法加入子视图控制器，它就成为了视图控制器的容器）中添加（或者删除）子视图控制器后，必须调用该方法，告诉iOS，已经完成添加（或删除）子控制器的操作
     */
    [_pageController didMoveToParentViewController:self];
    self.view.gestureRecognizers = _pageController.gestureRecognizers;
    
    _pageController.dataSource = self;
    _pageController.delegate = self;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    ZJViewerViewController *viewer = (ZJViewerViewController *)pendingViewControllers.lastObject;
    
    self.selectedButton.selected = [_selectedIndexes[viewer.index] boolValue];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray*)previousViewControllers transitionCompleted:(BOOL)completed {
    
    ZJViewerViewController *viewer = _pageController.viewControllers.lastObject;
    
    self.selectedButton.selected = [_selectedIndexes[viewer.index] boolValue];
}

#pragma mark - UIPageViewControllerDataSource 
/// 返回前一页控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return [self viewerControllerWithViewController:viewController isNext:NO];
}

/// 返回下一页控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return [self viewerControllerWithViewController:viewController isNext:YES];
}
- (UIViewController *)viewerControllerWithViewController:(UIViewController *)viewController isNext:(BOOL)isNext {
    
    ZJViewerViewController *viewerVC = (ZJViewerViewController *)viewController;
    NSInteger index = viewerVC.index;
    
    index += isNext ? 1 : -1;
    
    if (index < 0 || index >= self.imagesCount) {
        return nil;
    }
    
    return [self viewerControllerWithIndex:index];
}

- (NSInteger)imagesCount {
    if (_previewAlbum) {
        return _album.assetsCount;
    } else {
        return _previewAssets.count;
    }
}

- (ZJAsset *)assetWithIndex:(NSInteger)index{
    if (_previewAlbum) {
        
        return [_album assetWithIndex:index];
       
    } else {
        return _previewAssets[index];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupToolBar];
    
}
- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectedButton];
}
- (void)setupToolBar{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    [_pageController.view addSubview:_toolBar];
   
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(self.view.frame.size.width - 44 - 12, 0, 44, 44);
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [_doneBtn setTitleColor:[UIColor colorWithRed:(9/255.0) green:(187/255.0) blue:(7/255.0) alpha:1.0] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor colorWithRed:(9/255.0) green:(187/255.0) blue:(7/255.0) alpha:0.4] forState:UIControlStateDisabled];
    
    _counterButton = [[ZJCircleCounterButton alloc] init];
    _counterButton.center = CGPointMake(_doneBtn.center.x - (_doneBtn.frame.size.width * 0.7), _doneBtn.center.y);
    
    _counterButton.count = _previewAssets.count;
    
    
    [_toolBar addSubview:_doneBtn];
    [_toolBar addSubview:_counterButton];
    
}

#pragma mark - 点击发送
//如果没有选中照片，返回当前预览的照片
- (void)doneBtnClick{
    
    NSMutableArray *selectedAssets = [self.delegate previewViewControllerSelectedAssets];
    
    // 判断选中资源数组是否有内容，如果没有，将当前显示的照片添加到选中资源数组中
    if (selectedAssets.count == 0) {
        ZJViewerViewController *viewer = _pageController.viewControllers.lastObject;
        [selectedAssets addObject:[self assetWithIndex:viewer.index]];
    }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ZJImagesSelectedDoneNotification" object:nil userInfo:@{@"ZJSelectedAssetsKey" :selectedAssets}];
}

#pragma mark - 懒加载
- (UIButton *)selectedButton{
    if (_selectedButton == nil) {
        _selectedButton = [[ZJImageSelectButton alloc]
                           initWithImageName:@"imagePicker_normal"
                           selectedName:@"imagePicker_selected"];
        [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
    
}

- (void)selectedButtonClick:(UIButton *)sender{
    
    ZJViewerViewController *viewer = _pageController.viewControllers.lastObject;
    
    if ([self.delegate previewViewController:self didChangedAsset:[self assetWithIndex:viewer.index] selected:sender.selected]) {
        _selectedIndexes[viewer.index] = @(sender.selected);
    } else {
        sender.selected = !sender.selected;
    }
    
    _counterButton.count = [_selectedIndexes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == 1"]].count;
}

@end
