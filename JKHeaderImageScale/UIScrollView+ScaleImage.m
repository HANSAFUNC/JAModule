//
//  UIScrollView+ScaleImage.m
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/21.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import "UIScrollView+ScaleImage.h"
#import <objc/runtime.h>
#import "UCHeaderView.h"
/**
 *  分类的目的：实现两个方法实现的交换，调用原有方法，有现有方法(自己实现方法)的实现。
 */
@interface NSObject (MethodSwizzling)

/**
 *  交换对象方法
 *
 *  @param origSelector    原有方法
 *  @param swizzleSelector 现有方法(自己实现方法)
 */
+ (void)ja_swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector;

/**
 *  交换类方法
 *
 *  @param origSelector    原有方法
 *  @param swizzleSelector 现有方法(自己实现方法)
 */
+ (void)ja_swizzleClassSelector:(SEL)origSelector
                swizzleSelector:(SEL)swizzleSelector;

@end

@implementation NSObject (MethodSwizzling)

+ (void)ja_swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector {
    
    // 获取原有方法
    Method origMethod = class_getInstanceMethod(self,
                                                origSelector);
    // 获取交换方法
    Method swizzleMethod = class_getInstanceMethod(self,
                                                   swizzleSelector);
    
    // 注意：不能直接交换方法实现，需要判断原有方法是否存在,存在才能交换
    // 如何判断？添加原有方法，如果成功，表示原有方法不存在，失败，表示原有方法存在
    // 原有方法可能没有实现，所以这里添加方法实现，用自己方法实现
    // 这样做的好处：方法不存在，直接把自己方法的实现作为原有方法的实现，调用原有方法，就会来到当前方法的实现
    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (!isAdd) { // 添加方法失败，表示原有方法存在，直接替换
        method_exchangeImplementations(origMethod, swizzleMethod);
    }
}

+ (void)ja_swizzleClassSelector:(SEL)origSelector swizzleSelector:(SEL)swizzleSelector
{
    // 获取原有方法
    Method origMethod = class_getClassMethod(self,
                                             origSelector);
    // 获取交换方法
    Method swizzleMethod = class_getClassMethod(self,
                                                swizzleSelector);
    
    // 添加原有方法实现为当前方法实现
    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (!isAdd) { // 添加方法失败，原有方法存在，直接替换
        method_exchangeImplementations(origMethod, swizzleMethod);
    }
}

@end



static char * const imageViewKey = "kImageViewKey";
static char * const imageViewHeightKey = "kImageViewHeightKey";
static char * const UC_ViewKey = "kUCKey";
static char * const originOffSetKey = "kOriginOffSetKey";
static char * const ja_TypeKey = "kHeaderTypeKey";
static char * const ja_beginYKey = "kBeginYKey";
static char * const ja_isNavgationKey = "kIsNavgation";

static CGFloat const defaultHeight = 200;

@implementation UIScrollView (ScaleImage)


+(void)load {
    [self ja_swizzleInstanceSelector:@selector(setTableHeaderView:) swizzleSelector:@selector(setJa_TableHeaderView:)];
}

-(void)setJa_TableHeaderView:(UIView*)tableHeaderView {
    
    if (![self isMemberOfClass:[UITableView class]]) return;
    
    [self setJa_TableHeaderView:tableHeaderView];
    
}


-(UIImageView *)ja_headerImageView
{
    UIImageView *imageView = objc_getAssociatedObject(self, imageViewKey);
    if (imageView == nil) {
        
        imageView = [[UIImageView alloc] init];
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imageView];
        
        objc_setAssociatedObject(self, imageViewKey, imageView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return imageView;
}

-(UCHeaderView*)ja_UCHeaderView {
    UCHeaderView * view = objc_getAssociatedObject(self, UC_ViewKey);
    if (!view) {
        view = [[UCHeaderView alloc]init];
        
        view.UC_headerViewHeight = self.ja_headerScaleHeight;
        
        [self addSubview:view];
        objc_setAssociatedObject(self, UC_ViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

-(void)setOriginOffsetY:(CGFloat)originOffsetY {
    objc_setAssociatedObject(self, originOffSetKey, @(originOffsetY), OBJC_ASSOCIATION_ASSIGN);
}
-(CGFloat)originOffsetY {
    return [objc_getAssociatedObject(self, originOffSetKey) floatValue];
}
-(void)setIsNavgation:(BOOL)isNavgation {
    objc_setAssociatedObject(self, ja_isNavgationKey, @(isNavgation), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isNavgation {
    BOOL isNavgation = [objc_getAssociatedObject(self, ja_isNavgationKey) boolValue];
    
    return isNavgation;
}
-(void)setBenginY:(CGFloat)benginY {
    objc_setAssociatedObject(self, ja_beginYKey, @(benginY), OBJC_ASSOCIATION_ASSIGN);
}
-(CGFloat)benginY {
    return [objc_getAssociatedObject(self, ja_beginYKey) floatValue];
}

-(void)setJa_UCHeaderView:(UIView *)ja_UCHeaderView {
    objc_setAssociatedObject(self, UC_ViewKey, ja_UCHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setJa_headerScaleImage:(UIImage *)ja_headerScaleImage {
    self.ja_headerImageView.image = ja_headerScaleImage;
    
}

-(UIImage *)ja_headerScaleImage {
    
    return self.ja_headerImageView.image;
    
}

-(void)setJa_headerScaleHeight:(CGFloat)ja_headerScaleHeight{
    objc_setAssociatedObject(self, imageViewHeightKey, @(ja_headerScaleHeight), OBJC_ASSOCIATION_ASSIGN);
    
}

-(CGFloat)ja_headerScaleHeight {
    
    CGFloat headerImageHeight = [objc_getAssociatedObject(self, imageViewHeightKey) floatValue];
    
    return headerImageHeight == 0?defaultHeight:headerImageHeight;
}


-(void)setupJA_DefaultHeaderView:(CGRect)rect {
    [self setupJA_DefaultHeaderViewFrame:rect];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    
}
-(void)setupJA_DefaultHeaderViewFrame:(CGRect)rect {
    
    self.ja_headerImageView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, self.ja_headerScaleHeight);
}
-(void)setupJA_UCHeaderView:(CGRect)rect {
    
    [self setupJA_UCHeaderViewFrame:rect];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)setupJA_UCHeaderViewFrame:(CGRect)rect {
    
    self.ja_UCHeaderView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, self.ja_headerScaleHeight);
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGFloat offsetY = self.contentOffset.y;
    CGFloat nav64 = self.isNavgation ==YES?64:0;
    
    
    if (self.headerType == ja_Default) {
        CGFloat scale = offsetY +self.originOffsetY + nav64;
        if (offsetY < -(self.originOffsetY+nav64)) {
            
            self.ja_headerImageView.frame = CGRectMake(scale,scale+self.benginY, self.bounds.size.width - scale * 2, self.ja_headerScaleHeight - offsetY-self.originOffsetY-nav64);
        } else {
            
            self.ja_headerImageView.frame = CGRectMake(0, self.benginY, self.bounds.size.width, self.ja_headerScaleHeight);
        }
    }
    if (self.headerType == ja_UC) {
        CGRect frame = self.ja_UCHeaderView.frame;
        if (offsetY < -(self.originOffsetY+nav64)) {
            
            frame.size.height = self.ja_headerScaleHeight - offsetY -self.originOffsetY-nav64;
            
            frame.origin.y = self.benginY +(offsetY+self.originOffsetY+nav64);
            // 及时归零
            
        } else {
            
            frame.size.height = self.ja_headerScaleHeight;
            
            
        }
        self.ja_UCHeaderView.frame = frame;
        [self.ja_UCHeaderView setNeedsDisplay];
        
    }
    
}

-(void)setHeaderType:(ja_headerType)headerType {
    
    objc_setAssociatedObject(self, ja_TypeKey, @(headerType), OBJC_ASSOCIATION_ASSIGN);
    
}
-(ja_headerType)headerType {
    
    
    return [objc_getAssociatedObject(self, ja_TypeKey) integerValue];
}

//-(UIView *)headerViewInitialWithRect:(CGRect)rect {
//    if (self.isUseHeaderBot) {
//        UIView * header = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
//        return header;
//    }else{
//        UIView * header = [[UIView alloc]initWithFrame:CGRectZero];
//        return header;
//    }
//
//}
-(void)ja_pullRefreshDefaultHeader:(UIImage *)image HeaderRect:(CGRect )rect {
    if (image) {
        self.ja_headerScaleImage = image;
    }
    self.benginY = rect.origin.y;
    self.ja_headerScaleHeight = rect.size.height;
    [self ja_pullRefreshType:ja_Default headerViewRect:rect];
}

-(void)ja_pullRefreshUC_Header:(CGRect)rect {
    self.benginY = rect.origin.y;
    self.ja_headerScaleHeight = rect.size.height;
    [self ja_pullRefreshType:ja_UC headerViewRect:rect];
}


-(void)ja_pullRefreshType:(ja_headerType)type headerViewRect:(CGRect)rect{
    
    self.headerType = type;
    if (![self isMemberOfClass:[UITableView class]]) return;
    UITableView * tableView = (UITableView*)self;
    tableView.contentInset = UIEdgeInsetsMake(fabs(rect.origin.y), 0, 0, 0);
    self.originOffsetY = tableView.contentInset.top;
    if (type == ja_Default) {
        //        tableView.tableHeaderView = [self headerViewInitialWithRect:rect];
        
        [self setupJA_DefaultHeaderView:rect];
    }else if(type == ja_UC) {
        
        //        tableView.tableHeaderView = [self headerViewInitialWithRect:rect];
        [self setupJA_UCHeaderView:rect];
    }
}

-(void)dealloc {
    if ([self isMemberOfClass:[UITableView class]]) {
        [self removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
    
}

@end
