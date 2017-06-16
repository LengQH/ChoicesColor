//
//  Palette.h
//  ChoicesColor
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 冷求慧. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Palette;
@protocol PaletteDelegate <NSObject>
@optional
/**
 *  选中的颜色和对应的位置
 *
 *  @param patette    本类对象
 *  @param color      颜色值
 *  @param colorPoint 中心点
 */
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint;

@end
@interface Palette : UIView
/**
 *  代理属性
 */
@property (nonatomic,weak) id<PaletteDelegate> delegate;
/**
 *  滑块的中心点
 */
@property (nonatomic,assign) CGPoint    sliderCenter;
/**
 *  计算中心点位置和获取颜色
 *
 *  @param point 在本类View中的位置
 *
 *  @return 颜色
 */
-(UIColor *)calculateCenterPointInView:(CGPoint)point;

@end
