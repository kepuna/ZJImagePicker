//
//  ViewController.m
//  CameraDemo
//
//  Created by 郑佳 on 16/8/15.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import "ViewController.h"
#import "ZJImagePickerController.h"

@interface ViewController ()<ZJImagePickerControllerDelegate>

/// 选中资源素材数组，用于定位已经选择的照片
@property (nonatomic) NSArray *selectedAssets;

@end

@implementation ViewController

- (IBAction)btnClick:(id)sender {
    
    
    ZJImagePickerController *picker = [[ZJImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
    picker.imagePickerdelegate = self;
    picker.maxPickerCount = 3;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(ZJImagePickerController *)picker didFinishSelectedImages:(NSArray *)images selectedAssets:(NSArray *)selectedAssets{
    
    NSLog(@"---%@",images);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
