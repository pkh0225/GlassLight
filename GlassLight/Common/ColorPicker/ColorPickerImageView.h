//
//  ColorPickerImageView.h
//  ColorPicker
//
//  Created by markj on 3/6/09.
//  Copyright 2009 Mark Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerImageViewDelegate;

@interface ColorPickerImageView : UIImageView {
	UIColor* lastColor;
}

@property (nonatomic, retain) UIColor* lastColor;
@property (nonatomic, retain) id<ColorPickerImageViewDelegate> delegate;


- (UIColor*) getPixelColorAtLocation:(CGPoint)point;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;


@end


@protocol ColorPickerImageViewDelegate <NSObject>

@optional
- (void)pickedColor:(UIColor*)color;

@end
