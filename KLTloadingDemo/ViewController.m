//
//  ViewController.m
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import "ViewController.h"
#import "KLTLoadingViews.h"
@interface ViewController ()<KLTLoadingViewAnimationDelegate>{
    dispatch_source_t _timer;
}
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
    
    KLTLoadingViewPTC *loadingViewPTC = [[KLTLoadingViewPTC alloc] initWithFrame:CGRectMake(100, 200, 16, 16)];
    [self.view addSubview:loadingViewPTC];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [loadingViewPTC setProgress:1 animated:YES];
//    });
    
   
    __block CGFloat i = 0;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0),0.2 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        [loadingViewPTC setProgress:i animated:YES];
        i += 0.1;
        if (i>=1.0f) {
            i = 0;
            [loadingViewPTC startIndeterminateAnimation];
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
    _timer = timer;

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
