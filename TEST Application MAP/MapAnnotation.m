//
//  MapAnnotation.m
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return coordinate;
}

//- (NSString*)title
//{
   /// return title;
//}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

//- (void)setTitle:(NSString*)newTitle {
////    title = newTitle;
//}


@end
