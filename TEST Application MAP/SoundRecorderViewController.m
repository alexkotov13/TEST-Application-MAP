//
//  SoundRecorderViewController.m
//  TEST Application MAP
//
//  Created by admin on 22.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "SoundRecorderViewController.h"
UIAlertView *alert;
NSTimer *recorderTimer;
UIBarButtonItem *stopButton;
UIBarButtonItem *recordPauseButton;
UILabel *_timeLabel;
UIProgressView *_progress;
NSString *_recorderFilePath;

BOOL playStop;

@interface SoundRecorderViewController ()
{
AVAudioRecorder *recorder;
AVAudioPlayer *player;
}
@end

@implementation SoundRecorderViewController



- (void)viewDidLoad
{
    [super viewDidLoad];   
      
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    [[AppearanceManager shared] customizeRootViewController:self.view];
    
    //bottom navigationItem
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(btnBackClicked:) ];
    self.navigationItem.leftBarButtonItem = backButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIBarButtonItem *btnNext = [[UIBarButtonItem alloc]
                                initWithTitle:@"Next"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(btnNextClicked:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.rightBarButtonItem];
    
    
    stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered  target:self action:@selector(stopButtonTapped:)];
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:stopButton];
     [ stopButton  setEnabled:NO];
    
    recordPauseButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered  target:self action:@selector(recordPauseTapped:)];
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:recordPauseButton];
          
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:stopButton,flexibleSpace,recordPauseButton, nil];
    [self setToolbarItems:arr animated:YES];
    
    _timeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 2, 150.0, 50.0) ];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_timeLabel];
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height / 1.7, self.view.bounds.size.width - 20, 50)];
    [self.view addSubview:_progress];
    
    // Setup audio session
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSDate* now = [NSDate date];
    NSString* caldate = [now description];
    _recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [self documentsDicrectory], caldate];
    [[ArrayData shared].sound addObject:_recorderFilePath];
    NSURL *URL = [NSURL fileURLWithPath:_recorderFilePath];
    NSError* err = nil;
    recorder = [[AVAudioRecorder alloc]
                initWithURL:URL settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC)}
                error:&err];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    recorderTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(updateDisplay)
                                                   userInfo:nil
                                                    repeats:YES];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}



-(void)btnNextClicked:(id)sender
{   
    alert = [[UIAlertView alloc] initWithTitle:@"Saved !" message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)btnBackClicked:(id)sender
{
    PickerViewController *pickerViewController  = [[PickerViewController alloc]init];
    [self.navigationController pushViewController:pickerViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == alert)
        if (buttonIndex == 0)
        {
            MapViewController *mapViewController = [[MapViewController alloc]init];
            [self.navigationController pushViewController:mapViewController animated:YES];
        }
}




- (void)stopButtonTapped:(id)sender
{
    [recorder stop];    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}


//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [recordPauseButton setTitle:@"Record"];
    
    [stopButton setEnabled:NO];
    //[playButton setEnabled:YES];
}

- (void)recordPauseTapped:(id)sender
{    
    if (!recorder.recording)
    {       
        [recorder record];        
        // Start recording       
        [recordPauseButton setTitle:@"Pause"];
        
    }
    else
    {        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" ];
    }    
    [stopButton setEnabled:YES];

}

- (NSString *)documentsDicrectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

-(void)updateDisplay
{
    float minutes = floor(recorder.currentTime/60);
    float seconds = recorder.currentTime - (minutes * 60);
    NSString* timeInfoString = [[NSString alloc]
                                initWithFormat:@"%02.0f:%02.0f",
                                minutes, seconds];
    _timeLabel.text = timeInfoString;
    [recorder updateMeters];
    float dBLevel = [recorder averagePowerForChannel:0];
    dBLevel = 1 - fabsf(dBLevel) / 100;
    [_progress setProgress:dBLevel animated:YES];
    
}



@end
