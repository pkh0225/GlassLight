//
//  ViewController.m
//  GlassLight
//
//  Created by 박길호 on 14. 3. 4..
//  Copyright (c) 2014년 박길호. All rights reserved.
//

#import "MicInputViewController.h"
#import "DrawView.h"
#import "CGPointUtils.h"
#import <AVFoundation/AVFoundation.h>

#define kLevelMax 5000
#define kMajin 50


@interface MicInputViewController ()
{
    
}
@end

@implementation MicInputViewController

@synthesize recordOrStopButton;
@synthesize audioProcessor;


- (void)viewDidLoad
{
    [super viewDidLoad];
    m_flashMode = YES;
    m_perLevel = 0;
    recording = NO;
    _m_drawView.m_radiusMax = 150;

    
    _m_micVol.transform = CGAffineTransformMakeRotation(M_PI / -2 );
    _m_micVol.frame = CGRectMake(10, 10, CGRectGetWidth(_m_micVol.frame), CGRectGetHeight(_m_micVol.frame));
    [self recordOrStop:recordOrStopButton];
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
#pragma mark - UIAction
/**
 *  마이크 입력 시작 과 종료
 *
 *  @param sender 버튼
 */
- (IBAction)recordOrStop: (id) sender {
    if (recording)
        [self micOFF];
    else
        [self micON];

    
}
/**
 *  마이크 볼룸 조정
 *
 *  @param sender 슬라이드바
 */
- (IBAction)onSliderValueChanged:(id)sender {
    if (audioProcessor == nil) return;
    [audioProcessor setGain: _m_micVol.value];
//    NSLog(@"_m_micVol.value = %f", _m_micVol.value);
    
}
/**
 *  플래시 모드 켜기 끄기
 *
 *  @param sender 버튼
 */
- (IBAction)onFlashOnOff:(id)sender {
    if (m_flashMode)
    {
        m_flashMode = NO;
        [_m_btnFlash setTitle: @"Flash On" forState: UIControlStateNormal];
        [_m_btnFlash setTitle: @"Flash On" forState: UIControlStateHighlighted];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        if ([device hasTorch] && [device hasFlash]){
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOn];
            
        }
    }
    else
    {
        m_flashMode = YES;
        [_m_btnFlash setTitle: @"Flash Off" forState: UIControlStateNormal];
        [_m_btnFlash setTitle: @"Flash Off" forState: UIControlStateHighlighted];
        
    }
}

#pragma mark - Custom Funtion
- (void)micON
{
        recording = YES;
        [recordOrStopButton setTitle: @"Stop" forState:UIControlStateNormal];
        [recordOrStopButton setTitle: @"Stop" forState:UIControlStateHighlighted];
        if (audioProcessor == nil) {
            audioProcessor = [[AudioProcessor alloc] init];
            audioProcessor.delegate = self;
        }
        [audioProcessor start];
}

- (void)micOFF
{
    
    recording = NO;
    [recordOrStopButton setTitle: @"Start" forState: UIControlStateNormal];
    [recordOrStopButton setTitle: @"Start" forState: UIControlStateHighlighted];
    [audioProcessor stop];
    
    
}
/**
 *  플래쉬 껐다가 껐다가
 */
- (void)flashOnOff
{
    if (!m_flashMode) return;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasTorch] && [device hasFlash]){
        if (device.torchMode == AVCaptureTorchModeOff){
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOn];
        }
    } else
    {
        m_flashMode = NO;
        [_m_btnFlash setTitle: @"Flash On" forState: UIControlStateNormal];
        [_m_btnFlash setTitle: @"Flash On" forState: UIControlStateHighlighted];
        _m_btnFlash.enabled = NO;
        UIAlertView *noflash = [[UIAlertView alloc]initWithTitle:@"플래쉬가 없습니다" message:@"기기에 플래쉬가 없어 이 기능을 사용할 수 없습니다" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [noflash show];
    }
    
    
}

#pragma mark - AudioProcessorDelegate
/**
 *  마이크에서 들어오는 데이타
 *
 *  @param data 소리데이타
 */
-(void)audioBuffer:(SInt16)data
{
    SInt16 level = data;
    if (level > kLevelMax) {
        level = kLevelMax;
    }
    //    NSLog(@"level = %d", level);
    if ((m_perLevel - level < kMajin) && (m_perLevel - level > -kMajin))
    {
        //        NSLog(@"Majin 보다 작다.");
        return;
    }
    m_perLevel = level;
    _m_drawView.m_radiusMic = _m_drawView.m_radiusMax * level / kLevelMax;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_m_drawView OnDraw];
        [self flashOnOff];
    });
    
}



@end
