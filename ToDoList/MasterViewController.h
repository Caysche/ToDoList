//
//  MasterViewController.h
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UIGestureRecognizerDelegate>

- (void)insertNewObject:(id)object;

@end

