//
//  ViewController.m
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import "ViewController.h"
#import "KLTLoadingStateView.h"
#import "KLTLoadingView.h"
@interface ViewController ()<KLTLoadingViewAnimationDelegate>
@property (strong,nonatomic) KLTLoadingStateView *loadingStateView;
@property (strong,nonatomic) KLTLoadingView *loadingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    KLTLoadingStateView *loadingStateView = [[KLTLoadingStateView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    loadingStateView.delegate = self;
    loadingStateView.lineWidth = 5;
    loadingStateView.borderWidth = 3;
    [self.view addSubview:loadingStateView];
    self.loadingStateView = loadingStateView;
    
    KLTLoadingView *loadingView = [[KLTLoadingView alloc] initWithFrame:CGRectMake(100, 150, 100, 100)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doTap:(id)sender {
    [self.loadingStateView start];
    [self.loadingView start];
}

#pragma mark KLTLoadingViewAnimationDelegate
- (void)kltLoadingView:(KLTLoadingStateView *)view animationFinishedWithState:(KLTLoadingStateFlag)state{
    if (state == KLTLoadingStateSuccess) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Note" message:@"successed" preferredStyle:UIAlertControllerStyleAlert];
//        [self showViewController:alert sender:nil];
    }
}
@end
