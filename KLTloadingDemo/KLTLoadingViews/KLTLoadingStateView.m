//
//  KLTLoadingStateView.m
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import "KLTLoadingStateView.h"
#import "KLTMediaTimingFunctionMgr.h"
static const CGFloat padding = 5.0f;

@interface KLTLoadingStateView (){
    CALayer *_bgShapeLayer;
    CALayer *_borderLayer;
    CALayer *_successLayer;
}
@end

@implementation KLTLoadingStateView

- (void)awakeFromNib{
    [self __initializeSelf];
}
- (instancetype)init{
    if (self = [super init]) {
        [self __initializeSelf];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self __initializeSelf];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder]) && (![aDecoder isKindOfClass:[NSKeyedUnarchiver class]])){
        [self __initializeSelf];
    }
    return self;
}
- (void)__initializeSelf{
    self.state = KLTLoadingStateStart;
    self.borderWidth = 4;
    self.lineWidth = 8;
}

- (void)start{
    self.state = KLTLoadingStateStart;
    [self startAnimationWithState:self.state];
}

- (void)startAnimationWithState:(KLTLoadingStateFlag)state{
    switch (state) {
        case KLTLoadingStateStart:
            [self __satrtAnimation];
            break;
        case KLTLoadingStateLoading:
            [self __loadingAnimation];
            break;
        case KLTLoadingStateSuccess:
            [self __successAnimation];
            break;
        case KLTLoadingStateFailed:
            
            break;
        default:
            break;
    }
}

- (void)__satrtAnimation{
    [_bgShapeLayer removeFromSuperlayer];
    [_borderLayer removeFromSuperlayer];
    [_successLayer removeFromSuperlayer];
 
    CGPoint centerP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0 - padding;
    if (radius<=0) {
        return;
    }
    CAShapeLayer *bgShapeLayer = [CAShapeLayer layer];
    bgShapeLayer.bounds = self.bounds;
    bgShapeLayer.position = centerP;
    bgShapeLayer.lineWidth = self.borderWidth;
    bgShapeLayer.strokeColor = self.bgBorderColor.CGColor;
    bgShapeLayer.fillColor = self.bgBorderColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius startAngle:-M_PI_2 endAngle:M_PI+M_PI_2    clockwise:YES];
    bgShapeLayer.path = path.CGPath;
    [self.layer addSublayer:bgShapeLayer];
    
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    maskShapeLayer.bounds = self.bounds;
    maskShapeLayer.position = centerP;
    maskShapeLayer.lineWidth = self.borderWidth;
    maskShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    path = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius-self.borderWidth/2.0 startAngle:-M_PI_2 endAngle:M_PI+M_PI_2    clockwise:YES];
    maskShapeLayer.path = path.CGPath;
    [bgShapeLayer addSublayer:maskShapeLayer];
    
    __weak typeof(&*self) wSelf = self;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [wSelf __animationFinished];
        wSelf.state = KLTLoadingStateLoading;
        [wSelf startAnimationWithState:KLTLoadingStateLoading];
    }];
    {
        CABasicAnimation * scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        scaleAnim.duration = 0.6;
        scaleAnim.removedOnCompletion = NO;
        scaleAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuintFunction];
        
        CABasicAnimation * opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = @(0);
        opacityAnim.toValue = @(1);
        opacityAnim.duration = 0.4;
        opacityAnim.removedOnCompletion = NO;
        opacityAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuintFunction];
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = @[scaleAnim,opacityAnim];
        animGroup.duration = 0.6;
        [bgShapeLayer addAnimation:animGroup forKey:@"anim"];
    }
    {
        CABasicAnimation * scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        scaleAnim.duration = 0.5;
        scaleAnim.beginTime = [maskShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil] + 0.2;
        scaleAnim.removedOnCompletion = NO;
        scaleAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuintFunction];
        [maskShapeLayer addAnimation:scaleAnim forKey:@"anim"];
    }
    
    [CATransaction commit];
    _bgShapeLayer = bgShapeLayer;
}

- (void)__loadingAnimation{
    [_borderLayer removeFromSuperlayer];
    
    CGPoint centerP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0 - padding;
    if (radius<=0) {
        return;
    }
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.bounds = self.bounds;
    borderShapeLayer.position = centerP;
    borderShapeLayer.lineWidth = self.borderWidth;
    borderShapeLayer.strokeColor = self.successColor.CGColor;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    borderShapeLayer.lineCap = kCALineCapRound;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius startAngle:-M_PI_2 endAngle:M_PI+M_PI_2    clockwise:YES];
    borderShapeLayer.path = path.CGPath;
    borderShapeLayer.strokeStart = 0.0;
    borderShapeLayer.strokeEnd = 0.0;
    [self.layer addSublayer:borderShapeLayer];
    
    __weak typeof(&*self) wSelf = self;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [wSelf __animationFinished];
#ifndef __OPTIMIZE__
        //调试代码
        static int count = 0;
        count ++;
        if (count > 3) {
            wSelf.state = KLTLoadingStateSuccess;
            count = 0;
        }
#endif
        [wSelf startAnimationWithState:wSelf.state];
    }];
    {
        CABasicAnimation * startAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        startAnim.fromValue = @(0);
        startAnim.toValue = @(1);
        startAnim.duration = 0.7;
        startAnim.beginTime = [borderShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil]+0.5;
        startAnim.removedOnCompletion = NO;
        startAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuintFunction];
        
        CABasicAnimation * endAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        endAnim.fromValue = @(0);
        endAnim.toValue = @(1);
        endAnim.duration = 0.7;
        endAnim.beginTime = [borderShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil]+0.3;
        endAnim.removedOnCompletion = NO;
        endAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuintFunction];
        
        [borderShapeLayer addAnimation:startAnim forKey:@"animStart"];
        [borderShapeLayer addAnimation:endAnim forKey:@"animEnd"];
    }
    [CATransaction commit];
    _borderLayer = borderShapeLayer;
}

- (void)__successAnimation{
    [_borderLayer removeFromSuperlayer];
    [_successLayer removeFromSuperlayer];
    
    CGPoint centerP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0 - padding;
    if (radius<=0) {
        return;
    }
    
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.bounds = self.bounds;
    borderShapeLayer.position = centerP;
    borderShapeLayer.lineWidth = self.borderWidth;
    borderShapeLayer.strokeColor = self.successColor.CGColor;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    borderShapeLayer.lineCap = kCALineCapRound;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius startAngle:-M_PI_2 endAngle:M_PI+M_PI_2    clockwise:YES];
    borderShapeLayer.path = path.CGPath;
    borderShapeLayer.strokeStart = 0.0;
    borderShapeLayer.strokeEnd = 0.0;
    [self.layer addSublayer:borderShapeLayer];
    
    CAShapeLayer *successShapeLayer = [CAShapeLayer layer];
    successShapeLayer.bounds = self.bounds;
    successShapeLayer.position = centerP;
    successShapeLayer.lineWidth = self.lineWidth;
    successShapeLayer.strokeColor = self.successColor.CGColor;
    successShapeLayer.fillColor = [UIColor clearColor].CGColor;
    successShapeLayer.lineCap = kCALineCapRound;
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centerP.x-radius/30.0*26, centerP.y-radius/30.0*9)];
    [path addLineToPoint:CGPointMake(centerP.x-radius/30.0*7, centerP.y+radius/30.0*14)];
    [path addLineToPoint:CGPointMake(centerP.x+radius/30.0*18, centerP.y-radius/30.0*12)];
    successShapeLayer.path = path.CGPath;
    successShapeLayer.strokeStart = 0.0;
    successShapeLayer.strokeEnd = 0.0;
    [self.layer addSublayer:successShapeLayer];
    
    __weak typeof(&*self) wSelf = self;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [wSelf __animationFinished];
    }];
    {
        CABasicAnimation * endAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        endAnim.fromValue = @(0);
        endAnim.toValue = @(1);
        endAnim.duration = 0.7;
        endAnim.beginTime = [borderShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil]+0.3;
        endAnim.removedOnCompletion = NO;
        endAnim.fillMode = kCAFillModeForwards;
        endAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuartFunction];
        
        [borderShapeLayer addAnimation:endAnim forKey:@"animEnd"];
    }
    {
        CABasicAnimation * startAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        startAnim.fromValue = @(0);
        startAnim.toValue = @(0.27);
        startAnim.duration = 0.6;
        startAnim.beginTime = [successShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil]+0.8;
        startAnim.removedOnCompletion = NO;
        startAnim.fillMode = kCAFillModeForwards;
        startAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuadFunction];
        
        CABasicAnimation * endAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        endAnim.fromValue = @(0);
        endAnim.toValue = @(0.95);
        endAnim.duration = 0.6;
        endAnim.beginTime = [successShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil]+0.8;
        endAnim.removedOnCompletion = NO;
        endAnim.fillMode = kCAFillModeForwards;
        endAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuadFunction];
        
        [successShapeLayer addAnimation:startAnim forKey:@"animStart"];
        [successShapeLayer addAnimation:endAnim forKey:@"animEnd"];
    }
    [CATransaction commit];
    
    _borderLayer = borderShapeLayer;
    _successLayer = successShapeLayer;
}

- (void)__animationFinished{
    if([self.delegate respondsToSelector:@selector(kltLoadingView:animationFinishedWithState:)]){
        [self.delegate kltLoadingView:self animationFinishedWithState:self.state];
    }
}
#pragma mark Getter
- (UIColor *)bgBorderColor{
    if (_bgBorderColor) {
        return _bgBorderColor;
    }
    _bgBorderColor = [UIColor grayColor];
    return _bgBorderColor;
}
- (UIColor *)successColor{
    if (_successColor) {
        return _successColor;
    }
    _successColor = [UIColor greenColor];
    return _successColor;
}
- (UIColor *)faildColor{
    if (_faildColor) {
        return _faildColor;
    }
    _faildColor = [UIColor redColor];
    return _faildColor;
}

@end
