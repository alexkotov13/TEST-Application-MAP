//
//  MyClassViewController.m
//  TEST Application MAP
//
//  Created by admin on 17.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "MapViewController.h"
#import "RootViewController.h"
#import "CameraViewController.h"
#import <MapKit/MKAnnotationView.h>

@implementation MapViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];   
    
    self.navigationItem.title = @"MAP"; 
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
     
    mapView = [[MKMapView alloc]
                          initWithFrame:CGRectMake(0, 0,
                                                   self.view.bounds.size.width,
                                                   self.view.bounds.size.height)];  
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;    
    [self.view addSubview:mapView];   
    [self mapView:mapView];    
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
    [self handleLongPress];  //Pins for tours creation    
   
    
    //bottom toolbar
    self.navigationController.toolbarHidden = NO;
    
    [[AppearanceManager shared] customizeToolbar:self.navigationController.toolbar];
    
     UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * mapTypeButton = [[UIBarButtonItem alloc] initWithTitle:@"MAP type"
                                     style:UIBarButtonItemStyleBordered
                                     target:self action:@selector(changeMapType:)];
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:flexibleSpace,mapTypeButton,flexibleSpace, nil];
    [self setToolbarItems:arr animated:YES];
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:mapTypeButton]; 
    
    [self mapAnnotation];

   


  
    
}



-(void)mapAnnotation
{
    MapAnnotation *to = [[MapAnnotation alloc]init];
    for(int index = 0; index < [[ArrayData shared].mapAnnotation count];index++)
    {        
         to = [[ArrayData shared].mapAnnotation objectAtIndex:index];
         to.title = [[ArrayData shared].textTitle objectAtIndex:index];
//        to.image = [[ArrayData shared].photo objectAtIndex:index];
        [self.mapView addAnnotation:[[ArrayData shared].mapAnnotation objectAtIndex:index]];
    }
}

- (void)handleLongPress
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5f;
    [self.mapView addGestureRecognizer:lpgr];   
//    if(lpgr.enabled == YES)
//        [self.mapView removeGestureRecognizer:lpgr];
    
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer 
{    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];    
    MapAnnotation *toAdd = [[MapAnnotation alloc]init];    
    toAdd.coordinate = touchMapCoordinate;
    toAdd.title = @"";   
    [self.mapView addAnnotation:toAdd];    
    [[ArrayData shared].mapAnnotation addObject:toAdd];
}

-(void)btnNextClicked:(id)sender
{     
    CameraViewController *cameraViewController = [[CameraViewController alloc]init];
    [self.navigationController pushViewController:cameraViewController animated:YES];                             
}

-(void)btnBackClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)changeMapType:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@""
                                                       delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Map Type Standard",@"Map Type Satellite" , nil];
    popup.tag = 1;
    popup.actionSheetStyle = UIBarStyleBlackTranslucent;
    [popup showInView:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{  
    switch (popup.tag)
    {
        case 1:
        {
            switch (buttonIndex)
            {              
                case 0: //Satellite
                    self.mapView.mapType = MKMapTypeSatellite;
                    break;
                case 1: //Map
                     self.mapView.mapType = MKMapTypeStandard;
                    break;
                default: 
                     break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)mapView:(MKMapView *)mapView
{
    MKUserLocation *userLocation;
    MKCoordinateRegion region;    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    //[mapView setRegion:region animated:YES];
   
}







@end
