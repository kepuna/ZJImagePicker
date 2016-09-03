//
//  ZJImagePickerController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJImageGridViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZJAlbum.h"
#import "ZJImageGridCell.h"
#import "ZJImageSelectButton.h"
#import "ZJCircleCounterButton.h"
#import "ZJPreviewViewController.h"
#import "ZJAssetsLibraryManager.h"


@interface ImagePickerFlowlayout : UICollectionViewFlowLayout

@end

@implementation ImagePickerFlowlayout

- (void)prepareLayout{
    
    [super prepareLayout];
    
    CGFloat margin = 1.5;
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3 * margin) / 4;
    self.minimumInteritemSpacing = margin;//行间距
    self.minimumLineSpacing = margin;//列间距
    self.itemSize = (CGSize){photoSize,photoSize};
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
}

@end

//########################## ZJImageGridViewController ##########################
@interface ZJImageGridViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZJImageGridCellDelegate,ZJPreviewViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZJImageGridViewController{
    
    NSMutableArray  *_selectedAssets; // 被选中的图片 数组
    NSMutableArray  *_assets; // 相册下的相片数组
    NSInteger       _maxPickerCount; //最多可选张数

    UIView       *_toolBar;
    UIButton *_previewBtn;// 预览按钮
    UIButton *_doneBtn;// 完成按钮
    ZJCircleCounterButton *_counterButton;// 完成按钮前圆形计数按钮
    
    ZJAlbum         *_album; // 相册模型
    
}

#pragma mark - 初始化方法
- (instancetype)initWithAlbum:(ZJAlbum *)album maxPickerCount:(NSInteger)maxPickerCount{

    if (self = [super init]) {
        _album = album;
        _selectedAssets = @[].mutableCopy;
        _maxPickerCount = maxPickerCount;
        _assets = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupUI];
    [self setupAssets];
}

//初始化相册下相片
- (void)setupAssets{

    __block NSMutableArray *tempArray = @[].mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[ZJAssetsLibraryManager manager] getAssetWithAlbum:_album finished:^(NSArray *assets) {
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                ZJAsset *zjAsset = [[ZJAsset alloc]init];
                zjAsset.asset = asset;
                zjAsset.isSelected = NO;
                [tempArray addObject:zjAsset];
            }];
        }];
        
        _assets = tempArray;
        _album.assets = tempArray.copy; //相册下的图片数组
        [_collectionView reloadData];

    });
    
}


- (void)setupNav{
    
    self.title = _album.albumName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClick)];
}
- (void)cancleBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI{
    
    [self collectionView];
    [self setupToolBar];

}
- (void)setupToolBar{

    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    CGFloat rgb = 250 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];

    [self.view addSubview:_toolBar];
    
    
    _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewBtn.frame = CGRectMake(10, 0, 44, 44);
    _previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewBtn addTarget:self action:@selector(previewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [_previewBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    
    UIView *lineView = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    lineView.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    lineView.frame = CGRectMake(0, 0, self.view.frame.size.width,0.5);
    
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(self.view.frame.size.width - 44 - 12, 0, 44, 44);
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneBtn setTitle:@"发送" forState:UIControlStateNormal];
  
    [_doneBtn setTitleColor:[UIColor colorWithRed:(9/255.0) green:(187/255.0) blue:(7/255.0) alpha:1.0] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor colorWithRed:(9/255.0) green:(187/255.0) blue:(7/255.0) alpha:0.4] forState:UIControlStateDisabled];
    
    _counterButton = [[ZJCircleCounterButton alloc] init];
    _counterButton.center = CGPointMake(_doneBtn.center.x - (_doneBtn.frame.size.width * 0.7), _doneBtn.center.y);
    

    [_toolBar addSubview:lineView];
    [_toolBar addSubview:_previewBtn];
    [_toolBar addSubview:_doneBtn];
    [_toolBar addSubview:_counterButton];
    
     _previewBtn.enabled = _doneBtn.enabled = NO;
    
}
#pragma mark - 点击预览、完成
- (void)previewBtnClick{

    [self showPreviewControllerWithIndexPath:nil];
}
- (void)doneBtnClick{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZJImagesSelectedDoneNotification" object:nil userInfo:@{@"ZJSelectedAssetsKey" :_selectedAssets}];

}
- (void)updateCounter{
    // 更新计数
    _counterButton.count = _selectedAssets.count;
    // 更新 预览、完成按钮的状态
    _previewBtn.enabled = _doneBtn.enabled = (_selectedAssets.count > 0);
    
}

#pragma mark - 懒加载
static NSString * const reuseIdentifier = @"ImagePickerCollectionViewCell";
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[ImagePickerFlowlayout alloc]init]];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZJImageGridCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
        
        NSString *widthVfl = @"H:|-0-[_collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
        
        NSString *heightVfl = @"V:|-0-[_collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
    }
    return _collectionView;
}

#pragma mark - ZJImageGridCellDelegate 点击选中按钮时触发
- (void)imageGridCell:(ZJImageGridCell *)cell didSelected:(BOOL)selected{
    
    if (_selectedAssets.count == _maxPickerCount && selected) {
        NSString *message = [NSString stringWithFormat:@"最多可以选择 %zd 张照片", _maxPickerCount];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        
        cell.selectedButton.selected = NO;
        
        return;
    }
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ZJAsset *asset =  _assets[indexPath.item];
    if (selected) {
        //修改ZJAsset是否选中的状态，防止重用
        asset.isSelected = YES;
        [_selectedAssets addObject:asset];
        
    } else {
        asset.isSelected = NO;
        [_selectedAssets removeObject:asset];
    }
    [self updateCounter];
}


#pragma mark - delegate & datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJAsset *asset = _assets[indexPath.item];
    ZJImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = asset.thumbImage;
    cell.delegate = self;
    cell.selectedButton.selected = asset.isSelected;//设置选中状态，防止重用
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showPreviewControllerWithIndexPath:indexPath];
}

- (void)showPreviewControllerWithIndexPath:(NSIndexPath *)indexPath {
    
    ZJPreviewViewController *previewVC = [[ZJPreviewViewController alloc]
                                        initWithAlbum:_album
                                        selectedAssets:_selectedAssets
                                        maxPickerCount:_maxPickerCount
                                        indexPath:indexPath];
    
    previewVC.delegate = self;
    
    [self.navigationController pushViewController:previewVC animated:YES];
}

#pragma mark - ZJPreviewViewControllerDelegate
- (BOOL)previewViewController:(ZJPreviewViewController *)previewViewController didChangedAsset:(ZJAsset *)asset selected:(BOOL)selected {
    
    // 更新选中素材数组
    if (selected) {
        if (_selectedAssets.count == _maxPickerCount) {
            NSString *message = [NSString stringWithFormat:@"最多只能选择 %zd 张照片", _maxPickerCount];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return NO;
        }
        [_selectedAssets addObject:asset];
    } else {
        [_selectedAssets removeObject:asset];
    }
    [self updateCounter];
    
    // 根据 asset 查找索引
    NSInteger index = [_album indexWithAsset:asset];
    if (index == NSNotFound) {
        NSLog(@"没有在当前相册找到素材");
        return YES;
    }
    
    // 更新 Cell 显示
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];

    ZJImageGridCell *cell = (ZJImageGridCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedButton.selected = selected;
    
    return YES;
}


- (NSMutableArray *)previewViewControllerSelectedAssets {
    return _selectedAssets;
}



- (void)dealloc{
    [_selectedAssets removeAllObjects]; // 归零
    NSLog(@"%s销毁了",__func__);
}


@end
