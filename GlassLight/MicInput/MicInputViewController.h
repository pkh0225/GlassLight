//
//  MicInputViewController.h
//  GlassLight
//
//  Created by 박길호 on 14. 3. 11..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "AudioProcessor.h"


@interface MicInputViewController : UIViewController<AudioProcessorDelegate>
{
    BOOL recording;         //소리 데이타 입력중인지 아닌지
    CGFloat m_perLevel;     //이전 소리 데이타
    BOOL m_flashMode;       //플래쉬 모드

}

@property (weak, nonatomic) IBOutlet DrawView *m_drawView;          //실제 원그림을 그리는 뷰
@property (weak, nonatomic) IBOutlet UIButton *recordOrStopButton;  //시작 버튼
@property (weak, nonatomic) IBOutlet UISlider *m_micVol;            //마이크 볼룸 조정
@property (strong, nonatomic) AudioProcessor *audioProcessor;       //마이크 소리 Input
@property (weak, nonatomic) IBOutlet UIButton *m_btnFlash;          //플래쉬 모드 버튼

- (IBAction)recordOrStop: (id) sender;
- (IBAction)onSliderValueChanged:(id)sender;
- (IBAction)onFlashOnOff:(id)sender;

- (void)micON;
- (void)micOFF;
@end
