//
//  ZJImageGridCell.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJImageGridCell.h"
#import "ZJImageSelectButton.h"

//################### ZJImageGridCell ####################
@implementation ZJImageGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 点击选择按钮
- (void)selectedButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(imageGridCell:didSelected:)]) {
        
        [self.delegate imageGridCell:self didSelected:_selectedButton.selected];
    }
}

#pragma mark - 懒加载
- (UIButton *)selectedButton{
    if (_selectedButton == nil) {
        
        CGFloat picViewSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
        CGFloat btnSize = picViewSize / 3;
        
        _selectedButton = [[ZJImageSelectButton alloc]
                           initWithImageName:@"imagePicker_normal"
                           selectedName:@"imagePicker_selected"];
        _selectedButton.frame = CGRectMake(picViewSize - btnSize,0, btnSize, btnSize);
         [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectedButton;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
