//
//  PickerViewController.m
//  TEST Application MAP
//
//  Created by admin on 22.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()
{
    CGSize view;
    UIImage *_pickedImage;
    UIAlertView *alert;
   PointDescription *_pointDescription;
    UITextField* _text;
}

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation PickerViewController

- (id)initWithImage:(UIImage *)image initWithPointDescription:(PointDescription*) pointDescription
{
    self = [super init];
    if (self)
    {
        _pointDescription = pointDescription;
        _pickedImage = image;
    }
    return self;    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    [self setFetchedController];

    UIImageView * backdroundView = [[UIImageView alloc] initWithImage:_pickedImage];
    backdroundView.contentMode = UIViewContentModeScaleAspectFill;
    backdroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:backdroundView];    
    
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    
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
    
    view = self.view.bounds.size;
    _text = [[UITextField alloc] initWithFrame:CGRectMake(view.width/4-20, view.height/3, 200.0, 40.0)];
    _text.borderStyle = UITextBorderStyleRoundedRect;
    _text.font = [UIFont systemFontOfSize:15];
    _text.placeholder = @"Enter text";
    _text.autocorrectionType = UITextAutocorrectionTypeNo;
    _text.keyboardType = UIKeyboardTypeDefault;
    _text.returnKeyType = UIReturnKeyDone;
    _text.clearButtonMode = UITextFieldViewModeWhileEditing;
    _text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _text.delegate = self;
    _text.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:_text];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
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

-(void)btnNextClicked:(id)sender
{
    _pointDescription.titleForPin = _text.text;
    [[CoreDataManager sharedInstance] saveContext];
    SoundRecorderViewController *soundRecorderViewController = [[SoundRecorderViewController alloc]initWithPointDescription:_pointDescription];
    [self.navigationController pushViewController:soundRecorderViewController animated:YES];
}

-(void)btnBackClicked:(id)sender
{
    MapViewController *mapViewController = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapViewController animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == alert)
        if (buttonIndex == 0)
        {
            _pointDescription.titleForPin = _text.text;
            [[CoreDataManager sharedInstance] saveContext];
            SoundRecorderViewController *soundRecorderViewController = [[SoundRecorderViewController alloc]initWithPointDescription:_pointDescription];
            [self.navigationController pushViewController:soundRecorderViewController animated:YES];
        }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{    
    alert = [[UIAlertView alloc] initWithTitle:@"Saved !" message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];   
    return YES;
}

@end
