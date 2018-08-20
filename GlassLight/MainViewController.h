//
//  MainViewController.h
//  GlassLight
//
//  Created by 박길호 on 14. 3. 11..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicInputViewController.h"
#import "ColorPickerImageView.h"
#import "CircleViewController.h"
#import "ShinyViewController.h"
#import "SmoothViewController.h"

typedef enum {
    ViewModeMic = 0,
    ViewModeCircle,
    ViewModeShiny,
    ViewModeSmooth
} ViewMode;

@interface MainViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate, ColorPickerImageViewDelegate>
{
    MicInputViewController *m_micInputViewController;
    CircleViewController *m_circleViewController;
    ShinyViewController *m_shinyViewController;
    SmoothViewController *m_smoothViewController;
    
    ViewMode m_viewMode;
}
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet ColorPickerImageView *m_colorPickerImageView; //색 조정 뷰
@end
