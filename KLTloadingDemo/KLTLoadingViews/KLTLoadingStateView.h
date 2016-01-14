//
//  KLTLoadingStateView.h
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KLTLoadingStateStart = 3,
    KLTLoadingStateLoading = 2,
    KLTLoadingStateSuccess = 1,
    KLTLoadingStateFailed = 0
} KLTLoadingStateFlag;

@class KLTLoadingStateView;
@protocol KLTLoadingViewAnimationDelegate <NSObject>
@optional
- (void)kltLoadingView:(KLTLoadingStateView *)view animationStartedWithState:(KLTLoadingStateFlag)state;
- (void)kltLoadingView:(KLTLoadingStateView *)view animationFinishedWithState:(KLTLoadingStateFlag)state;
@end

@interface KLTLoadingStateView : UIView

@property (weak,nonatomic) id<KLTLoadingViewAnimationDelegate> delegate;
/*
 @brief 状态标示
 @see KLTLoadingStateFlag
 */
@property (assign,nonatomic) KLTLoadingStateFlag state;
/*
 @brief 背景圈的颜色
 */
@property (strong,nonatomic) UIColor * bgBorderColor;
/*
 @brief 成功圈的颜色
 */
@property (strong,nonatomic) UIColor * successColor;
/*
 @brief 失败圈的颜色
 */
@property (strong,nonatomic) UIColor * faildColor;
/*
 @brief 圈的border宽度
 */
@property (assign,nonatomic) CGFloat borderWidth;
/*
 @brief 勾的线宽
 */
@property (assign,nonatomic) CGFloat lineWidth;
/*
 @brief 开始动画
 */
- (void)start;
/*
 @brief 开始指定状态动画
 */
- (void)startAnimationWithState:(KLTLoadingStateFlag)state;
/*
 @brief 停止动画
 */
- (void)stop;
@end
