//
//  ViewController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ViewController.h"
#import "ZJImagePickerController.h"
#import "ZJToolBar.h"

@interface ViewController ()<ZJImagePickerControllerDelegate>

/// 选中资源素材数组，用于定位已经选择的照片
@property (nonatomic) NSArray *selectedAssets;

@end

@implementation ViewController

- (IBAction)btnClick:(id)sender {
    
    // 点击按钮常见一个图片浏览器控制器
    ZJImagePickerController *picker = [[ZJImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
    picker.imagePickerdelegate = self;
    picker.maxPickerCount = 3;
    // 显示控制器
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
// 浏览器的代理方法
- (void)imagePickerController:(ZJImagePickerController *)picker didFinishSelectedImages:(NSArray *)images selectedAssets:(NSArray *)selectedAssets{
    
    NSMutableArray *arrayM  = [selectedAssets mutableCopy];
    [arrayM addObject:@"111"];
    NSLog(@"--✅-%@",images);
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    // 创建一个bar
    ZJToolBar *bar = [ZJToolBar new];
    bar.backgroundColor = [UIColor greenColor];
    bar.frame = CGRectMake(0, 0, 100, 100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
