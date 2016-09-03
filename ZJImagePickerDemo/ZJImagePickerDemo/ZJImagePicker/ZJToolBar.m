//
//  ZJToolBar.m
//  CameraDemo
//
//  Created by 郑佳 on 16/8/25.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import "ZJToolBar.h"
#import "ZJCircleCounterButton.h"

@interface ZJToolBar ()

@property (nonatomic, strong) UIButton *previewBtn; // 预览
@property (nonatomic, strong) UIButton  *doneBtn; // 完成
@property (nonatomic, strong) ZJCircleCounterButton *counterButton;// 计数

@end

@implementation ZJToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    CGFloat rgb = 34 / 255.0;
    self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    
}

#pragma mark - 懒加载
- (UIButton *)previewBtn{
    if (_previewBtn == nil) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _previewBtn;
}


@end
