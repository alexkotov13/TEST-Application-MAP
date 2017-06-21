//
//  ViewController.m
//  TEST Application MAP
//
//  Created by admin on 17.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController ()
{
    CGSize _view;
    UIButton *_mapButton;
    UIButton *_listButton;
    UIButton *_exitButton;
    UIAlertView *_alertExit;
}
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _view = self.view.bounds.size;
    [self drawButtonAndCostumase];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)drawButtonAndCostumase
{
    self.navigationItem.title = @"Main Menu";
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    [[AppearanceManager shared] customizeRootViewController:self.view];
    
    _exitButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.view addSubview:_exitButton];
    [_exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_exitButton CoordinatesX:0 Y:_view.height - 180 Width:_view.width Radius:0];
    
    _mapButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_mapButton setTitle:@"MAP" forState:UIControlStateNormal];
    [self.view addSubview:_mapButton];
    [_mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_mapButton CoordinatesX:_view.width / 4 Y:_view.height / 4 Width:150 Radius:10];
    
    _listButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_listButton setTitle:@"LIST" forState:UIControlStateNormal];
    [self.view addSubview:_listButton];
    [_listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_listButton CoordinatesX:_view.width / 4 Y:_view.height / 2.5 Width:150 Radius:10];
}

-(void)mapButtonClick:(id)sender
{
    MapViewController* mapController = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapController animated:YES];
}

-(void)listButtonClick:(id)sender
{
    ListViewController* mapController = [[ListViewController alloc]init];
    [self.navigationController pushViewController:mapController animated:YES];
}

-(void)exitButtonClick:(id)sender
{
    NSString *nameAlert = @"Exit";
    _alertExit = [[UIAlertView alloc] initWithTitle:nameAlert message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [_alertExit show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == _alertExit)
        if (buttonIndex == 0)
            exit(0);
}

@end