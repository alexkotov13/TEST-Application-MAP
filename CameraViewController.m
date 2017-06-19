//
//  CameraViewController.m
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "CameraViewController.h"


CGSize view;

@interface CameraViewController ()
{
    UIButton *library;
    UIButton *camera;
    UIButton *cencel;    
}
@end

@implementation CameraViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppearanceManager shared] customizeRootViewController:self.view];
    view = self.view.bounds.size;
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
    library = [[UIButton alloc]initWithFrame:CGRectZero];
    [library setTitle:@"Library" forState:UIControlStateNormal];
    [self.view addSubview:library];
    [library addTarget:self action:@selector(libraryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:library CoordinatesX:view.width / 4 - 60 Y:view.height / 2  Width:view.width - 40 Radius:10];
    
    camera = [[UIButton alloc]initWithFrame:CGRectZero];
    [camera setTitle:@"Camera" forState:UIControlStateNormal];
    [self.view addSubview:camera];
    [camera addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:camera CoordinatesX:view.width / 4 - 60 Y:view.height / 1.5 Width:view.width - 40 Radius:10];
    
    cencel = [[UIButton alloc]initWithFrame:CGRectZero];
    [cencel setTitle:@"Cencel" forState:UIControlStateNormal];
    [self.view addSubview:cencel];
    [cencel addTarget:self action:@selector(cencelClick:) forControlEvents:UIControlEventTouchUpInside];
    [[AppearanceManager shared] customizeButtonAppearance:cencel CoordinatesX:view.width / 4 - 60 Y:view.height / 1.2 Width:view.width - 40 Radius:10];
}
UIImagePickerController *imagePicker;
- (void)libraryButtonClick:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
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

    UIImage *pickedImage = [info objectForKey: UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    imagePicker = [[UIImagePickerController alloc]init];
//    [self.navigationController pushViewController:imagePicker animated:YES];
    PickerViewController *pickerViewController = [[PickerViewController alloc]initWithImage:pickedImage];
    [self.navigationController pushViewController:pickerViewController animated:YES];

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
