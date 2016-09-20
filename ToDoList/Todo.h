//
//  Todo.h
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *todoDescription;
@property (assign) NSNumber *priorityNumber;
@property (assign) BOOL isCompleted;
@property (nonatomic, strong) NSDate *deadline;

@end
