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

- (void)drawRect:(CGRect)rect
{
    if (!m_draw) return;

//	CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextStrokePath(context);
//    CGFloat red, green, blue, alpha;
//    [_m_ColorCircleLine getRed:&red green:&green blue:&blue alpha:&alpha];
//    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
//    CGContextAddArc(context, self.center.x, self.center.y, _m_radiusMax, 0, 360, 0);
//    
//    CGContextStrokePath(context);
//    [_m_ColorCircleFill getRed:&red green:&green blue:&blue alpha:&alpha];
//    CGContextSetRGBFillColor(context, red, green, blue, alpha);
//    CGContextFillEllipseInRect(context, CGRectMake(self.center.x - _m_radiusMic,
//                                                   self.center.y - _m_radiusMic,
//                                                   _m_radiusMic *2,
//                                                   _m_radiusMic *2));
//
//    CGContextStrokePath(context);
    
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
    
    if (beforeRadiusMic == _m_radiusMic) return;
    
    if (_m_drawModeFull) _m_radiusMic = _m_radiusMax;
    
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
        group.duration = 0.5;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animationUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animationUp.duration = 0.25;
        animationUp.repeatCount = 1;
        animationUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationUp.autoreverses = YES;
        animationUp.fromValue = [NSNumber numberWithFloat:1.0];
        animationUp.toValue = [NSNumber numberWithFloat:scale];
        
        [group setAnimations:@[animationUp]];
        [layerAnimation addAnimation:group forKey:@"transform.scale"];
        [self.layer addSublayer:layerAnimation];
        
        [CATransaction commit];
        
        
//        [UIView animateKeyframesWithDuration:10 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
//            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
//                self.planet1.transform = CATransform3DMakeScale( scale , scale, 1);
//            }];
////            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
////                self.planet1.transform = CATransform3DMakeScale( 5 , 5, 1);
////            }];
//        } completion:^(BOOL finished) {
//        }];
    }
    
    beforeRadiusMic = _m_radiusMic;
//    beforeRadiusMic = 9999999999999;
    
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
