//
//  MasterViewController.m
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CustomTableViewCell.h"
#import "ToDoItem+CoreDataProperties.h"
#import "CoreDataStack.h"

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) CoreDataStack *stack;
@property (nonatomic) NSFetchedResultsController *frc;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self fetchData];
    
    [self addData];
    
    [self setUpRightSwipe];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    self.stack = [CoreDataStack sharedManager];
    
    NSFetchRequest *toDoItemFetchRequest = [ToDoItem fetchRequest];
    toDoItemFetchRequest.fetchLimit = 100;
    
    NSSortDescriptor *sortDescription = [NSSortDescriptor sortDescriptorWithKey:@"priorityNumber" ascending:YES];
    toDoItemFetchRequest.sortDescriptors = @[sortDescription];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:toDoItemFetchRequest managedObjectContext:self.stack.context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
    
    NSError *fetchError = nil;
    [self.frc performFetch:&fetchError];
}

- (void)addData {
    
//    Todo *homework = [[Todo alloc] init];
//    homework.title = @"Homework";
//    homework.todoDescription = @"I have to do all the programming tasks Dan gave us.";
//    homework.priorityNumber = @1;
//    homework.isCompleted = NO;
//    NSDateComponents *deadlineHomework  =[[NSDateComponents alloc] init];
//    [deadlineHomework setDay:26];
//    [deadlineHomework setMonth: 9];
//    [deadlineHomework setYear: 2016];
//    [deadlineHomework setHour:16];
//    [deadlineHomework setMinute:02];
//    NSCalendar *gregorianCalendar = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    homework.deadline = [gregorianCalendar dateFromComponents:deadlineHomework];
//    
//    Todo *tidyUpAppartment = [[Todo alloc] init];
//    tidyUpAppartment.title = @"Tidy up appartment";
//    tidyUpAppartment.todoDescription = @"I have to tidy up my appartment.";
//    tidyUpAppartment.priorityNumber = @2;
//    tidyUpAppartment.isCompleted = NO;
//    NSDateComponents *deadlineTidying  =[[NSDateComponents alloc] init];
//    [deadlineTidying setDay:30];
//    [deadlineTidying setMonth: 9];
//    [deadlineTidying setYear: 2016];
//    [deadlineTidying setHour:16];
//    [deadlineTidying setMinute:02];
//    tidyUpAppartment.deadline = [gregorianCalendar dateFromComponents:deadlineTidying];
//    
//    Todo *buyGroceries = [[Todo alloc] init];
//    buyGroceries.title = @"Buy groceries";
//    buyGroceries.todoDescription = @"I have to buy bananas, apples, bread, toothpaste, and some water.";
//    buyGroceries.priorityNumber = @3;
//    buyGroceries.isCompleted = NO;
//    NSDateComponents *deadlineGroceries  =[[NSDateComponents alloc] init];
//    [deadlineGroceries setDay:28];
//    [deadlineGroceries setMonth: 9];
//    [deadlineGroceries setYear: 2016];
//    [deadlineGroceries setHour:16];
//    [deadlineGroceries setMinute:02];
//    buyGroceries.deadline = [gregorianCalendar dateFromComponents:deadlineGroceries];
}

//- (void)insertNewObject:(id)object {
//    
//    [self.todoArray addObject:object];
////    
////    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: inSection:0];
////    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    [self.tableView reloadData];
//}

//- (void)insertMovedObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
//    [self.todoArray insertObject:object atIndex:indexPath.row];
//    [self.tableView reloadData];
//}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ToDoItem *toDoItem = [self.frc objectAtIndexPath:indexPath];
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        [detailViewController setDetailItem:toDoItem];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.frc sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.frc.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ToDoItem *toDoItem = [self.frc objectAtIndexPath:indexPath];
    
    if(toDoItem.isCompleted == NO) {
        cell.title.text = toDoItem.title;
    } else {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:toDoItem.title];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.title.attributedText = attributeString;
    }
    
    cell.todoDescription.text = toDoItem.toDoDescription;
    cell.priorityNumber.text = [NSString stringWithFormat:@"%hd", toDoItem.priorityNumber];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self.frc managedObjectContext];
        [context deleteObject:[self.frc objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        [self fetchData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)setUpRightSwipe {
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(swipeRight:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:recognizer];
    recognizer.delegate = self;
}


- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    ToDoItem *swipedTodo = [self.frc objectAtIndexPath:indexPath];
    if (swipedTodo.isCompleted == NO) {
        swipedTodo.isCompleted = YES;
        [self.tableView reloadData];
    }
}

//- (void)insertNewObject:(ToDoItem *)toDoItem {
//    
//    NSManagedObjectContext *context = [self.frc managedObjectContext];
//    
//    ToDoItem *newToDoItem = [[ToDoItem alloc] initWithContext:context];
//    
//    // If appropriate, configure the new managed object.
//    
//    newToDoItem.title = toDoItem.title;
//    newToDoItem.priorityNumber = toDoItem.priorityNumber;
//    newToDoItem.toDoDescription = toDoItem.toDoDescription;
//    newToDoItem.deadline = toDoItem.deadline;
//    newToDoItem.isCompleted = toDoItem.isCompleted;
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//    
//    [self.tableView reloadData];
//}

- (void)configureCell:(UITableViewCell *)cell withEvent:(ToDoItem *)toDoItem {
    cell.textLabel.text = toDoItem.title;
}


//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    id itemToMove = self.todoArray[sourceIndexPath.row];
//    [self.todoArray removeObject:itemToMove];
//    [self.todoArray insertObject:itemToMove atIndex:destinationIndexPath.row];
//    [self.tableView reloadData];
//}

#pragma mark - core Data changed

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
