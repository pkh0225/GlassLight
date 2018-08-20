//
//  SmoothViewController.h
//  GlassLight
//
//  Created by 박길호 on 14. 3. 11..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface SmoothViewController : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet DrawView *m_drawView;          //실제 원그림을 그리는 뷰
@property (weak, nonatomic) IBOutlet UISlider *m_shinyVol;

- (IBAction)onSmoothVolChanged:(id)sender;


- (void)drawON;
- (void)drawOFF;

@end
