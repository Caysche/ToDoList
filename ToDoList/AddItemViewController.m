//
//  AddItemViewController.m
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "AddItemViewController.h"
#import "MasterViewController.h"
#import "ToDoItem+CoreDataProperties.h"
#import "CoreDataStack.h"

@interface AddItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *priorityNumberInput;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerInput;
@property (nonatomic) CoreDataStack *stack;
@property (nonatomic) NSFetchedResultsController *frc;
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
- (IBAction)addButtonPressed:(UIButton *)sender {
    self.stack = [CoreDataStack sharedManager];
    
    NSFetchRequest *toDoItemFetchRequest = [ToDoItem fetchRequest];
    toDoItemFetchRequest.fetchLimit = 100;
    
    
    NSSortDescriptor *sortDescription = [NSSortDescriptor sortDescriptorWithKey:@"priorityNumber" ascending:YES];
    toDoItemFetchRequest.sortDescriptors = @[sortDescription];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:toDoItemFetchRequest managedObjectContext:self.stack.context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *fetchError = nil;
    [self.frc performFetch:&fetchError];
    
    NSManagedObjectContext *context = [self.frc managedObjectContext];
    
    ToDoItem *newToDoItem = [[ToDoItem alloc] initWithContext:context];
    
    // If appropriate, configure the new managed object.
    
    newToDoItem.title = self.titleTextInput.text;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    newToDoItem.priorityNumber = [[formatter numberFromString:self.priorityNumberInput.text] integerValue];
    newToDoItem.toDoDescription = self.descriptionTextInput.text;
    newToDoItem.deadline = self.datePickerInput.date;
    newToDoItem.isCompleted = NO;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"unwindSegue"]) {
        
        MasterViewController *masterViewController = (MasterViewController *)[segue destinationViewController];
        [masterViewController fetchData];
        
    }
}

@end
