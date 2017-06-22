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
#import <MapKit/MapKit.h>
#import "￼￼ImagePrevViewController.h"

#define STANDART_MAP 0
#define SATELLITE_MAP 1
#define HYBRID_MAP 2
#define POPUP_MAP 1
#define POPUP_IMAGE_SOURCE 2

@interface MapViewController() <UIActionSheetDelegate, MKMapViewDelegate
,UINavigationControllerDelegate,NSFetchedResultsControllerDelegate>
{
    PointDescription* _pinDescriptionEntity;
    MKMapView* _mapView;
    UIImage* _image;
}
@property NSString* recorderFilePath;
@property NSFetchedResultsController *fetchedResultsController;
@end

@implementation MapViewController

@synthesize recorderFilePath = _recorderFilePath;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _recorderFilePath = nil;
    [self setFetchedController];
    [self drawButton];
    [self addMap];
    _pinDescriptionEntity = [NSEntityDescription
                             insertNewObjectForEntityForName:@"PointDescription"
                             inManagedObjectContext:[[CoreDataManager sharedInstance] subContext]];
    
}

-(void)drawButton
{
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
}

-(void)addMap
{
    _mapView = [[MKMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    
    [self.view addSubview:_mapView];
    
}

-(void)setFetchedController
{
    _fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController];
    _fetchedResultsController.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

#pragma Action for map

- (void)plotPlaces
{
    [_mapView removeAnnotations:_mapView.annotations];
    NSArray* data = [self.fetchedResultsController fetchedObjects];
    for (NSArray *row in data)
    {
        PointDescription *pinInfo = (PointDescription*)row;
        [_mapView addAnnotation:pinInfo];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"Annotation";
    if ([annotation isKindOfClass:[PointDescription class]])
    {
        
        MKPinAnnotationView  *annotationView = (MKPinAnnotationView  *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView  alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.animatesDrop = YES;
            annotationView.canShowCallout = YES;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        PointDescription *annotationTapped = (PointDescription *)annotation;
        UIImage *smallImage = [annotationTapped thumbnail];//[UIImage imageWithData:[annotationTapped thumbnail]];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:smallImage];
        iconView.frame = CGRectMake(0, 0, 30, 30);
        annotationView.leftCalloutAccessoryView = iconView;
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSIndexPath* indexPath = nil;
    if ([view.annotation isKindOfClass:[PointDescription class]])
    {
        PointDescription *annotationTapped = (PointDescription *)view.annotation;
        indexPath = [_fetchedResultsController indexPathForObject:annotationTapped];
    }
    ImagePrevViewController *imagePrevViewController = [[ImagePrevViewController alloc] initWithIndexOfObject:indexPath];
    [self.navigationController pushViewController:imagePrevViewController animated:YES];
}

-(void)btnNextClicked:(id)sender
{
    if(_pinDescriptionEntity.latitude == nil)
    {
        NSNumber* degree = [[NSNumber alloc] initWithDouble:_mapView.userLocation.coordinate.latitude];
        _pinDescriptionEntity.latitude = degree;
        degree = [NSNumber numberWithDouble:_mapView.userLocation.coordinate.longitude];
        _pinDescriptionEntity.longitude = degree;
        CameraViewController *cameraViewController = [[CameraViewController alloc]initWithPointDescription:_pinDescriptionEntity];
        [self.navigationController pushViewController:cameraViewController animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"This location already has an annotation.\n Select another location..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
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
                    _mapView.mapType = MKMapTypeSatellite;
                    break;
                case 1: //Map
                    _mapView.mapType = MKMapTypeStandard;
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
    [self plotPlaces];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self plotPlaces];
}

@end
