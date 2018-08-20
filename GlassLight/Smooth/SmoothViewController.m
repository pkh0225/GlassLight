//
//  SmoothViewController.m
//  GlassLight
//
//  Created by 박길호 on 14. 3. 11..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import "SmoothViewController.h"

@interface SmoothViewController ()
{
    CGFloat m_Vol;
    NSTimer *m_timer;
    NSArray *m_colors;
    NSInteger m_index;
    
    CGFloat m_red;
    CGFloat m_green;
    CGFloat m_blue;
}
@end

@implementation SmoothViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _m_drawView.m_radiusMax = 150;
    _m_drawView.m_drawModeFull = YES;
    _m_shinyVol.transform = CGAffineTransformMakeRotation(M_PI / -2 );
    _m_shinyVol.frame = CGRectMake(10, 10, CGRectGetWidth(_m_shinyVol.frame), CGRectGetHeight(_m_shinyVol.frame));
    
    UIColor *Red = RGBA(255, 0, 0, 1);
    UIColor *Orange = RGBA(255, 127, 0, 1);
    UIColor *Yellow = RGBA(255, 255, 0, 1);
    UIColor *Green = RGBA(0, 255, 0, 1);
    UIColor *Blue = RGBA(0, 0, 255, 1);
    UIColor *Indigo = RGBA(75, 0, 130, 1);
    UIColor *Violet = RGBA(143, 0, 255, 1);
    m_colors = @[Red, Orange, Yellow, Green, Blue, Indigo, Violet];
    
    m_index = 0;
    
    m_red = 255;
    m_green = 0;
    m_blue = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [_m_drawView OnDraw];
}
- (IBAction)onSmoothVolChanged:(id)sender {
    NSLog(@"SmoothVol = %f", ((UISlider*)sender).value);
    [self drawOFF];
    [self drawON];
}

- (void)colorChange
{
//    m_index++;
//    if (m_index > [m_colors count]-1 ) {
//        m_index = 0;
//    }

    switch (m_index) {
        case 0:// 빨강
        {
            m_green++;
            break;
        }
        case 1:// 주황
        {
            m_green++;
            break;
        }
        case 2:// 노랑
        {
            m_red--;
            break;
        }
        case 3:// 초록
        {
            m_green--;
            m_blue++;
            break;
        }
        case 4:// 파랑
        {
            m_red++;
            m_blue--;
            break;
        }
        case 5:// 남색
        {
            m_red++;
            m_blue++;
            break;
        }
        case 6:// 보라
        {
            m_red++;
            m_blue--;
            break;
        }

        default:
            break;
    }
    
    
    
    if (m_red == 255 && m_green == 0 && m_blue == 0) {
        m_index = 0;
    }
    else if (m_red == 255 && m_green == 127 && m_blue == 0) {
        m_index = 1;
    }
    else if (m_red == 255 && m_green == 255 && m_blue == 0) {
        m_index = 2;
    }
    else if (m_red == 0 && m_green == 255 && m_blue == 0) {
        m_index = 3;
    }
    else if (m_red == 0 && m_green == 0 && m_blue == 255) {
       m_index = 4;
    }
    else if (m_red == 75 && m_green == 0 && m_blue == 130) {
        m_index = 5;
    }
    else if (m_red == 143 && m_green == 0 && m_blue == 255) {
        m_index = 6;
    }

//    NSLog(@"red = %f, green = %f, blue = %f", m_red, m_green, m_blue);
    UIColor *color = RGBA(m_red, m_green, m_blue, 1);
    _m_drawView.m_ColorCircleFill = color;
    _m_drawView.m_ColorCircleLine = color;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_m_drawView OnDraw];
    });
}

- (void)drawON
{
    m_timer = [NSTimer scheduledTimerWithTimeInterval:_m_shinyVol.value
                                               target:self
                                             selector:@selector(colorChange)
                                             userInfo:nil
                                              repeats:YES];
}
- (void)drawOFF
{
    [m_timer invalidate];
}

@end
