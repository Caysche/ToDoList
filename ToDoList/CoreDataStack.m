//
//  CoreDataStack.m
//  ToDoList
//
//  Created by Cay Cornelius on 28/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "CoreDataStack.h"

@implementation CoreDataStack

+ (id)sharedManager {
    static CoreDataStack *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"ToDoDataModel" withExtension:@"momd"];
        NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        
        NSArray *docDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [docDirs firstObject];
        NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"todos.db"];
        NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
        
        NSError *pscError = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&pscError]) {
            NSLog(@"error creating psc %@", pscError);
        }
        
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:psc];
    }
    return self;
}

@end
