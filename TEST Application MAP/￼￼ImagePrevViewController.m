//
//  ￼￼ImagePrevViewController.m
//  TEST Application MAP
//
//  Created by admin on 24.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "￼￼ImagePrevViewController.h"

@interface ImagePrevViewController()
{
    AVAudioPlayer *_player;
    PointDescription *_info;
    UIBarButtonItem *_playButton;
    UILabel *_timeLabel;
    NSTimer *_playerTimer;
    UIImage *_playButtonImage;
    UIImage *_stopButtonImage;
    UIButton *_button;
    UISlider *_aSlider;
    NSIndexPath *_indexPath;
}
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ImagePrevViewController

- (id)initWithIndexOfObject:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self)
    {
        _indexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFetchedController];
    [self draw];
}

-(void)draw
{
    _playButtonImage = [UIImage imageNamed:@"next.png"];
    _stopButtonImage = [UIImage imageNamed:@"stop.png"];
    
    _info = [_fetchedResultsController objectAtIndexPath:_indexPath];
    self.navigationItem.title = _info.titleForPin;
    UIImageView * backdroundView = [[UIImageView alloc] initWithImage:[_info thumbnail]];
    backdroundView.contentMode = UIViewContentModeScaleAspectFill;
    backdroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:backdroundView];
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    [[AppearanceManager shared] customizeToolbar:self.navigationController.toolbar];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(btnBackClicked:) ];
    self.navigationItem.leftBarButtonItem = backButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    _button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setImage:_playButtonImage forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_button setFrame:CGRectMake(0, 0, 40, 40)];
    _playButton = [[UIBarButtonItem alloc] initWithCustomView:_button ];
    
    CGRect frame = CGRectMake(10, self.view.bounds.size.height / 1.7, self.view.bounds.size.width - 120,0);
    _aSlider = [[UISlider alloc] initWithFrame:frame];
    [_aSlider setBackgroundColor:[UIColor clearColor]];
    _aSlider.minimumValue = 0.0;
    _aSlider.maximumValue = 50.0;
    _aSlider.continuous = YES;
    _aSlider.value = 25.0;
    
    _timeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 2, 50.0, 50.0) ];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem* progressItem = [[UIBarButtonItem alloc] initWithCustomView:_aSlider];
    UIBarButtonItem* time = [[UIBarButtonItem alloc] initWithCustomView:_timeLabel];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:_playButton,progressItem, time, nil];
    [self setToolbarItems:arr animated:YES];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:_info.soundPath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                     error:nil];
    _player.numberOfLoops = 0;
    [_player setDelegate:self];
    _player.meteringEnabled = YES;
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self
                                                  selector:@selector(updateDisplay)
                                                  userInfo:nil
                                                   repeats:YES];
    
}

-(void)setFetchedController
{
    _fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

-(void)updateDisplay
{
    float minutes = floor(_player.currentTime/60);
    float seconds = _player.currentTime - (minutes * 60);
    NSString* timeInfoString = [[NSString alloc]
                                initWithFormat:@"%02.0f:%02.0f",
                                minutes, seconds];
    _timeLabel.text = timeInfoString;
    
    // Update the slider about the music time
    _aSlider.value = _player.currentTime;
}

- (void)sliderChanged:(UISlider *)sender
{
    BOOL flag = NO;
    // Fast skip the music when user scroll the UISlider
    if(_player.isPlaying)
    {
        flag = YES;
    }
    [_player stop];
    [_button setImage:_playButtonImage forState:UIControlStateNormal];
    
    [_player setCurrentTime:_aSlider.value];
    [_player prepareToPlay];
    
    if(flag)
    {
        [_player play];
        [_button setImage:_stopButtonImage forState:UIControlStateNormal];
    }
}

- (void)playButtonTapped:(id)sender
{
    if(!_player.isPlaying)
    {
        [_player prepareToPlay];
        [_player play];
        [_button setImage:_stopButtonImage forState:UIControlStateNormal];
        [_aSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        // Set the maximum value of the UISlider
        _aSlider.maximumValue = _player.duration;
        // Set the valueChanged target
        //[aSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
        [_button setImage:_playButtonImage forState:UIControlStateNormal];
        [_player stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [_button setImage:_playButtonImage forState:UIControlStateNormal];
    // Music completed
    if (flag)
    {
        [_playerTimer invalidate];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

-(void)btnBackClicked:(id)sender
{
    [_player stop];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
