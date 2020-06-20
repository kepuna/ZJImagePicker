//
//  DemoViewController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 2020/6/20.
//  Copyright © 2020 Triangle. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置背景颜色
    self.view.backgroundColor  = [UIColor greenColor];
    self.view.alpha = 0.8;
    self.view.bounds = CGRectMake(0, 0, 50, 50);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
