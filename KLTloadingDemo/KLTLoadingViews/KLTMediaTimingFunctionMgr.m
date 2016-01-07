//
//  KLTMediaTimingFunctionMgr.m
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//

#import "KLTMediaTimingFunctionMgr.h"

@implementation KLTMediaTimingFunctionMgr
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
+ (CAMediaTimingFunction *)getEaseOutElasticFunction{
    return nil;
    
//    static CAMediaTimingFunction * timingF = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        timingF = [CAMediaTimingFunction functionWithControlPoints:0.455 :0.03 :0.515 :0.955];
//    });
//    return timingF;
}

@end
