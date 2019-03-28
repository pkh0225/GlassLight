//
//  MainViewController.m
//  GlassLight
//
//  Created by 박길호 on 14. 3. 11..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_viewMode = ViewModeMic;
    
    
    m_micInputViewController = [[MicInputViewController alloc] initWithNibName:@"MicInputViewController" bundle:nil];
    [_m_scrollView addSubview:m_micInputViewController.view];
    
    m_circleViewController = [[CircleViewController alloc] initWithNibName:@"CircleViewController" bundle:nil];
    [_m_scrollView addSubview:m_circleViewController.view];
    
    m_shinyViewController = [[ShinyViewController alloc] initWithNibName:@"ShinyViewController" bundle:nil];
    [_m_scrollView addSubview:m_shinyViewController.view];
    
    
    m_smoothViewController = [[SmoothViewController alloc] initWithNibName:@"SmoothViewController" bundle:nil];
    [_m_scrollView addSubview:m_smoothViewController.view];
    
    
    [self animateColorWheelToShow:NO duration:0];
    _m_colorPickerImageView.delegate = self;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [m_micInputViewController.m_drawView addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGestureRecognizer2.delegate = (id<UIGestureRecognizerDelegate>)self;
    [m_circleViewController.m_drawView addGestureRecognizer:tapGestureRecognizer2];
    
    //    [self SetNotification];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    m_micInputViewController.view.frame = CGRectMake(0, 0, _m_scrollView.bounds.size.width, _m_scrollView.bounds.size.height);
    m_circleViewController.view.frame = CGRectMake(_m_scrollView.bounds.size.width, 0, _m_scrollView.bounds.size.width, _m_scrollView.bounds.size.height);
    m_shinyViewController.view.frame = CGRectMake(_m_scrollView.bounds.size.width * 2, 0, _m_scrollView.bounds.size.width, _m_scrollView.bounds.size.height);
    m_smoothViewController.view.frame = CGRectMake(_m_scrollView.bounds.size.width * 3, 0, _m_scrollView.bounds.size.width, _m_scrollView.bounds.size.height);
    
    _m_scrollView.contentSize = CGSizeMake(_m_scrollView.bounds.size.width * 4, _m_scrollView.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
- (void)SetNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawViewTouchesBegan:)
                                                 name:@"drawViewtouchesBegan"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawViewtouchesMoved:)
                                                 name:@"drawViewtouchesMoved"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawViewTouchesEnded:)
                                                 name:@"drawViewTouchesEnded"
                                               object:nil];
}

- (void)drawViewTouchesBegan:(NSNotification*)note
{
    //    NSLog(@"drawViewTouchesBegan");
    _m_scrollView.scrollEnabled = NO;
}

- (void)drawViewtouchesMoved:(NSNotification*)note
{
    //    NSLog(@"drawViewtouchesMoved");
    _m_scrollView.scrollEnabled = NO;
}

- (void)drawViewTouchesEnded:(NSNotification*)note
{
    //    NSLog(@"drawViewTouchesEnded");
    _m_scrollView.scrollEnabled = YES;
}
/**
 *  색 선택할 수 있는 colorPickerImageView
 *
 *  @param show     보이기:YES,  숨기기:NO
 *  @param duration 애니메이션 시간
 */
- (void)animateColorWheelToShow:(BOOL)show duration:(NSTimeInterval)duration {
    if (show==NO) {
        _m_colorPickerImageView.hidden=YES;
    } else {
        _m_colorPickerImageView.hidden=NO;
        
        _m_colorPickerImageView.transform = CGAffineTransformScale(_m_colorPickerImageView.transform , 0.01, 0.01);
        [UIView animateWithDuration:duration animations:^{
            _m_colorPickerImageView.transform = CGAffineTransformScale(_m_colorPickerImageView.transform , 100, 100);
        }];
        
    }
}

#pragma mark - GestureRecognizers
/**
 *  UITapGestureRecognizer 이벤트
 *
 *  @param gesture 제스쳐 데이타
 */
- (void)tap:(UITapGestureRecognizer*)gesture
{
    [self animateColorWheelToShow:YES duration:0.3];
}


#pragma mark - ColorPickerImageView
/**
 *  색 선택 후 선택된 색을 전달 받는다.
 *
 *  @param color 선택한 color
 */
- (void)pickedColor:(UIColor*)color
{
    switch (m_viewMode) {
        case ViewModeMic:
        {
            m_micInputViewController.m_drawView.m_ColorCircleFill = color;
            m_micInputViewController.m_drawView.m_ColorCircleLine = color;
            [m_micInputViewController.m_drawView OnDraw];
            [self animateColorWheelToShow:NO duration:0.3];
            break;
        }
        case ViewModeCircle:
        {
            m_circleViewController.m_drawView.m_ColorCircleFill = color;
            m_circleViewController.m_drawView.m_ColorCircleLine = color;
            [m_circleViewController.m_drawView OnDraw];
            [self animateColorWheelToShow:NO duration:0.3];
            break;
        }
        case ViewModeShiny:
        {
            break;
        }
            
        default:
            break;
    }
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSInteger pn =  scrollView.contentOffset.x / width;
    
    m_viewMode = pn;
    if (m_viewMode == ViewModeMic)
        [m_micInputViewController micON];
    else
        [m_micInputViewController micOFF];
    
    if (m_viewMode == ViewModeShiny)
        [m_shinyViewController drawON];
    else
        [m_shinyViewController drawOFF];
    
    if (m_viewMode == ViewModeSmooth)
        [m_smoothViewController drawON];
    else
        [m_smoothViewController drawOFF];
    
}


@end
