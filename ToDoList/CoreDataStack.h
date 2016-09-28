//
//  CoreDataStack.h
//  ToDoList
//
//  Created by Cay Cornelius on 28/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface CoreDataStack : NSObject

@property (nonatomic) NSManagedObjectContext *context;

+ (id)sharedManager;

@end
