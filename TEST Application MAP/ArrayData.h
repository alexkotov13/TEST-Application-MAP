//
//  Class.h
//  TEST Application MAP
//
//  Created by admin on 26.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayData : NSArray
+ (instancetype)shared;
@property (nonatomic, retain, readwrite) NSMutableArray *photo;
@property (nonatomic, retain, readwrite) NSMutableArray *sound;
@property (nonatomic, retain, readwrite) NSMutableArray *mapAnnotation;
@property (nonatomic, retain, readwrite) NSMutableArray *textTitle;

@end
