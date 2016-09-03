//
//  ZJCircleCounterButton.m
//  CameraDemo
//
//  Created by 郑佳 on 16/8/25.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import "ZJCircleCounterButton.h"


@implementation ZJCircleCounterButton

#pragma mark - 设置数据
- (void)setCount:(NSInteger)count {
    _count = count;
    
    self.hidden = !(count > 0);
    [self setTitle:[NSString stringWithFormat:@"%zd", count] forState:UIControlStateNormal];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.7;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [self.layer addAnimation:animation forKey:nil];
    
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"ZJImage.bundle" withExtension:nil];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        UIImage *image = [UIImage imageNamed:@"number_icon"
                                    inBundle:imageBundle
               compatibleWithTraitCollection:nil];
        
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setTitle:@"0" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.hidden = YES;
        [self sizeToFit];
        
    }
    return self;
}

@end

