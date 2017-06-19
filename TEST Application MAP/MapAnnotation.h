//
//  MapAnnotation.h
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
{
    
    CLLocationCoordinate2D coordinate;
    //NSString *title;
}
@property (nonatomic)NSString *title;
@property (nonatomic)UIImage *image;


@end
