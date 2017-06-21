//
//  SoundRecorderViewController.h
//  TEST Application MAP
//
//  Created by admin on 22.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearanceManager.h"
#import "PickerViewController.h"
#import <AVFoundation/AVFoundation.h>



@interface SoundRecorderViewController : UIViewController <AVAudioRecorderDelegate>
-(id)initWithPointDescription:(PointDescription*) pointDescription;
@end
