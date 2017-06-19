//
//  ListViewController.m
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "ListViewController.h"

NSArray *mapTitle;
NSArray *mapImage;

@interface ListViewController ()

@end

@implementation ListViewController


UIImage *pickedImage;

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        pickedImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"List";
    [[AppearanceManager shared] customizeTopNavigationBarAppearance:self.navigationController.navigationBar];
    //[[AppearanceManager shared] customizeRootViewController:self.view];
    
    //bottom navigationItem
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(btnBackClicked:) ];
    self.navigationItem.leftBarButtonItem = backButton;
    [[AppearanceManager shared] customizeBackBarButtonAppearanceForNavigationBar:self.navigationItem.leftBarButtonItem];
    
    UIImage * image = [UIImage imageNamed:@"Alex.jpg"];
    UIImage * imageAnna = [UIImage imageNamed:@"Anna.jpg"];
    UIImage * imageJury = [UIImage imageNamed:@"Jury.jpg"];
    UIImage * imageYuliya = [UIImage imageNamed:@"Yuliya.jpg"];
    UIImage * imageAnastasia = [UIImage imageNamed:@"Anastasia.jpg"];
    
    mapTitle = [NSArray arrayWithObjects:@"Alex", @"Anna", @"Yuliya", @"Jury", @"Anastasia", nil];
    mapImage = [NSArray arrayWithObjects:image, imageAnna, imageYuliya, imageJury, imageAnastasia, nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ArrayData shared].textTitle count];
}

- (NSInteger)tableView1:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ArrayData shared].photo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //Поиск ячейки
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    //Если ячейка не найдена
    if (cell == nil)
    {
        //Создание ячейки
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [[[ArrayData shared] textTitle] objectAtIndex:indexPath.row];    
    cell.imageView.image = [[[ArrayData shared] photo] objectAtIndex:indexPath.row];
   // cell.textLabel.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    //cell.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

UIImagePickerController *imagePicker;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage * image = cell.imageView.image;  
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self imagePickerController:image];
}

- (void) imagePickerController:(UIImage*)image
{   
  
    [self dismissViewControllerAnimated:YES completion:nil];
    ImagePrevViewController *imagePrevViewController = [[ImagePrevViewController alloc]initWithImage:image];
    [self.navigationController pushViewController:imagePrevViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)btnBackClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
