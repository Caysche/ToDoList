//
//  ToDoItem+CoreDataProperties.m
//  ToDoList
//
//  Created by Cay Cornelius on 28/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "ToDoItem+CoreDataProperties.h"

@implementation ToDoItem (CoreDataProperties)

+ (NSFetchRequest<ToDoItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ToDoItem"];
}

@dynamic title;
@dynamic toDoDescription;
@dynamic priorityNumber;
@dynamic isCompleted;
@dynamic deadline;

@end
