//
//  ZJAlumTableViewController.m
//  CameraDemo
//
//  Created by 郑佳 on 16/8/17.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import "ZJAlbumTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZJImageGridViewController.h"
#import "ZJAlbum.h"
#import "ZJAssetsLibraryManager.h"

static NSString *Tip_ALAuthorization = @"您没有权限访问相册，开启请去系统设置->隐私->我的App来打开权限";
static NSString *const ZJAlbumTableViewCellIdentifier = @"ZJAlbumTableViewCellIdentifier";

//################### 相册列表对应cell####################
@interface ZJAlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;//封面图
@property (nonatomic, strong) UILabel *albumNameLabel;//相册名
@property (nonatomic, strong) UILabel *assetCountLabel;//相册下图片个数
@property (nonatomic, strong) ZJAlbum *album;

@end

@implementation ZJAlbumTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.albumNameLabel];
        [self.contentView addSubview:self.assetCountLabel];
        
    }
    return self;
}
#pragma mark - 懒加载
- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.frame = CGRectMake(0, 0,60,60);
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)albumNameLabel{
    if (!_albumNameLabel) {
        _albumNameLabel = [[UILabel alloc] init];
        _albumNameLabel.frame = CGRectMake(75, 15, self.frame.size.width - 100, 20);
        
    }
    return _albumNameLabel;
}

- (UILabel *)assetCountLabel{
    if (!_assetCountLabel) {
        _assetCountLabel = [[UILabel alloc] init];
        _assetCountLabel.font = [UIFont systemFontOfSize:13];
        _assetCountLabel.textColor = [UIColor lightGrayColor];
        _assetCountLabel.frame = CGRectMake(95, 40, self.frame.size.width - 100, 20);
        
    }
    return _assetCountLabel;
}

- (void)setAlbum:(ZJAlbum *)album{
    _album = album;
    _albumNameLabel.text = album.albumName;
    _coverImageView.image = album.coverThumbImage;
    _assetCountLabel.text = [NSString stringWithFormat:@"(%zd)",album.assetsCount];
}

@end

//################### ZJAlbumTableViewController ####################
@implementation ZJAlbumTableViewController{
    
    NSArray             *_albumList; // 相册列表数组
    NSMutableArray      *_selectedAssets; // 选择的图片的数组
    UIActivityIndicatorView *_indicator; // 指示器
}

- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets{
    if (self = [super init]) {
        _selectedAssets = selectedAssets;
        _albumList = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    [self setupNav];
    [self setupAlbum];
    [self setTableViewStyle];
}
- (void)setTableViewStyle{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[ZJAlbumTableViewCell class] forCellReuseIdentifier:ZJAlbumTableViewCellIdentifier];
}

- (void)setupAlbum{
    
    // 判断是否有权限访问相册列表
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:Tip_ALAuthorization delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        
        return;
    }else{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[ZJAssetsLibraryManager manager] getAlbumList:^(NSArray *albumList) {
                
                //回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 默认显示第一个相册
                    [_indicator removeFromSuperview];
                    
                    if (albumList.count > 0) {
                        _albumList = [[albumList reverseObjectEnumerator] allObjects];
                        ZJImageGridViewController *grid = [[ZJImageGridViewController alloc] initWithAlbum:_albumList[0] maxPickerCount:_maxPickerCount];
                    
                        [self.navigationController pushViewController:grid animated:NO];
                        [self.tableView reloadData];
                    }
                    
                    
                });
            }];
            
        });
    }
}


- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClick)];
}
- (void)cancleBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZJAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZJAlbumTableViewCellIdentifier];
    cell.album = _albumList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJAlbum *album = _albumList[indexPath.row];
    ZJImageGridViewController *gridVC = [[ZJImageGridViewController alloc] initWithAlbum:album maxPickerCount:_maxPickerCount];
    [self.navigationController pushViewController:gridVC animated:YES];
}
@end
