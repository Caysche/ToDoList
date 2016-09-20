//
//  DetailViewController.m
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *todoTitle;
@property (weak, nonatomic) IBOutlet UILabel *priorityNumber;
@property (weak, nonatomic) IBOutlet UILabel *todoDescription;

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
        self.priorityNumber.text = [NSString stringWithFormat:@"%@", [self.detailItem priorityNumber]];
        self.todoDescription.text = [self.detailItem todoDescription];
        self.todoDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.todoDescription.numberOfLines = 0;
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
