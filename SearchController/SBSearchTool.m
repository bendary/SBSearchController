//
//  SBSearchTool.m
//
//
//  Created by xiaoshaobin on 15/12/14.
//  Copyright (c) 2015年 xiaoshaobin. All rights reserved.
//

#import "SBSearchTool.h"

@implementation SBSearchTool

+ (UIColor *)colorWithUInt:(NSUInteger)rgb
{
    return [SBSearchTool colorWithUInt:rgb alpha:1];
}

+ (UIColor *)colorWithUInt:(NSUInteger)rgb alpha:(CGFloat)alpha
{
    CGFloat r = (rgb >> 16) /255.0;
    CGFloat g = (rgb >> 8 & 0xff) / 255.0;
    CGFloat b = (rgb & 0xff) /255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end
