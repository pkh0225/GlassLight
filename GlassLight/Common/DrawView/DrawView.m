//
//  DrawView.m
//  CalCircle
//
//  Created by hyeoncheol yi on 12. 5. 30..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"
#import "math.h"
#import "CGPointUtils.h"

#define kRadiusMax 200
#define kRdiusMin 20

@interface DrawView() {
    
}
@property(strong, nonatomic) CALayer *orbit1;
@property(strong, nonatomic) CALayer *planet1;
@end

@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.multipleTouchEnabled = YES;
    _m_radiusMax = 150.0;
    _m_ColorCircleFill = [UIColor redColor];
    _m_ColorCircleLine = [UIColor redColor];
    _m_radiusMic = 0;
    m_draw = NO;
    _m_drawModeFull = NO;
    
    UIPinchGestureRecognizer *pinGestureRecognizer2 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    pinGestureRecognizer2.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:pinGestureRecognizer2];
    
    
    _orbit1 = [CALayer layer];
    CGFloat width = _m_radiusMax *2;
    _orbit1.bounds = CGRectMake(0, 0, width, width);
    _orbit1.position = self.center;
    _orbit1.cornerRadius = _m_radiusMax;
    _orbit1.borderColor = _m_ColorCircleLine.CGColor;
    _orbit1.borderWidth = 1.5;
    [self.layer addSublayer:_orbit1];
    
    _planet1 = [CALayer layer];
    _planet1.bounds = CGRectMake(0, 0, kRdiusMin, kRdiusMin);
    _planet1.position = self.center;
    _planet1.cornerRadius = kRdiusMin / 2;
    _planet1.backgroundColor = _m_ColorCircleFill.CGColor;
    [self.layer addSublayer:_planet1];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. sqrt()

- (void)layoutSubviews {
    [super layoutSubviews];
    _orbit1.position = self.center;
    _planet1.position = self.center;
}

#pragma - set, get
- (void)setM_radiusMax:(CGFloat)radiusMax
{
    _m_radiusMax = radiusMax;
    if (_m_radiusMax > kRadiusMax) _m_radiusMax = kRadiusMax;
    if (_m_radiusMax < kRdiusMin) _m_radiusMax = kRdiusMin;
}

#pragma -Custom Funtion
-(void)OnDraw
{
//    m_draw = YES;
//    [self setNeedsDisplay];
//    for (CALayer *layer in [self.layer sublayers]) {
//        [layer removeFromSuperlayer];
//    }
    
    
    _orbit1.borderColor = _m_ColorCircleLine.CGColor;
    _planet1.backgroundColor = _m_ColorCircleFill.CGColor;
    if (_m_drawModeFull) {
        _m_radiusMic = _m_radiusMax;
        _orbit1.backgroundColor = _m_ColorCircleFill.CGColor;
        return;
    }
    
    if (beforeRadiusMic == _m_radiusMic) return;
    
    
    if (beforeRadiusMic < _m_radiusMic) {

//            NSLog(@"beforeRadiusMic = %f", beforeRadiusMic);
//            NSLog(@"_m_radiusMic = %f", _m_radiusMic);
        
        CGFloat scale = _m_radiusMic * 14 / _m_radiusMax;
        
        
        CALayer *layerAnimation = [CALayer layer];
        layerAnimation.bounds = _planet1.bounds;
        layerAnimation.position = self.center;
        layerAnimation.cornerRadius = kRdiusMin / 2;
        layerAnimation.backgroundColor = _m_ColorCircleFill.CGColor;
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [layerAnimation removeFromSuperlayer];
        }];
        
        CAAnimationGroup *group = [CAAnimationGroup new];
        group.duration = 1;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group.removedOnCompletion = NO;
        
        CABasicAnimation *animationUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animationUp.duration = 0.15;
        animationUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animationUp.fromValue = [NSNumber numberWithFloat:1.0];
        animationUp.toValue = [NSNumber numberWithFloat:scale];
        animationUp.removedOnCompletion = NO;
        
        CABasicAnimation *animationDown = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animationDown.duration = 0.8;
        animationDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationDown.fromValue = [NSNumber numberWithFloat:scale];
        animationDown.toValue = [NSNumber numberWithFloat:1.0];
        animationDown.removedOnCompletion = NO;
        
        [group setAnimations:@[animationUp, animationDown]];
        [layerAnimation addAnimation:group forKey:@"transform.scale"];
        [self.layer addSublayer:layerAnimation];
        
        [CATransaction commit];
        

    }
    
    beforeRadiusMic = _m_radiusMic;

    
}

#pragma mark - GestureRecognizer

- (void)pin:(UIPinchGestureRecognizer*)recognizer
{
    if ([recognizer numberOfTouches] != 2) return;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"drawViewtouchesBegan" object:nil];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) //핀치가 시작하거나 움직였을시
    {
        static CGPoint touch1, touch2; //각 터치의 델타값
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"drawViewtouchesMoved" object:nil];
        
        touch1 =[recognizer locationOfTouch:0 inView:recognizer.view]; //touch1의 델타위치
        touch2 =[recognizer locationOfTouch:1 inView:recognizer.view]; //touch2의 델타위치
        CGFloat currentDistance = distanceBetweenPoints( touch1, touch2 );
        self.m_radiusMax = currentDistance / 2.0;
        CGFloat width = _m_radiusMax *2;
        _orbit1.bounds = CGRectMake(0, 0, width, width);
        _orbit1.position = self.center;
        _orbit1.cornerRadius = _m_radiusMax;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self OnDraw];
        });

        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"drawViewTouchesEnded" object:nil];
    }
}
@end
