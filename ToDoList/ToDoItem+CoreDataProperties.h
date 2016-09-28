//
//  ToDoItem+CoreDataProperties.h
//  ToDoList
//
//  Created by Cay Cornelius on 28/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "ToDoItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem (CoreDataProperties)

+ (NSFetchRequest<ToDoItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *toDoDescription;
@property (nonatomic) int16_t priorityNumber;
@property (nonatomic) BOOL isCompleted;
@property (nullable, nonatomic, copy) NSDate *deadline;

@end

NS_ASSUME_NONNULL_END
