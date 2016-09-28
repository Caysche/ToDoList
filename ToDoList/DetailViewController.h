//
//  DetailViewController.h
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoItem;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) ToDoItem *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

