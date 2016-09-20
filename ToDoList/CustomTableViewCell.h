//
//  CustomTableViewCell.h
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todoDescription;
@property (weak, nonatomic) IBOutlet UILabel *priorityNumber;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
