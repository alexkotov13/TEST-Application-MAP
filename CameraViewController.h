//
//  CameraViewController.h
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearanceManager.h"
#import "PickerViewController.h"
#import "ListViewController.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

-(id)initWithPointDescription:(PointDescription*) pointDescription;

@end
