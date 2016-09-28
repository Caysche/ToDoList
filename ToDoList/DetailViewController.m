//
//  DetailViewController.m
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "DetailViewController.h"
#import "ToDoItem+CoreDataProperties.h"
#import "CoreDataStack.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *todoTitle;
@property (weak, nonatomic) IBOutlet UILabel *priorityNumber;
@property (weak, nonatomic) IBOutlet UILabel *todoDescription;
@property (weak, nonatomic) IBOutlet UILabel *deadline;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.todoTitle.text = [self.detailItem title];
        self.priorityNumber.text = [NSString stringWithFormat:@"%hd", [self.detailItem priorityNumber]];
        self.todoDescription.text = [self.detailItem toDoDescription];
        self.todoDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.todoDescription.numberOfLines = 0;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone localTimeZone]];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
        NSDate *localDateRightNow = [calendar dateFromComponents:dateComponents];
        
        NSDate *deadlineDate = [self.detailItem deadline];
        NSTimeInterval distanceBetweenDates = [deadlineDate timeIntervalSinceDate:localDateRightNow];
        double minutesInAnHour = 60;
        NSInteger minutesBetweenDates = distanceBetweenDates / minutesInAnHour;
        self.deadline.text = [NSString stringWithFormat: @"%ld", (long)minutesBetweenDates];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
