//
//  ListViewController.h
//  TEST Application MAP
//
//  Created by admin on 19.02.16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearanceManager.h"
#import "￼￼ImagePrevViewController.h"
#import "CoreDataManager.h"
#import "PointDescription.h"

@interface ListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
