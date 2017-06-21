

#import "CoreDataManager.h"
@interface CoreDataManager()

@property NSManagedObjectModel *managedObjectModel;
@property NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize subContext = _subContext;

static CoreDataManager *sharedManager = nil;

+(CoreDataManager *) sharedInstance
{
    @synchronized(self)
    {
        if (!sharedManager)
        {
            sharedManager = [[CoreDataManager alloc] init];
        }
    }
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupManagedObjectContext];
        [self setupNewManagedObjectContext];
    }
    return self;
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

-(void)setupNewManagedObjectContext
{
    _subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _subContext.parentContext = self.managedObjectContext;
}

- (void)setupManagedObjectContext
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* documentDirectoryURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL* persistentURL = [documentDirectoryURL URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError* error = nil;
    NSPersistentStore* persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentURL options:nil error:&error];
    if (persistentStore)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    else
    {
        NSLog(@"ERROR: %@", error.description);
    }
}

- (void)saveContext
{
    NSError* error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointDescription" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"titleForPin" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    return _fetchedResultsController;
}

@end
