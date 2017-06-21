

#import <Foundation/Foundation.h>
#import "ListViewController.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic)  NSFetchedResultsController * fetchedResultsController;
@property  NSManagedObjectContext *managedObjectContext;
@property  NSManagedObjectContext *subContext;


+ (CoreDataManager *)sharedInstance;
- (void)saveContext;
- (NSFetchedResultsController *)fetchedResultsController;

@end
