//
//  KLTLoadingViewPTC.m
//  KLTloadingDemo
//
//  Created by 田凯 on 16/4/8.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "KLTLoadingViewPTC.h"
#import "KLTMediaTimingFunctionMgr.h"

NSString * const kProgressAnimation = @"kProgressAnimation";
NSString * const kIndeterminateAnimation = @"IndeterminateAnimation";

@interface KLTLoadingViewPTC ()
/*
 @brief 停止动画标记
 */
@property (nonatomic, assign) BOOL shouldStopAnimation;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *shapeLayers;
@property (nonatomic, strong) void(^endCallback)();

@end

@implementation KLTLoadingViewPTC {
    UIColor *_progressTintColor;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 16, 16)];
    
    if (self) {
        [self __initializeSelf];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initializeSelf];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        [self __initializeSelf];
    }
    
    return self;
}

- (void)__initializeSelf
{
    _progressTintColor = [UIColor blackColor];
    _pointRadiu_Big = 3/2.0;
    _pointRadiu_Small = 1/2.0;
    
    _distance_Farther = 23;
    _distance_Far = 21;
    _distance_Start = 10;
    _distance_Mid = 5;
    _distance_End = 3;
    
    // Set up the shape layer
    _shapeLayers = [NSMutableArray arrayWithCapacity:4];
    for (NSUInteger i=0; i<4; i++) {
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = self.bounds;
        shapeLayer.fillColor = self.progressTintColor.CGColor;
        shapeLayer.strokeColor = self.progressTintColor.CGColor;
        UIBezierPath *path = [self __getProgressPathForIdx:i withProgress:0];
        shapeLayer.path = path.CGPath;
        [self.layer addSublayer:shapeLayer];
        [_shapeLayers addObject:shapeLayer];
    }
    self.layer.opacity = 0;
}

- (UIBezierPath *)__getProgressPathForIdx:(NSUInteger)idx withProgress:(CGFloat)progress{
    return [UIBezierPath bezierPathWithArcCenter:[self __getProgressPostionForIdx:idx withProgress:progress] radius:self.pointRadiu_Big startAngle:M_PI endAngle:-M_PI clockwise:NO];
}
- (UIBezierPath *)__getIndeterminatePathForIdx:(NSUInteger)idx withProgress:(CGFloat)progress{
    return [UIBezierPath bezierPathWithArcCenter:[self __getIndeterminatePostionForIdx:idx withProgress:progress] radius:[self __getIndeterminateRadius:progress] startAngle:M_PI endAngle:-M_PI clockwise:NO];
}
- (UIBezierPath *)__getIndeterminatePathForIdx:(NSUInteger)idx maxRadius:(CGFloat)maxRadius withProgress:(CGFloat)progress{
    return [UIBezierPath bezierPathWithArcCenter:[self __getIndeterminatePostionForIdx:idx maxDistance:maxRadius withProgress:progress] radius:[self __getIndeterminateRadius:progress] startAngle:M_PI endAngle:-M_PI clockwise:NO];
}
- (UIBezierPath *)__getIndeterminatePathLineForIdx:(NSUInteger)idx withProgress:(CGFloat)progress{
    CGFloat space = M_PI_2*0.1;
    return [self __getIndeterminatePathLineForIdx:idx space:space andProgress:progress];
}
- (UIBezierPath *)__getIndeterminatePathLineForIdx:(NSUInteger)idx space:(CGFloat)space andProgress:(CGFloat)progress{
    if (space*2>M_PI_2) {
        space = M_PI_2*0.499;
    }else if(space<0){
        space = M_PI_2*0.1;
    }
    CGFloat bigRadius = (self.distance_Far - (self.distance_Far - self.distance_Mid)*progress)/2.0;
    CGFloat radiusDelta = _pointRadiu_Small + (_pointRadiu_Big-_pointRadiu_Small)*progress;
    CGFloat controlAngel = asin((radiusDelta/2)/(bigRadius-radiusDelta))*2;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:[self __getPointForAngel:idx*M_PI_2-M_PI_4+space withDistance:bigRadius]];
    [bezierPath addQuadCurveToPoint:[self __getPointForAngel:(idx+1)*M_PI_2-M_PI_4-space withDistance:bigRadius] controlPoint:[self __getPointForAngel:idx*M_PI_2-M_PI_4+M_PI_2/2.0 withDistance:bigRadius/cos(M_PI_2/2-space)]];
//    [bezierPath addLineToPoint:[self __getPointForAngel:(idx+1)*M_PI_2-space withDistance:bigRadius-radiusDelta]];
    [bezierPath addQuadCurveToPoint:[self __getPointForAngel:(idx+1)*M_PI_2-M_PI_4-space withDistance:bigRadius-radiusDelta] controlPoint:[self __getPointForAngel:(idx+1)*M_PI_2-M_PI_4-space+controlAngel withDistance:bigRadius-radiusDelta/2.0]];
    [bezierPath addQuadCurveToPoint:[self __getPointForAngel:idx*M_PI_2-M_PI_4+space withDistance:bigRadius-radiusDelta] controlPoint:[self __getPointForAngel:idx*M_PI_2-M_PI_4+M_PI_2/2.0 withDistance:(bigRadius-radiusDelta)/cos(M_PI_2/2-space)]];
    [bezierPath addQuadCurveToPoint:[self __getPointForAngel:idx*M_PI_2-M_PI_4+space withDistance:bigRadius] controlPoint:[self __getPointForAngel:idx*M_PI_2-M_PI_4+space-controlAngel withDistance:bigRadius-radiusDelta/2.0]];
//    [bezierPath addLineToPoint:[self __getPointForAngel:idx*M_PI_2+space withDistance:bigRadius]];
    return bezierPath;
}
- (CGPoint)__getProgressPostionForIdx:(NSUInteger)idx withProgress:(CGFloat)progress{
    CGFloat currentRadius = (self.distance_Start - (self.distance_Start - self.distance_End)*progress)/2.0;
    return [self __getPointForAngel:idx*M_PI_2 withDistance:currentRadius];
}
- (CGPoint)__getIndeterminatePostionForIdx:(NSUInteger)idx withProgress:(CGFloat)progress{
    CGFloat currentRadius = (self.distance_Far - (self.distance_Far - self.distance_Mid)*progress)/2.0;
    return [self __getPointForAngel:idx*M_PI_2 withDistance:currentRadius];
}
- (CGPoint)__getIndeterminatePostionForIdx:(NSUInteger)idx maxDistance:(CGFloat)maxRadius withProgress:(CGFloat)progress{
    CGFloat currentRadius =  (maxRadius- (maxRadius - self.distance_Mid)*progress)/2.0;
    return [self __getPointForAngel:idx*M_PI_2 withDistance:currentRadius];
}
- (CGPoint)__getPointForAngel:(CGFloat)angel withDistance:(CGFloat)radius{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint pointP = CGPointMake(-radius*cosf(angel)+center.x, -radius*sinf(angel)+center.y);
    return pointP;
}
- (CGFloat)__getIndeterminateRadius:(CGFloat)progress{
    return (self.pointRadiu_Small + (self.pointRadiu_Big - self.pointRadiu_Small)*progress);
}
#pragma mark - Accessors

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    static CGFloat step1 = 10.0/14.0;
    static CGFloat duration = 0.1f;
    
    if (_isAnimating) {
        return;
    }
    
    if (progress <=0) {
        progress = 0;
    }else if (progress>=1){
        progress = 1;
    }
    _progress = progress;
    
    if (progress > 0) {
        if (animated) {
            [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CAShapeLayer *presentationLayer = obj.presentationLayer?obj.presentationLayer:obj;
                UIBezierPath *dPath = [self __getProgressPathForIdx:idx withProgress:progress];
                CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
                pathAnim.fromValue = (__bridge id)(presentationLayer.path);
                pathAnim.toValue = dPath;
                pathAnim.duration = duration;
                
                obj.path = dPath.CGPath;
                [obj addAnimation:pathAnim forKey:kProgressAnimation];
            }];
            
            if (progress <= step1) {
                CGFloat step1Progress = progress/step1;
               
                CALayer *presentationLayer =  self.layer.presentationLayer?self.layer.presentationLayer:self.layer;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                animation.fromValue = @(presentationLayer.opacity);
                animation.toValue = [NSNumber numberWithFloat:step1Progress];
                
                CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
                rotateAnim.fromValue = [NSValue valueWithCATransform3D:presentationLayer.transform];
                rotateAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*step1Progress, 0, 0, 1)];
                
                CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
                groupAnim.animations = @[animation,rotateAnim];
                groupAnim.duration = duration;
                
                self.layer.opacity = step1Progress;
                self.layer.transform = CATransform3DMakeRotation(M_PI*step1Progress, 0, 0, 1);
                
                [self.layer addAnimation:groupAnim forKey:kProgressAnimation];
            }else{
                CALayer *presentationLayer =  self.layer.presentationLayer?self.layer.presentationLayer:self.layer;
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                animation.fromValue = @(presentationLayer.opacity);
                animation.toValue = [NSNumber numberWithFloat:1.0];
                
                CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
                rotateAnim.fromValue = [NSValue valueWithCATransform3D:presentationLayer.transform];
                rotateAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*1.0, 0, 0, 1)];
                
                CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
                groupAnim.animations = @[animation,rotateAnim];
                groupAnim.duration = duration;

                self.layer.opacity = 1.0;
                self.layer.transform = CATransform3DMakeRotation(M_PI*1, 0, 0, 1);
                
                [self.layer addAnimation:groupAnim forKey:kProgressAnimation];
            }
        }else{
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            if (progress <= step1) {
                CGFloat step1Progress = progress/step1;
                self.layer.opacity = step1Progress;
                self.layer.transform = CATransform3DMakeRotation(M_PI*step1Progress, 0, 0, 1);
            }else{
                self.layer.opacity = 1.0;
                self.layer.transform = CATransform3DMakeRotation(M_PI*1, 0, 0, 1);
            }
            [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIBezierPath *dPath = [self __getProgressPathForIdx:idx withProgress:progress];
                obj.path = dPath.CGPath;
            }];
            [CATransaction commit];
        }
        
    } else {
        [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeAllAnimations];
            UIBezierPath *dPath = [self __getProgressPathForIdx:idx withProgress:progress];
            obj.path = dPath.CGPath;
        }];
        [self.layer removeAnimationForKey:kProgressAnimation];
        self.layer.opacity = 0.0;
        self.layer.transform = CATransform3DIdentity;
    }
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if ([self respondsToSelector:@selector(setTintColor:)]) {
        self.tintColor = progressTintColor;
    } else {
        _progressTintColor = progressTintColor;
        [self tintColorDidChange];
    }
}

- (UIColor *)progressTintColor
{
    if ([self respondsToSelector:@selector(tintColor)]) {
        return self.tintColor;
    } else {
        return _progressTintColor;
    }
}

#pragma mark - UIControl overrides

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // Ignore touches that occur before progress initiates
    
    if (self.progress > 0) {
        [super sendAction:action to:target forEvent:event];
    }
}

#pragma mark - Other methods

- (void)tintColorDidChange
{
    __weak typeof(&*self) weakSelf = self;
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull shapeLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        shapeLayer.strokeColor = weakSelf.progressTintColor.CGColor;
        shapeLayer.fillColor = weakSelf.progressTintColor.CGColor;
    }];
}

- (void)startIndeterminateAnimation
{
    self.shouldStopAnimation = NO;
    [self __beginAnimation];
}
- (void)__beginAnimation{
    self.isAnimating = YES;
    
    [self.layer removeAnimationForKey:kProgressAnimation];
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeAllAnimations];
    }];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [self __circleAnimationBegain];
    }];
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *presentationLayer = obj.presentationLayer?obj.presentationLayer:obj;
        UIBezierPath *dPath = [self __getIndeterminatePathForIdx:idx maxRadius:self.distance_Farther withProgress:0];
        UIBezierPath *dPath2 = [self __getIndeterminatePathForIdx:idx maxRadius:self.distance_Far withProgress:0];
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        keyAnimation.keyTimes = @[
                                  @0,
                                  @(200.0/260) ,
                                  @1
                                  ];
        keyAnimation.values = @[
                                (__bridge id)(presentationLayer.path),
                                (__bridge id)dPath.CGPath,
                                (__bridge id)dPath2.CGPath,
                                ];
        keyAnimation.duration = 0.26;
        keyAnimation.timingFunction = [KLTMediaTimingFunctionMgr getMediaTimingFunctionForKey:kKLTMediaTimingFunctionEaseOutCubic];
        
        obj.path = dPath2.CGPath;
        [obj addAnimation:keyAnimation forKey:kIndeterminateAnimation];
    }];

    [CATransaction commit];
}
- (void)__circleAnimationBegain{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [self __circleAnimationEnd];
    }];
    
    CAKeyframeAnimation *rotateAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.keyTimes = @[
                            @(0),
                            @(1/3.0),
                            @(2/3.0),
                            @(1),
                            ];
    rotateAnim.values = @[
                          @(0.0),
                          @(M_PI_2),
                          @(M_PI_2*2),
                          @(M_PI_2*3),
                          ];
    rotateAnim.duration = 0.6;
    rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2*3, 0, 0, 1);
    [self.layer addAnimation:rotateAnim forKey:kProgressAnimation];
    
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *presentationLayer = obj.presentationLayer?obj.presentationLayer:obj;
        UIBezierPath *dPath1 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.45 andProgress:0];
        UIBezierPath *dPath2 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.35 andProgress:0];
        UIBezierPath *dPath3 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.25 andProgress:0];
        UIBezierPath *dPath4 = [self __getIndeterminatePathLineForIdx:idx withProgress:0];
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        keyAnimation.keyTimes = @[
                                  @0,
                                  @0.1,
                                  @0.35,
                                  @0.55,
                                  @0.75,
                                  @1
                                  ];
        keyAnimation.values = @[
                                (__bridge id)(presentationLayer.path),
                                (__bridge id)dPath1.CGPath,
                                (__bridge id)dPath2.CGPath,
                                (__bridge id)dPath3.CGPath,
                                (__bridge id)dPath4.CGPath,
                                (__bridge id)dPath4.CGPath,
                                ];
        keyAnimation.duration = 0.26;
        obj.path = dPath4.CGPath;
        [obj addAnimation:keyAnimation forKey:kIndeterminateAnimation];
    }];
    
    [CATransaction commit];
}
- (void)__circleAnimationEnd{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
#ifndef __OPTIMIZE__
        //调试代码
        static int count = 0;
        count ++;
        if (count > 6) {
            self.shouldStopAnimation = YES;
            count = 0;
        }
#endif
        if ([self shouldStopAnimation]) {
            [self __endAnimation];
        }else{
            [self __circleAnimation];
        }
    }];
    CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.fromValue = @(M_PI_2*3);
    rotateAnim.toValue = @(M_PI_2*4);
    rotateAnim.duration = 0.2;
    rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    self.layer.transform = CATransform3DIdentity;
    [self.layer addAnimation:rotateAnim forKey:kProgressAnimation];
    
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *dPath1 = [self __getIndeterminatePathLineForIdx:idx withProgress:0];
        UIBezierPath *dPath2 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.15 andProgress:0.1];
        UIBezierPath *dPath3 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.35 andProgress:0.3];
        UIBezierPath *dPath4 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.45 andProgress:0.5];
        UIBezierPath *dPath5 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.45 andProgress:0.8];
        UIBezierPath *dPath6 = [self __getIndeterminatePathForIdx:idx withProgress:0.81];
        UIBezierPath *dPath7 = [self __getIndeterminatePathForIdx:idx withProgress:1];
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        keyAnimation.keyTimes = @[
                                  @0,
                                  @0.1,
                                  @0.3,
                                  @0.5,
                                  @0.8,
                                  @0.81,
                                  @1
                                  ];
        keyAnimation.values = @[
                                (__bridge id)dPath1.CGPath,
                                (__bridge id)dPath2.CGPath,
                                (__bridge id)dPath3.CGPath,
                                (__bridge id)dPath4.CGPath,
                                (__bridge id)dPath5.CGPath,
                                (__bridge id)dPath6.CGPath,
                                (__bridge id)dPath7.CGPath,
                                ];
        keyAnimation.duration = 0.2;
        keyAnimation.timingFunction = [KLTMediaTimingFunctionMgr getMediaTimingFunctionForKey:kKLTMediaTimingFunctionEaseOutCubic];
        obj.path = dPath7.CGPath;
        [obj addAnimation:keyAnimation forKey:kIndeterminateAnimation];
    }];
    
    [CATransaction commit];
}
- (void)__circleAnimation{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [self __circleAnimationEnd];
    }];
    CAKeyframeAnimation *rotateAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.keyTimes = @[
                            @(0),
                            @(1/3.0),
                            @(2/3.0),
                            @(1),
                            ];
    rotateAnim.values = @[
                          @(0.0),
                          @(M_PI_2),
                          @(M_PI_2*2),
                          @(M_PI_2*3),
                          ];
    rotateAnim.duration = 0.6;
    rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2*3, 0, 0, 1);
    [self.layer addAnimation:rotateAnim forKey:kProgressAnimation];
    
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *dPath1 = [self __getIndeterminatePathForIdx:idx withProgress:1];
        UIBezierPath *dPath2 = [self __getIndeterminatePathForIdx:idx withProgress:0.81];
        UIBezierPath *dPath3 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.45 andProgress:0.8];
        UIBezierPath *dPath4 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.45 andProgress:0.5];
        UIBezierPath *dPath5 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.35 andProgress:0.3];
        UIBezierPath *dPath6 = [self __getIndeterminatePathLineForIdx:idx space:M_PI_2*0.15 andProgress:0.1];
        UIBezierPath *dPath7 = [self __getIndeterminatePathLineForIdx:idx withProgress:0];
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        keyAnimation.keyTimes = @[
                                  @0,
                                  @0.2,
                                  @0.21,
                                  @0.5,
                                  @0.7,
                                  @0.9,
                                  @1
                                  ];
        keyAnimation.values = @[
                                (__bridge id)dPath1.CGPath,
                                (__bridge id)dPath2.CGPath,
                                (__bridge id)dPath3.CGPath,
                                (__bridge id)dPath4.CGPath,
                                (__bridge id)dPath5.CGPath,
                                (__bridge id)dPath6.CGPath,
                                (__bridge id)dPath7.CGPath,
                                ];
        keyAnimation.duration = 0.2;
        keyAnimation.timingFunction = [KLTMediaTimingFunctionMgr getMediaTimingFunctionForKey:kKLTMediaTimingFunctionEaseOutCubic];
        obj.path = dPath7.CGPath;
        [obj addAnimation:keyAnimation forKey:kIndeterminateAnimation];
    }];
    
    [CATransaction commit];
}
- (void)__endAnimation{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        self.shouldStopAnimation = NO;
        self.isAnimating = NO;
        if(self.endCallback){
            self.endCallback();
        }
    }];
    CAKeyframeAnimation *rotateAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.keyTimes = @[
                            @(0),
                            @(1),
                            ];
    rotateAnim.values = @[
                          @(0.0),
                          @(M_PI_2)
                          ];
    rotateAnim.duration = 0.2;
    
    CABasicAnimation * opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(1.0);
    opacity.toValue = @(0.0);
    opacity.duration = 0.2;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[
                         rotateAnim,
                         opacity
                         ];
    
    self.layer.opacity = 0;
    [self.layer addAnimation:group forKey:kProgressAnimation];

    [CATransaction commit];
}
- (void)stopIndeterminateAnimation
{
    [self stopIndeterminateAnimationWithCallBack:nil];
}
- (void)stopIndeterminateAnimationWithCallBack:(void (^)())callback{
    if (!self.isAnimating) {
        return;
    }

    self.endCallback = callback;
    self.shouldStopAnimation = YES;
}
@end