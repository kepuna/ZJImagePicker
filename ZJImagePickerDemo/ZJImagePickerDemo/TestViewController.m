//
//  TestViewController.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 2020/6/20.
//  Copyright © 2020 Triangle. All rights reserved.
// 测试控制器

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *testView = [UIView new];
    testView.frame = CGRectMake(0, 0, 100, 50);
    testView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:testView];
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
