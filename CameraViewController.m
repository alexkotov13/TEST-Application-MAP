//
//  CameraViewController.m
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()
{
    CGSize _view;
    UIButton *_library;
    UIButton *_camera;
    UIButton *_cencel;
    UIImagePickerController *_imagePicker;
    UIImage* _pickedImage;
    PointDescription* _pointDescription;
}
@end

@implementation CameraViewController

-(id)initWithPointDescription:(PointDescription*) pointDescription
{
    self = [super init];
    if(self)
    {
        _pointDescription = pointDescription;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppearanceManager shared] customizeRootViewController:self.view];
    _view = self.view.bounds.size;
    [self drawButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)drawButton
{
    _library = [[UIButton alloc]initWithFrame:CGRectZero];
    [_library setTitle:@"Library" forState:UIControlStateNormal];
    [self.view addSubview:_library];
    [_library addTarget:self action:@selector(libraryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_library CoordinatesX:_view.width / 4 - 60 Y:_view.height / 2  Width:_view.width - 40 Radius:10];
    
    _camera = [[UIButton alloc]initWithFrame:CGRectZero];
    [_camera setTitle:@"Camera" forState:UIControlStateNormal];
    [self.view addSubview:_camera];
    [_camera addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_camera CoordinatesX:_view.width / 4 - 60 Y:_view.height / 1.5 Width:_view.width - 40 Radius:10];
    
    _cencel = [[UIButton alloc]initWithFrame:CGRectZero];
    [_cencel setTitle:@"Cencel" forState:UIControlStateNormal];
    [self.view addSubview:_cencel];
    [_cencel addTarget:self action:@selector(cencelClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:_cencel CoordinatesX:_view.width / 4 - 60 Y:_view.height / 1.2 Width:_view.width - 40 Radius:10];
}

- (void)libraryButtonClick:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Library Unavailable"
                                                       message:@"Unable to find a Library on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _pickedImage = [info objectForKey: UIImagePickerControllerEditedImage];
    [self imagePathWithImage:_pickedImage];
    _pointDescription.thumbnail = _pickedImage;
    
    PickerViewController *pickerViewController = [[PickerViewController alloc] initWithImage:_pickedImage initWithPointDescription:_pointDescription];
    [self.navigationController pushViewController:pickerViewController animated:YES];
    
}

- (NSString *)documentsDicrectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)imagePathWithImage:(UIImage *)image
{
    NSDate* now = [NSDate date];
    NSString* caldate = [now description];
    NSString* recorderFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDicrectory], caldate];
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    [data writeToFile:recorderFilePath atomically:YES];
    _pointDescription.imagePath = recorderFilePath;
}

- (void)cameraButtonClick:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

-(void)cencelClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
