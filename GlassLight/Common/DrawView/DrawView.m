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
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. sqrt()
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
    for (CALayer *layer in [self.layer sublayers]) {
        [layer removeFromSuperlayer];
    }
    
    if (_m_drawModeFull) _m_radiusMic = _m_radiusMax;
    
    CALayer *orbit1 = [CALayer layer];
    CGFloat width = _m_radiusMax *2;
    orbit1.bounds = CGRectMake(0, 0, width, width);
    orbit1.position = self.center;
    orbit1.cornerRadius = _m_radiusMax;
    orbit1.borderColor = _m_ColorCircleLine.CGColor;
    orbit1.borderWidth = 1.5;
    
    
    CALayer *planet1 = [CALayer layer];
    width = _m_radiusMic *2;
    planet1.bounds = CGRectMake(0, 0, width, width);
    CGFloat positoin = CGRectGetWidth(orbit1.bounds) / 2.0;
    planet1.position = CGPointMake(positoin, positoin);
    planet1.cornerRadius = _m_radiusMic;
    planet1.backgroundColor = _m_ColorCircleFill.CGColor;
    [orbit1 addSublayer:planet1];
    
    [self.layer addSublayer:orbit1];
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
