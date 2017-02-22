//
//  ClipCornerController.h
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/22.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ClipCornerType) {
    ClipCornerTypeCustom=1,
    ClipCornerTypeBezier,
    ClipCornerTypeDraw,
};
@interface ClipCornerController : UIViewController
-(instancetype)initWithClipCornerType:(ClipCornerType)type;
@end
