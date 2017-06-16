//
//  UICircularSlider.m
//  yoli
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 Leng. All rights reserved.
//

#import "CircularSlider.h"

#define plusThumbWH   4    // 加大的滑块图片宽高度

@interface CircularSlider (){
    
    BOOL isTouchInThumb;    // 是否触摸在滑动块上面
}

/**
 *  滑动块图片视图
 */
@property (nonatomic,strong)UIImageView *thumbImageView;
/**
 *  滑动块的中心点
 */
@property (nonatomic) CGPoint thumbCenterPoint;

@end

@implementation CircularSlider

#pragma mark -重写对应的setting方法
- (void)setValue:(float)value {
    if (value!=_value) {
        if (value>self.maximumValue) { value=self.maximumValue; }
        if (value<self.minimumValue) { value=self.minimumValue; }
        _value=value;
        [self setNeedsDisplay];
        if (self.isContinuous) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}
- (void)setMinimumValue:(float)minimumValue {
    if (minimumValue!=_minimumValue) {
        _minimumValue=minimumValue;
        if (self.maximumValue<self.minimumValue)	{ self.maximumValue=self.minimumValue; }
        if (self.value<self.minimumValue)			{ self.value=self.minimumValue; }
    }
}
- (void)setMaximumValue:(float)maximumValue {
    if (maximumValue!=_maximumValue) {
        _maximumValue=maximumValue;
        if (self.minimumValue>self.maximumValue)	{ self.minimumValue=self.maximumValue; }
        if (self.value>self.maximumValue)			{ self.value=self.maximumValue; }
    }
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    if (![minimumTrackTintColor isEqual:_minimumTrackTintColor]) {
        _minimumTrackTintColor=minimumTrackTintColor;
        [self setNeedsDisplay];
    }
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    if (![maximumTrackTintColor isEqual:_maximumTrackTintColor]) {
        _maximumTrackTintColor=maximumTrackTintColor;
        [self setNeedsDisplay];
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    if (![thumbTintColor isEqual:_thumbTintColor]) {
        _thumbTintColor=thumbTintColor;
        [self setNeedsDisplay];
    }
}
-(void)setSliderStyle:(CircularSliderStyle)sliderStyle{
    if (sliderStyle!=_sliderStyle) {
        _sliderStyle=sliderStyle;
        [self setNeedsDisplay];
    }
}
-(void)setThumbWidth:(CGFloat)thumbWidth{
    if (_thumbWidth==thumbWidth) return;
    _thumbWidth=thumbWidth;
}
-(void)setCircleWidth:(CGFloat)circleWidth{
    if (_circleWidth==circleWidth) return;
    _circleWidth=circleWidth;
}
-(void)setThumbImage:(UIImage *)thumbImage{
    _thumbImage=thumbImage;
    self.thumbImageView.image=thumbImage;
    
    CGSize becomeBigSize=CGSizeMake(thumbImage.size.width+plusThumbWH, thumbImage.size.width+plusThumbWH);
    self.thumbImageView.frame=CGRectMake(0, 0, becomeBigSize.width, becomeBigSize.height);
    _thumbWidth=becomeBigSize.width/2;
    
}

#pragma mark -初始化的时候
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
- (id)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}

- (void)setup{
    
    // 设置默认的值
    self.value=0.0;
    self.minimumValue=0.0;
    self.maximumValue=1.0;
    self.minimumTrackTintColor=[UIColor redColor];
    self.maximumTrackTintColor=[UIColor whiteColor];
    self.thumbTintColor=[UIColor purpleColor];
    self.thumbWidth=12.0;
    self.circleWidth=10.0;
    self.onlySlideThumb=YES;
    self.continuous=YES;
    self.thumbCenterPoint=CGPointZero;
    
    // 添加对应的图片和手势
    self.thumbImageView=[[UIImageView alloc]init];
    [self addSubview:_thumbImageView];
    
//    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHappened:)];
//    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
    panGestureRecognizer.maximumNumberOfTouches=panGestureRecognizer.minimumNumberOfTouches;
    [self addGestureRecognizer:panGestureRecognizer];
    
}

#pragma mark 圆的半径
- (CGFloat)sliderRadius {
    CGFloat maxValue=MAX(self.thumbWidth, self.circleWidth);         // 设置的是滑动图片对应的半径
    CGFloat radiusValue=self.bounds.size.width/2-maxValue;
    return radiusValue;
}
#pragma mark 绘制滑动块的圆和设置其中心点位置
- (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint inContext:(CGContextRef)context {
    
    if (self.thumbImage) {
        self.thumbImageView.center=sliderButtonCenterPoint;
        return;
    }
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y);
    CGContextAddArc(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y, self.thumbWidth, 0.0, 2*M_PI, NO);
    
    CGContextFillPath(context);
    UIGraphicsPopContext();
}
#pragma mark 绘制圆形
- (CGPoint)drawCircularTrack:(float)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    float angleFromTrack=translateValue(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
    
    CGFloat startAngle=-M_PI_2;
    CGFloat endAngle=startAngle+angleFromTrack;
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
    
    CGPoint arcEndPoint=CGContextGetPathCurrentPoint(context);
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
    return arcEndPoint;
}
#pragma mark 绘制饼状图
- (CGPoint)drawPieTrack:(float)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    
    float angleFromTrack=translateValue(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
    
    CGFloat startAngle=-M_PI_2;
    CGFloat endAngle=startAngle+angleFromTrack;
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
    
    CGPoint arcEndPoint=CGContextGetPathCurrentPoint(context);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    UIGraphicsPopContext();
    
    return arcEndPoint;
}
#pragma mark 重写drawRect:方法绘图
- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGPoint middlePoint;
    middlePoint.x=self.bounds.origin.x+self.bounds.size.width/2;
    middlePoint.y=self.bounds.origin.y+self.bounds.size.height/2;
    
    CGContextSetLineWidth(context, self.circleWidth);
    
    CGFloat radius=[self sliderRadius];
    switch (self.sliderStyle) {
        case CircularSliderStyleWithPie:
            [self.maximumTrackTintColor setFill];
            [self drawPieTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
            [self.minimumTrackTintColor setStroke];
            [self drawCircularTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
            [self.minimumTrackTintColor setFill];
            self.thumbCenterPoint=[self drawPieTrack:self.value atPoint:middlePoint withRadius:radius inContext:context];
            break;
        case CircularSliderStyleWithCircle:
        default:
            [self.maximumTrackTintColor setStroke];
            [self drawCircularTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
            [self.minimumTrackTintColor setStroke];
            self.thumbCenterPoint=[self drawCircularTrack:self.value atPoint:middlePoint withRadius:radius inContext:context];
            break;
    }
    
    [self.thumbTintColor setFill];
    [self drawThumbAtPoint:self.thumbCenterPoint inContext:context];
}

#pragma mark 判断触摸的点是否在滑动块上
- (BOOL)isPointInThumb:(CGPoint)point {
    CGRect thumbTouchRect=CGRectMake(self.thumbCenterPoint.x-self.thumbWidth, self.thumbCenterPoint.y-self.thumbWidth, self.thumbWidth*2, self.thumbWidth*2);
    isTouchInThumb=CGRectContainsPoint(thumbTouchRect, point);
    return isTouchInThumb;
}
#pragma mark -手势触摸事件
// 开始触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[touches anyObject];
    CGPoint touchLocation=[touch locationInView:self];
    
    [self isPointInThumb:touchLocation];
    
    if (self.onlySlideThumb && (!isTouchInThumb)) {
        if ([self.delegate respondsToSelector:@selector(circularSlider:touchPoint:)]) {   // 传递对应的触摸点
            [self.delegate circularSlider:self touchPoint:touchLocation];
        }
    }
    else{
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
}
// 滑动
- (void)panGestureHappened:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint tapLocation=[panGestureRecognizer locationInView:self];
    
    if (self.onlySlideThumb && (!isTouchInThumb)) {
        if ([self.delegate respondsToSelector:@selector(circularSlider:touchPoint:)]) {    // 传递对应的触摸点
            [self.delegate circularSlider:self touchPoint:tapLocation];
        }
        return;
    }
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateChanged: {
            CGFloat radius=[self sliderRadius];
            CGPoint sliderCenter=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            CGPoint sliderStartPoint=CGPointMake(sliderCenter.x, sliderCenter.y-radius);
            CGFloat angle=angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
            
            if (angle<0) {
                angle=-angle;
            }
            else {
                angle=2*M_PI-angle;
            }
            
            self.value=translateValue(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
            break;
        }
        case UIGestureRecognizerStateEnded:
            if (!self.isContinuous) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            if ([self isPointInThumb:tapLocation]) {
                [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
            }
            break;
        default:
            break;
    }
}
//- (void)tapGestureHappened:(UITapGestureRecognizer *)tapGestureRecognizer {
//    
//    if(self.onlySlideThumb) return;
//    
//    if (tapGestureRecognizer.state==UIGestureRecognizerStateEnded) {
//        CGPoint tapLocation=[tapGestureRecognizer locationInView:self];
//        if ([self isPointInThumb:tapLocation]) {
//        }
//    }
//}


@end

#pragma mark 转换为目标值
float translateValue(float sourceValue, float sourceMinimum, float sourceMaximum, float targetMinimum, float targetMaximum){
    
    float a, b, destinationValue;
    a=(targetMaximum-targetMinimum)/(sourceMaximum-sourceMinimum);
    b=targetMaximum-a*sourceMaximum;
    destinationValue=a*sourceValue+b;
    
    return destinationValue;
    
}
#pragma mark 三点间的角度
CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) {
    
    CGPoint v1=CGPointMake(p1.x-centerPoint.x, p1.y-centerPoint.y);
    CGPoint v2=CGPointMake(p2.x-centerPoint.x, p2.y-centerPoint.y);
    CGFloat angle=atan2f(v2.x*v1.y-v1.x*v2.y, v1.x*v2.x+v1.y*v2.y);
    
    return angle;
}

