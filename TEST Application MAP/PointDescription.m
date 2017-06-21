//
//  PointDescription.m
//  TEST Application MAP
//
//  Created by ann on 20.06.17.
//  Copyright (c) 2017 admin. All rights reserved.
//

#import "PointDescription.h"

@interface PointDescription()
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation PointDescription

@dynamic imagePath;
@dynamic latitude;
@dynamic longitude;
@dynamic soundPath;
@dynamic titleForPin;
@dynamic thumbnail;
@synthesize theCoordinate = _theCoordinate;

- (CLLocationCoordinate2D)coordinate
{
    _theCoordinate.longitude = self.longitude.doubleValue;
    _theCoordinate.latitude = self.latitude.doubleValue;
    return _theCoordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)pinCoordinate
{
    _theCoordinate = pinCoordinate;
}

-(NSString *)title
{
    return self.titleForPin;
}

@end
