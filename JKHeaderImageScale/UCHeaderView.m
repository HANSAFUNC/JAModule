//
//  UCHeaderView.m
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/21.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import "UCHeaderView.h"
static NSString * const ID = @"kTestCell";
@implementation UCHeaderView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
      
      
        
    }
    return self;
}


// 触发 layoutSubviews 后，这个 view 里面的控件想怎么变（旋转，位移，缩放），全部这个方法里面就好了


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 0.00392, 0.54117, 0.85098, 1.0);
    
    CGFloat h1 = self.UC_headerViewHeight;
    NSLog(@"%f",h1);
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGContextMoveToPoint(context, w, h1);
    CGContextAddLineToPoint(context, w, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, h1);
    CGContextAddQuadCurveToPoint(context, w * 0.5, h + (h - h1) * 0.6, w, h1);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFill);
}


@end
