//
//  KLTLoadingView.h
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLTLoadingView : UIView
/*
 @brief 线宽
 */
@property (assign,nonatomic) CGFloat lineWidth;
/*
 @brief 颜色
 */
@property (strong,nonatomic) UIColor * lineColor;
/*
 @brief 开始动画
 */
- (void)start;
@end
