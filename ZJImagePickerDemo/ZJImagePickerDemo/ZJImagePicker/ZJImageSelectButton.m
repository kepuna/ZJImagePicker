//
//  ZJImageSelectButton.m
//  CameraDemo
//
//  Created by 郑佳 on 16/8/25.
//  Copyright © 2016年 Triangle. All rights reserved.
//

#import "ZJImageSelectButton.h"


@implementation ZJImageSelectButton

- (instancetype)initWithImageName:(NSString *)imageName selectedName:(NSString *)selectedName {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"ZJImage.bundle" withExtension:nil];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        UIImage *normalImage = [UIImage imageNamed:imageName
                                          inBundle:imageBundle
                     compatibleWithTraitCollection:nil];
        [self setImage:normalImage forState:UIControlStateNormal];
        UIImage *selectedImage = [UIImage imageNamed:selectedName
                                            inBundle:imageBundle
                       compatibleWithTraitCollection:nil];
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self sizeToFit];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.selected = !self.selected;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    // touch的时候，判断touch的这个按钮是否添加了addTarget方法,如果有就执行addTarget的方法
    id target = self.allTargets.anyObject;
    NSString *actionString = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].lastObject;
    if (actionString != nil) {
        [self sendAction:NSSelectorFromString(actionString) to:target forEvent:event];
    }
    
}

@end

