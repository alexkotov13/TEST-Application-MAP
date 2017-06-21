//
//  ￼￼ImagePrevViewController.h
//  TEST Application MAP
//
//  Created by admin on 24.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearanceManager.h"
#import "ListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PointDescription.h"


@interface ImagePrevViewController : UIViewController <AVAudioPlayerDelegate>
//- (id)initWithImage:(UIImage *)image initWithPointDescription:(PointDescription*)pointDescription;
- (id)initWithIndexOfObject:(NSIndexPath *)indexPath;
@end
