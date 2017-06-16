//
//  UICircularSlider.h
//  yoli
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 Leng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CircularSliderStyle) {
    
    CircularSliderStyleWithCircle  =0,       // 圆形
    CircularSliderStyleWithPie     =1       //  饼状图
};

@class CircularSlider;
@protocol CircularSliderDelegate <NSObject>
@optional
/**
 *  触摸和滑动本类视图中点的位置
 *
 */
-(void)circularSlider:(CircularSlider *)circularSlider touchPoint:(CGPoint)pointValue;
@end

@interface CircularSlider : UIControl

/**
 *  设置进度值
 */
@property (nonatomic) float value;
/**
 *  进度最小值
 */
@property (nonatomic) float minimumValue;
/**
 *  进度最大值
 */
@property (nonatomic) float maximumValue;
/**
 *  进度滑过的颜色
 */
@property(nonatomic, retain) UIColor *minimumTrackTintColor;
/**
 *  进度还没有滑过的颜色
 */
@property(nonatomic, retain) UIColor *maximumTrackTintColor;
/**
 *  滑动块的颜色
 */
@property(nonatomic, retain) UIColor *thumbTintColor;
/**
 *  滑动块的半径
 */
@property(nonatomic, assign) CGFloat thumbWidth;
/**
 *  圆的线条宽度
 */
@property(nonatomic, assign) CGFloat circleWidth;
/**
 *  滑动块的图片(设置了图片,滑动块的颜色和宽度可以不用设置,设置了也会优先使用图片,只有没有设置图片才会通过绘图绘制圆形滑动块)
 */
@property (nonatomic, strong)UIImage *thumbImage;
/**
 *  是否只是滑动滑动块
 */
@property (nonatomic, assign, getter=isOnlySlideThumb)BOOL onlySlideThumb;
/**
 *  是否一直输入进度
 */
@property(nonatomic, assign, getter=isContinuous) BOOL continuous;
/**
 *  样式
 */
@property (nonatomic,assign) CircularSliderStyle sliderStyle;
/**
 *  代理属性
 */
@property (nonatomic,assign) id<CircularSliderDelegate> delegate;

@end

/**
 *  转换为目标值
 *
 */
float translateValue(float sourceValue, float sourceMinimum, float sourceMaximum, float targetMinimum, float targetMaximum);
/**
 *  三点间的角度
 *
 */
CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2);
