//
//  PickerViewController.m
//  TEST Application MAP
//
//  Created by admin on 22.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "PickerViewController.h"

CGSize view;
UIImage *pickedImage;
UIAlertView *alert;

@interface PickerViewController ()

@end

@implementation PickerViewController

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
    
    self.navigationItem.title = @"";
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:pickedImage];
    UIImageView * backdroundView = [[UIImageView alloc] initWithImage:pickedImage];
    backdroundView.contentMode = UIViewContentModeScaleAspectFill;
    backdroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:backdroundView];  
    
    [[ArrayData shared].photo addObject:pickedImage];
    
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
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(view.width/4-20, view.height/4, 200.0, 40.0)];
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.font = [UIFont systemFontOfSize:15];
    text.placeholder = @"Enter text";
    text.autocorrectionType = UITextAutocorrectionTypeNo;
    text.keyboardType = UIKeyboardTypeDefault;
    text.returnKeyType = UIReturnKeyDone;
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.delegate = self;
    text.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:text];   
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)btnNextClicked:(id)sender
{
    SoundRecorderViewController *soundRecorderViewController = [[SoundRecorderViewController alloc]init];
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
            SoundRecorderViewController *soundRecorderViewController = [[SoundRecorderViewController alloc]init];
            [self.navigationController pushViewController:soundRecorderViewController animated:YES];
        }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{    
    alert = [[UIAlertView alloc] initWithTitle:@"Saved !" message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];   
    [[ArrayData shared].textTitle addObject:textField.text];
    return YES;
}

@end
