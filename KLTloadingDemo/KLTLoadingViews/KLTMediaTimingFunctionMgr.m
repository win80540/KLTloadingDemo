//
//  KLTMediaTimingFunctionMgr.m
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import "KLTMediaTimingFunctionMgr.h"

@implementation KLTMediaTimingFunctionMgr
+ (CAMediaTimingFunction *)getMediaTimingFunctionForKey:(kKLTMediaTimingFunction)key{
    switch (key) {
        case kKLTMediaTimingFunctionEaseOutQuint:
            return [self getEaseOutQuintFunction];
        case kKLTMediaTimingFunctionEaseOutQuart:
            return [self getEaseOutQuartFunction];
        case kKLTMediaTimingFunctionEaseOutQuad:
            return [self getEaseOutQuadFunction];
        default:
            break;
    }
}

+ (CAMediaTimingFunction *)getEaseOutQuintFunction{
    static CAMediaTimingFunction * timingF = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timingF = [CAMediaTimingFunction functionWithControlPoints:0.22 :1 :0.32 :1];
    });
    return timingF;
}
+ (CAMediaTimingFunction *)getEaseOutQuartFunction{
    static CAMediaTimingFunction * timingF = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timingF = [CAMediaTimingFunction functionWithControlPoints:0.165 :0.84 :0.44 :1];
    });
    return timingF;
}
+ (CAMediaTimingFunction *)getEaseOutQuadFunction{
    static CAMediaTimingFunction * timingF = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timingF = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.46 :0.45 :0.94];
    });
    return timingF;
}


@end
