//
//  MyClassViewController.h
//  TEST Application MAP
//
//  Created by admin on 17.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"
#import "AppearanceManager.h"
#import "ArrayData.h"

//@interface MapViewController : UIViewController
//{
//  
//}
@interface MapViewController : UIViewController <UIActionSheetDelegate, MKMapViewDelegate>
{
    MKMapView *mapView;
}
@property (nonatomic, retain) MKMapView *mapView;

@end
