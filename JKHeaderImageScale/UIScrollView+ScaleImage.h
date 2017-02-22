//
//  UIScrollView+ScaleImage.h
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/21.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ja_headerType) {
    ja_Default = 0,
    ja_UC,
};
@interface UIScrollView (ScaleImage)

@property (nonatomic ,strong) UIImage * ja_headerScaleImage;
@property (nonatomic ,strong) UIView * ja_UCHeaderView;
@property (nonatomic ,assign) CGFloat ja_headerScaleHeight;
@property (nonatomic ,assign) CGFloat benginY;
@property (nonatomic ,assign) CGFloat originOffsetY;
/**
 *  让头部view不置顶
 */
@property (nonatomic ,assign) BOOL isNavgation;
@property (nonatomic ,assign) ja_headerType headerType;
/**
 *  下拉放大+刷新
 *
 *  @param image 背景图
 *  @param rect  位置
 */
-(void)ja_pullRefreshDefaultHeader:(UIImage *)image HeaderRect:(CGRect )rect;
/**
 *  UC主页下拉刷新
 *
 *  @param rect 位置
 */
-(void)ja_pullRefreshUC_Header:(CGRect)rect;
@end
