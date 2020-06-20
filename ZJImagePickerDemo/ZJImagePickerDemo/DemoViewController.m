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
    
    UIView *demoView = [UIView new];
    demoView.frame = CGRectMake(0, 0, 100, 50);
    demoView.backgroundColor = [UIColor yellowColor];
    demoView.alpha = 0.5;
    demoView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:demoView];
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
