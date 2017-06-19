//
//  Class.m
//  TEST Application MAP
//
//  Created by admin on 26.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "ArrayData.h"

@implementation ArrayData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
       self.photo = [NSMutableArray array];
       self.sound = [NSMutableArray array];
       self.mapAnnotation = [NSMutableArray array];
       self.textTitle = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)shared
{
    static ArrayData* instance = nil;
    
    if(!instance)
    {
        instance = [[ArrayData alloc] init];
    }
    return instance;
}
@end
