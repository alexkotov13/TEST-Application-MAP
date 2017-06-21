//
//  PickerViewController.h
//  TEST Application MAP
//
//  Created by admin on 22.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "AppearanceManager.h"
#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "SoundRecorderViewController.h"
#import "CameraViewController.h"

@interface PickerViewController : UIViewController <UITextFieldDelegate,NSFetchedResultsControllerDelegate>
-(id)initWithImage:(UIImage *)image initWithPointDescription:(PointDescription*) pointDescription;
@end
