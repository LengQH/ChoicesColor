//
//  ViewController.m
//  ChoicesColor
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 冷求慧. All rights reserved.
//

#import "ViewController.h"

#import "Palette.h"           //  取色板类
#import "CircularSlider.h"    //  滑块类

#define cusColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface ViewController ()<PaletteDelegate,CircularSliderDelegate>



/**
 *  取色板主视图
 */
@property (weak, nonatomic) IBOutlet Palette *paletteMainView;
/**
 *  选中的颜色视图
 */
@property (weak, nonatomic) IBOutlet UIView *choicesColorView;




/**
 *  滑块主视图
 */
@property (weak, nonatomic) IBOutlet CircularSlider *sliderMainView;
/**
 *  进度Label
 */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;




/**
 *  使用的取色板主视图
 */
@property (weak, nonatomic) IBOutlet Palette *useMainPalette;
/**
 *  使用的滑块视图
 */
@property (weak, nonatomic) IBOutlet CircularSlider *useSliderView;
/**
 *  确定的颜色
 */
@property (weak, nonatomic) IBOutlet UIView *sureChoicesColor;
/**
 *  确定的亮度
 */
@property (weak, nonatomic) IBOutlet UIView *sureLightColor;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paletteMainView.backgroundColor=[UIColor clearColor];
    self.useMainPalette.backgroundColor=[UIColor clearColor];
    self.useSliderView.backgroundColor=[UIColor clearColor];
    
    [self someUISet];
}
#pragma mark 一些UI设置
-(void)someUISet{
    
    
    self.paletteMainView.delegate=self;
    
    
    self.sliderMainView.minimumTrackTintColor=[UIColor purpleColor];
    self.sliderMainView.maximumTrackTintColor=[UIColor redColor];
    self.sliderMainView.circleWidth=5.0;
    self.sliderMainView.onlySlideThumb=NO;   // 设置为YES 只能滑动滑块
    self.sliderMainView.thumbImage=[UIImage imageNamed:@"sliderThumbImage"];
    [self.sliderMainView addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    
    
    self.useSliderView.minimumTrackTintColor=[UIColor clearColor];
    self.useSliderView.maximumTrackTintColor=[UIColor clearColor];
    self.useSliderView.circleWidth=8.0;
    self.useSliderView.delegate=self;
    self.useSliderView.onlySlideThumb=YES;
    self.useSliderView.thumbImage=[UIImage imageNamed:@"sliderThumbImage"];
    [self.useSliderView addTarget:self action:@selector(userSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    
}
#pragma mark 取色板代理方法
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint{
    self.choicesColorView.backgroundColor=color;
}
#pragma mark 滑动圆Slider代理方法
-(void)circularSlider:(CircularSlider *)circularSlider touchPoint:(CGPoint)pointValue{
    
    CGFloat thumbWValue=circularSlider.thumbWidth;
    CGFloat wDistance=-(self.sliderWDistance.constant+thumbWValue);
    CGPoint colorPoint=CGPointMake(pointValue.x-wDistance, pointValue.y-wDistance);
    UIColor *choiceColor=[self.useMainPalette calculateCenterPointInView:colorPoint];   // 得到对应的颜色
    self.sureChoicesColor.backgroundColor=choiceColor;
}
#pragma mark 滑动圆Slider的进度
-(void)changeProgress:(UISlider *)sender{
    self.progressLabel.text=[NSString stringWithFormat:@"值是:%0.3f",sender.value];
}
#pragma mark 滑动圆Slider改变颜色亮度的值
-(void)userSliderAction:(UISlider *)sender{
    CGFloat colorValue=255.0f-255.0f*sender.value;   // 对应的颜色比例值(因为这里只是黑白颜色渐变,所以其RGB三个值都是相等的 所以直接根据两种颜色的RGB的差值(255.0)进行计算)
    self.sureLightColor.backgroundColor=cusColor(colorValue, colorValue, colorValue, 1.0);
}

@end
