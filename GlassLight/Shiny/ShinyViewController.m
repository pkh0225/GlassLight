//
//  ShinyViewController.m
//  GlassLight
//
//  Created by 박길호 on 14. 3. 11..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import "ShinyViewController.h"

@interface ShinyViewController ()
{
    CGFloat m_Vol;
    NSTimer *m_timer;
    NSArray *m_colors;
    NSInteger m_index;
}
@end

@implementation ShinyViewController

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
- (IBAction)onShinyVolChanged:(id)sender {
    NSLog(@"ShinyVol = %f", ((UISlider*)sender).value);
    [self drawOFF];
    [self drawON];
}

- (void)colorChange
{
    m_index++;
    if (m_index > [m_colors count]-1 ) {
        m_index = 0;
    }
    _m_drawView.m_ColorCircleFill = (UIColor*)[m_colors objectAtIndex:m_index];
    _m_drawView.m_ColorCircleLine = (UIColor*)[m_colors objectAtIndex:m_index];
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
