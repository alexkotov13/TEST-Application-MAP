//
//  ViewController.m
//  TEST Application MAP
//
//  Created by admin on 17.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"


CGSize view;

@interface RootViewController ()
{
    UIButton *mapButton;
    UIButton *listButton;
    UIButton *exitButton;
    UIAlertView *alertExit;
}

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Main Menu";
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    [[AppearanceManager shared] customizeRootViewController:self.view];   
    view = self.view.bounds.size;      
    [self drawButton];
    


    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)drawButton
{   
    exitButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.view addSubview:exitButton];
    [exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:exitButton CoordinatesX:0 Y:view.height - 180 Width:view.width Radius:0];
    
     mapButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [mapButton setTitle:@"MAP" forState:UIControlStateNormal];  
    [self.view addSubview:mapButton];
    [mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:mapButton CoordinatesX:view.width / 4 Y:view.height / 4 Width:150 Radius:10];
   
    listButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [listButton setTitle:@"LIST" forState:UIControlStateNormal];
    [self.view addSubview:listButton];
    [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:listButton CoordinatesX:view.width / 4 Y:view.height / 2.5 Width:150 Radius:10];
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
    alertExit = [[UIAlertView alloc] initWithTitle:nameAlert message:0 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alertExit show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == alertExit)
        if (buttonIndex == 0)
            exit(0); 
}





@end
