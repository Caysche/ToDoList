//
//  AddItemViewController.m
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "AddItemViewController.h"
#import "Todo.h"
#import "MasterViewController.h"

@interface AddItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *priorityNumberInput;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerInput;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"unwindSegue"]) {
        
        MasterViewController *masterViewController = (MasterViewController *)[segue destinationViewController];
        
        Todo *todoItem = [[Todo alloc] init];
        
        todoItem.title = self.titleTextInput.text;
        
        todoItem.todoDescription = self.descriptionTextInput.text;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        todoItem.priorityNumber = [formatter numberFromString:self.priorityNumberInput.text];
        
        todoItem.deadline = self.datePickerInput.date;
        
        
        [masterViewController insertNewObject:todoItem];
    }
}

@end
