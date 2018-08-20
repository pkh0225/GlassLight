//
//  DrawView.h
//  CalCircle
//
//  Created by hyeoncheol yi on 12. 5. 30..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
{
    BOOL m_draw;
    BOOL m_Touching;
}
@property(assign, nonatomic) CGFloat m_radiusMax;
@property(strong, nonatomic) UIColor *m_ColorCircleLine;
@property(strong, nonatomic) UIColor *m_ColorCircleFill;
@property(assign, nonatomic) CGFloat m_radiusMic;
@property(assign, nonatomic) BOOL m_drawModeFull;

-(void)OnDraw;

@end
