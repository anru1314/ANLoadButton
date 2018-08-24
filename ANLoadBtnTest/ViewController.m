//
//  ViewController.m
//  ANLoadBtnTest
//
//  Created by AnRu on 2018/8/24.
//  Copyright © 2018年 Anrue. All rights reserved.
//

#import "ViewController.h"
#import "ANLoadButton.h"

@interface ViewController ()
@property (nonatomic, weak) ANLoadButton *loadBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ANLoadButton *btn = [[ANLoadButton alloc] initWithFrame:CGRectMake(150, 200, 150, 44)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor purpleColor];
    btn.textColor = [UIColor whiteColor];
    self.loadBtn = btn;
    [btn setText:@"立即加载"];
}

- (IBAction)successBtnClick:(id)sender {
    [self.loadBtn show:ANLoadSuccess];
}
- (IBAction)errorBtnClick:(id)sender {
    [self.loadBtn show:ANLoadError];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
