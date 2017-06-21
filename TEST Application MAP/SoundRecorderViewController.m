//
//  SoundRecorderViewController.m
//  TEST Application MAP
//
//  Created by admin on 22.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "SoundRecorderViewController.h"



@interface SoundRecorderViewController ()
{
    BOOL playStop;
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
    UIAlertView *_alert;
    NSTimer *_recorderTimer;
    UIBarButtonItem *_stopButton;
    UIBarButtonItem *_recordPauseButton;
    UILabel *_timeLabel;
    UIProgressView *_progress;
    NSString *_recorderFilePath;
}
@property(nonatomic) PointDescription* pinDescriptionEntity;
@end

@implementation SoundRecorderViewController

-(id)initWithPointDescription:(PointDescription*) pointDescription
{
    self = [super init];
    if(self)
    {
        _pinDescriptionEntity = pointDescription;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

-(void)drawButton
{
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
    
    
    _stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered  target:self action:@selector(stopButtonTapped:)];
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:_stopButton];
    [_stopButton  setEnabled:NO];
    
    _recordPauseButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered  target:self action:@selector(recordPauseTapped:)];
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:_recordPauseButton];
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:_stopButton,flexibleSpace,_recordPauseButton, nil];
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
    NSURL *URL = [NSURL fileURLWithPath:_recorderFilePath];
    NSError* err = nil;
    _recorder = [[AVAudioRecorder alloc]
                 initWithURL:URL settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC)}
                 error:&err];
    [_recorder setDelegate:self];
    //[recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    _recorderTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(updateDisplay)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (NSString *)documentsDicrectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(void)btnNextClicked:(id)sender
{
    _alert = [[UIAlertView alloc] initWithTitle:@"Saved !" message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [_alert show];
}

-(void)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSError* error = nil;
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedInstance] subContext];
    [managedObjectContext save:&error];
    [[CoreDataManager sharedInstance] saveContext];
    
    if(alertView == _alert)
        if (buttonIndex == 0)
        {
            MapViewController *mapViewController = [[MapViewController alloc]init];
            [self.navigationController pushViewController:mapViewController animated:YES];
        }
}

- (void)stopButtonTapped:(id)sender
{
    [_recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    _pinDescriptionEntity.soundPath = _recorderFilePath;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [_recordPauseButton setTitle:@"Record"];
    [_stopButton setEnabled:NO];
    //[playButton setEnabled:YES];
}

- (void)recordPauseTapped:(id)sender
{
    if (!_recorder.recording)
    {
        [_recorder record];
        // Start recording
        [_recordPauseButton setTitle:@"Pause"];
        
    }
    else
    {
        // Pause recording
        [_recorder pause];
        [_recordPauseButton setTitle:@"Record" ];
    }
    [_stopButton setEnabled:YES];
    
}

-(void)updateDisplay
{
    float minutes = floor(_recorder.currentTime/60);
    float seconds = _recorder.currentTime - (minutes * 60);
    NSString* timeInfoString = [[NSString alloc]
                                initWithFormat:@"%02.0f:%02.0f",
                                minutes, seconds];
    _timeLabel.text = timeInfoString;
    [_recorder updateMeters];
    float dBLevel = [_recorder averagePowerForChannel:0];
    dBLevel = 1 - fabsf(dBLevel) / 100;
    [_progress setProgress:dBLevel animated:YES];
}

@end
