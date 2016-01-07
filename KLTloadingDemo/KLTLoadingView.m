//
//  KLTLoadingView.m
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import "KLTLoadingView.h"
#import "KLTMediaTimingFunctionMgr.h"

static const CGFloat stateStart = 0.001f;
static const CGFloat stateEnd = 0.28f;
static CGPoint pointRates[2][4] = {
    {
        {0.25,0.5},{0.5,0.25},{0.75,0.5},{0.5,0.75}
    },
    {
        {0,0.5},{0.5,0.0},{1,0.5},{0.5,1.0}
    }
};
static CGPoint control1Rates[2][4] = {
    {
        {0.25,0.5-stateStart},{0.5+stateStart,0.25},{0.75,0.5+stateStart},{0.5-stateStart,0.75}
    },
    {
        {0.0,0.5-stateEnd},{0.5+stateEnd,0.0},{1.0,0.5+stateEnd},{0.5-stateEnd,1.0}
    }
};
static CGPoint control2Rates[2][4] = {
    {
        {0.5-stateStart,0.25},{0.75,0.5-stateStart},{0.5+stateStart,0.75},{0.25,0.5+stateStart}
    },
    {
        {0.5-stateEnd,0.0},{1.0,0.5-stateEnd},{0.5+stateEnd,1.0},{0.0,0.5+stateEnd}
    }
};

@interface KLTLoadingView (){
    CALayer *_borderLayer;
    CALayer *_centerLayer;
    NSMutableArray<NSMutableArray<UIBezierPath *> *> *_pathStates;
}
@end
@implementation KLTLoadingView
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
    self.lineWidth = 0.5;
}

- (void)start{
    [self __start];
}

- (void)__start{
    [_borderLayer removeFromSuperlayer];
    [_centerLayer removeFromSuperlayer];


    CGPoint centerP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat width = MIN(self.bounds.size.width, self.bounds.size.height)/2.0;
    NSMutableArray<CAShapeLayer *> *centerSegements = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray<CAShapeLayer *> *borderSegements = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray<NSMutableArray<UIBezierPath *> *> *pathStates = [NSMutableArray arrayWithCapacity:4];
    {
        for (int i=0; i<2; i++){
            NSMutableArray *paths = [NSMutableArray arrayWithCapacity:4];
            //state2 and state3
            for (int j=0; j<4; j++) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(pointRates[i][j].x*width, pointRates[i][j].y*width)];
                [path addCurveToPoint:CGPointMake(pointRates[i][(j+1)%4].x*width, pointRates[i][(j+1)%4].y*width) controlPoint1:CGPointMake(control1Rates[i][j].x*width, control1Rates[i][j].y*width)  controlPoint2:CGPointMake(control2Rates[i][j].x*width, control2Rates[i][j].y*width)];
                [paths addObject:path];
            }
            [pathStates addObject:paths];
        }
    }
    _pathStates = pathStates;

    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = self.bounds;
    borderLayer.position = centerP;
    [self.layer addSublayer:borderLayer];
    {
        for (int i=0; i<4; i++) {
            UIBezierPath *path = pathStates[1][i];
            CAShapeLayer *segment = [CAShapeLayer layer];
            segment.bounds = CGRectMake(0, 0, width, width);
            segment.position = CGPointMake(CGRectGetMidX(borderLayer.bounds), CGRectGetMidY(borderLayer.bounds));
            segment.lineWidth = self.lineWidth;
            segment.strokeColor = self.lineColor.CGColor;
            segment.fillColor = [UIColor clearColor].CGColor;
            segment.path = path.CGPath;
            [borderLayer addSublayer:segment];
            [borderSegements addObject:segment];
        }
    }
    borderLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);

    CALayer *centerLayer = [CAShapeLayer layer];
    centerLayer.bounds = self.bounds;
    centerLayer.position = centerP;
    [self.layer addSublayer:centerLayer];
    {
        for (int i=0; i<4; i++) {
            UIBezierPath *path = pathStates[0][i];
            CAShapeLayer *segment = [CAShapeLayer layer];
            segment.bounds = CGRectMake(0, 0, width, width);
            segment.position = CGPointMake(CGRectGetMidX(centerLayer.bounds), CGRectGetMidY(centerLayer.bounds));
            segment.lineWidth = self.lineWidth;
            segment.strokeColor = self.lineColor.CGColor;
            segment.fillColor = [UIColor clearColor].CGColor;
            segment.path = path.CGPath;
            [centerLayer addSublayer:segment];
            [centerSegements addObject:segment];
        }
    }
    centerLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    {
        CABasicAnimation * rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        rotateAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 0, 0, 1)];
        rotateAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        rotateAnim.duration = 1.2;
        rotateAnim.removedOnCompletion = NO;
        rotateAnim.fillMode = kCAFillModeForwards;
        rotateAnim.repeatCount = MAXFLOAT;
        rotateAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuadFunction];

        [borderSegements enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj addAnimation:[self __pathBorderAnimationForIndex:idx] forKey:@"animPath"];
        }];

        [borderLayer addAnimation:rotateAnim forKey:@"animRotate"];
    }
    {
        CABasicAnimation * rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        rotateAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 0, 0, 1)];
        rotateAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        rotateAnim.duration = 1.2;
        rotateAnim.removedOnCompletion = NO;
        rotateAnim.fillMode = kCAFillModeBoth;
        rotateAnim.repeatCount = MAXFLOAT;
        rotateAnim.timingFunction = [KLTMediaTimingFunctionMgr getEaseOutQuadFunction];
        [centerSegements enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj addAnimation:[self __pathCenterAnimationForIndex:idx] forKey:@"animPath"];
        }];

        [centerLayer addAnimation:rotateAnim forKey:@"animRotate"];
    }
    [CATransaction commit];



    _borderLayer = borderLayer;
    _centerLayer = centerLayer;
}

- (CAKeyframeAnimation *)__pathCenterAnimationForIndex:(NSUInteger)idx{
    CAKeyframeAnimation * pathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pathAnim.values = @[
                        (__bridge id)_pathStates[0][idx].CGPath,
                        (__bridge id)_pathStates[1][idx].CGPath,
                        (__bridge id)_pathStates[1][idx].CGPath,
                        (__bridge id)_pathStates[0][idx].CGPath,
                        (__bridge id)_pathStates[0][idx].CGPath,
                        ];
    pathAnim.keyTimes =@[
                         @0,
                         @(0.8/2.4),
                         @(1.2/2.4),
                         @(2.0/2.4),
                         @1,
                         ];
    pathAnim.duration = 2.4;
    pathAnim.timingFunctions = @[
                                 [KLTMediaTimingFunctionMgr getEaseOutQuartFunction],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                 [KLTMediaTimingFunctionMgr getEaseOutQuartFunction],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                 ];
    pathAnim.removedOnCompletion = NO;
    pathAnim.fillMode = kCAFillModeBoth;
    pathAnim.repeatCount = MAXFLOAT;
    return pathAnim;
}
- (CAKeyframeAnimation *)__pathBorderAnimationForIndex:(NSUInteger)idx{
    CAKeyframeAnimation * pathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pathAnim.values = @[
                        (__bridge id)_pathStates[1][idx].CGPath,
                        (__bridge id)_pathStates[0][idx].CGPath,
                        (__bridge id)_pathStates[0][idx].CGPath,
                        (__bridge id)_pathStates[1][idx].CGPath,
                        (__bridge id)_pathStates[1][idx].CGPath,
                        ];
    pathAnim.keyTimes =@[
                         @0,
                         @(0.8/2.4),
                         @(1.2/2.4),
                         @(2.0/2.4),
                         @1,
                         ];
    pathAnim.duration = 2.4;
    pathAnim.timingFunctions = @[
                                 [KLTMediaTimingFunctionMgr getEaseOutQuartFunction],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                 [KLTMediaTimingFunctionMgr getEaseOutQuartFunction],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                 ];
    pathAnim.removedOnCompletion = NO;
    pathAnim.fillMode = kCAFillModeBoth;
    pathAnim.repeatCount = MAXFLOAT;
    return pathAnim;
}
#pragma mark getter
- (UIColor *)lineColor{
    if (_lineColor) {
        return _lineColor;
    }
    _lineColor = [UIColor grayColor];
    return _lineColor;
}
@end