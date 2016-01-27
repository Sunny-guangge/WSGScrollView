//
//  WSGScrollView.h
//  WSGScrollView
//
//  Created by user on 16/1/27.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,WSGPageControlShowStyle) {
  
    WSGPageControlShowStyleNone             = 0,
    WSGPageControlShowStyleBottomLeft       = 1 << 0,
    WSGPageControlShowStyleCenter           = 1 << 1,
    WSGPageControlShowStyleBottomRight      = 1 << 2,
    WSGPageControlShowStyleTopLeft          = 1 << 3,
    WSGPageControlShowStyleTopRight         = 1 << 4,
    
};

typedef void(^tapCallBackBlock)(NSUInteger index,NSString *imageURL);

@interface WSGScrollView : UIView

@property (nonatomic,assign) NSTimeInterval scrollTime;

@property (nonatomic,assign)  BOOL isAutoScrool;

@property (nonatomic,assign) WSGPageControlShowStyle pageControlShowStyle;

@property (nonatomic,copy) tapCallBackBlock tapcallbackBlock;

+ (instancetype)scrollViewWithFrame:(CGRect)frame imageArray:(NSMutableArray *)array placeHolderImage:(NSString *)imageURL pageControlShowStyle:(WSGPageControlShowStyle)pageControlShowStyle;

@end
