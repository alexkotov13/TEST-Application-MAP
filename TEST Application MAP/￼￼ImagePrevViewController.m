//
//  ￼￼ImagePrevViewController.m
//  TEST Application MAP
//
//  Created by admin on 24.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "￼￼ImagePrevViewController.h"

UIImage *pickedImage;
UIBarButtonItem *playButton;
UILabel *_timeLabel;
NSTimer *playerTimer;
UIImage *playButtonImage;
UIImage *stopButtonImage;
UIButton *button;
UISlider *aSlider;

@interface ImagePrevViewController()
{
    AVAudioPlayer *player;
}

@end

@implementation ImagePrevViewController

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        pickedImage = image;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"List";    
    playButtonImage = [UIImage imageNamed:@"next.png"];
    stopButtonImage = [UIImage imageNamed:@"stop.png"];    

    UIImageView * backdroundView = [[UIImageView alloc] initWithImage:pickedImage];
    backdroundView.contentMode = UIViewContentModeScaleAspectFill;
    backdroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:backdroundView];
    
    
    //[[AppearanceManager shared] customizeRootViewController:self.view];
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    [[AppearanceManager shared] customizeToolbar:self.navigationController.toolbar];
   //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"-NQXlkeTSf0.jpg"]];
  //[[AppearanceManager shared] customizeRootViewController:self.view];
    //bottom navigationItemelf.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sfond-appz.png"]];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(btnBackClicked:) ];
    self.navigationItem.leftBarButtonItem = backButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:playButtonImage forState:UIControlStateNormal];    
    [button addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];    
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    playButton = [[UIBarButtonItem alloc] initWithCustomView:button ];     
        
    CGRect frame = CGRectMake(10, self.view.bounds.size.height / 1.7, self.view.bounds.size.width - 120,0);
    aSlider = [[UISlider alloc] initWithFrame:frame];   
    [aSlider setBackgroundColor:[UIColor clearColor]];
    aSlider.minimumValue = 0.0;
    aSlider.maximumValue = 50.0;
    aSlider.continuous = YES;
    aSlider.value = 25.0;
    
    _timeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 2, 50.0, 50.0) ];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem* progressItem = [[UIBarButtonItem alloc] initWithCustomView:aSlider];
    UIBarButtonItem* time = [[UIBarButtonItem alloc] initWithCustomView:_timeLabel];
    
    //UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:playButton,progressItem, time, nil];
    [self setToolbarItems:arr animated:YES];
    
    

    
    
    
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"2016-02-24 16:06:58 +0000"                                                              ofType:@"caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                          error:nil];
    player.numberOfLoops = 0;
    [player setDelegate:self];   
    player.meteringEnabled = YES;
    
    playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                     target:self
                                                   selector:@selector(updateDisplay)
                                                   userInfo:nil
                                                    repeats:YES];
    
   

    


}

-(void)updateDisplay
{
    float minutes = floor(player.currentTime/60);
    float seconds = player.currentTime - (minutes * 60);
    NSString* timeInfoString = [[NSString alloc]
                                initWithFormat:@"%02.0f:%02.0f",
                                minutes, seconds];
    _timeLabel.text = timeInfoString;   

    // Update the slider about the music time
    aSlider.value = player.currentTime;
}

- (void)sliderChanged:(UISlider *)sender
{
    BOOL flag = NO;
    // Fast skip the music when user scroll the UISlider
    if(player.isPlaying)
    {
        flag = YES;
    }
    [player stop];
    [button setImage:playButtonImage forState:UIControlStateNormal];
    
    [player setCurrentTime:aSlider.value];
    [player prepareToPlay];
    
    if(flag)
    {
        [player play];
        [button setImage:stopButtonImage forState:UIControlStateNormal];
    }
}

- (void)playButtonTapped:(id)sender
{
    if(!player.isPlaying)
    {
        [player prepareToPlay];
        [player play];      
        [button setImage:stopButtonImage forState:UIControlStateNormal];
        [aSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        // Set the maximum value of the UISlider
        aSlider.maximumValue = player.duration;
        // Set the valueChanged target
        //[aSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
        [button setImage:playButtonImage forState:UIControlStateNormal];        
        [player stop];
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
    [button setImage:playButtonImage forState:UIControlStateNormal];
    // Music completed
    if (flag)
    {
        [playerTimer invalidate];
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
    ListViewController *listViewController  = [[ListViewController alloc]init];
    [self.navigationController pushViewController:listViewController animated:YES];
}









@end
