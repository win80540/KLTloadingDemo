//
//  KLTMediaTimingFunctionMgr.h
//  KLTloadingDemo
//
//  Created by 田凯 on 15/12/30.
//  Copyright © 2015年 netease. All rights reserved.
//


//http://easings.net/en

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h> 
@interface KLTMediaTimingFunctionMgr : NSObject

+ (CAMediaTimingFunction *)getEaseOutQuintFunction;
+ (CAMediaTimingFunction *)getEaseOutQuartFunction;
+ (CAMediaTimingFunction *)getEaseOutQuadFunction;
+ (CAMediaTimingFunction *)getEaseOutElasticFunction;
@end
