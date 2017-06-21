//
//  PointDescription.h
//  TEST Application MAP
//
//  Created by ann on 20.06.17.
//  Copyright (c) 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKFoundation.h>

@interface PointDescription : NSManagedObject <MKAnnotation>

@property NSString * imagePath;
@property NSNumber * latitude;
@property NSNumber * longitude;
@property NSString * soundPath;
@property NSString * titleForPin;
@property id thumbnail;

@end