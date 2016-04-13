//
//  KLTLoadingViewPTC.h
//  KLTloadingDemo
//
//  Created by 田凯 on 16/4/8.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLTLoadingViewPTC : UIControl

/*
 @brief 完成度百分比,0~1之间的值
 */
@property (nonatomic) float progress;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, strong) UIColor *progressTintColor;
/*
 @brief 圆点最大半径
 */
@property (nonatomic, assign) CGFloat pointRadiu_Big;
/*
 @brief 圆点最大小径
 */
@property (nonatomic, assign) CGFloat pointRadiu_Small;
/*
 @brief 圆点间反弹的最远距离
 */
@property (nonatomic, assign) CGFloat distance_Farther;
/*
 @brief 圆点间的远距离
 */
@property (nonatomic, assign) CGFloat distance_Far;
/*
 @brief 圆点间开始动画的距离
 */
@property (nonatomic, assign) CGFloat distance_Start;
/*
 @brief 圆点间在loading时动画的最小距离
 */
@property (nonatomic, assign) CGFloat distance_Mid;
/*
 @brief 圆点间拖动时的最小距离
 */
@property (nonatomic, assign) CGFloat distance_End;

- (void)setProgress:(float)progress animated:(BOOL)animated;

- (void)startIndeterminateAnimation;

- (void)stopIndeterminateAnimation;

- (void)stopIndeterminateAnimationWithCallBack:(void(^)())callback;

- (void)stopIndeterminateAnimationImmediately;

@end