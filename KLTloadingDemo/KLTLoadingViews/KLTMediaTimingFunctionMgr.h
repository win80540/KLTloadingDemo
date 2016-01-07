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

typedef enum{
    kKLTMediaTimingFunctionEaseOutQuint = 0,
    kKLTMediaTimingFunctionEaseOutQuart = 1,
    kKLTMediaTimingFunctionEaseOutQuad = 2
} kKLTMediaTimingFunction;


@interface KLTMediaTimingFunctionMgr : NSObject

+ (CAMediaTimingFunction *)getMediaTimingFunctionForKey:(kKLTMediaTimingFunction)key;

+ (CAMediaTimingFunction *)getEaseOutQuintFunction;
+ (CAMediaTimingFunction *)getEaseOutQuartFunction;
+ (CAMediaTimingFunction *)getEaseOutQuadFunction;

@end
