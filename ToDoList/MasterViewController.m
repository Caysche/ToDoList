//
//  MasterViewController.m
//  ToDoList
//
//  Created by Cay Cornelius on 20/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Todo.h"
#import "CustomTableViewCell.h"

@interface MasterViewController ()

@property (nonatomic) NSMutableArray *todoArray;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    Todo *homework = [[Todo alloc] init];
    homework.title = @"Homework";
    homework.todoDescription = @"I have to do all the programming tasks Dan gave us.";
    homework.priorityNumber = @1;
    homework.isCompleted = NO;
    
    Todo *tidyUpAppartment = [[Todo alloc] init];
    tidyUpAppartment.title = @"Tidy up appartment";
    tidyUpAppartment.todoDescription = @"I have to tidy up my appartment.";
    tidyUpAppartment.priorityNumber = @2;
    tidyUpAppartment.isCompleted = NO;
    
    Todo *tidyUpAppartment2 = [[Todo alloc] init];
    tidyUpAppartment2.title = @"Tidy up appartment2";
    tidyUpAppartment2.todoDescription = @"I have to tidy up my appartment.";
    tidyUpAppartment2.priorityNumber = @2;
    tidyUpAppartment2.isCompleted = NO;
    
    self.todoArray = [@[
                       homework, tidyUpAppartment, tidyUpAppartment2
                       ] mutableCopy];
    [self setUpRightSwipe];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)object {
    
    [self.todoArray addObject:object];
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
}

- (void)insertMovedObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [self.todoArray insertObject:object atIndex:indexPath.row];
    [self.tableView reloadData];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Todo *todoItem = self.todoArray[indexPath.row];
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        [detailViewController setDetailItem:todoItem];
    }
}

#pragma mark - Table View

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Todo *todoItem = self.todoArray[indexPath.row];
    
    if(todoItem.isCompleted == NO) {
        cell.title.text = todoItem.title;
    } else {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:todoItem.title];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.title.attributedText = attributeString;
    }
    
    cell.todoDescription.text = todoItem.todoDescription;
    cell.priorityNumber.text = [NSString stringWithFormat:@"%@", todoItem.priorityNumber];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoArray removeObject:self.todoArray[indexPath.row]];
        [self.tableView reloadData];
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
    Todo *swipedTodo = self.todoArray[indexPath.row];
    if (swipedTodo.isCompleted == NO) {
        swipedTodo.isCompleted = YES;
        [self.tableView reloadData];
    }
}

- (NSArray *)arrayByRemovingObject:(id)obj
{
    if (!obj) return [self.todoArray copy];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.todoArray];
    [mutableArray removeObject:obj];
    return [NSArray arrayWithArray:mutableArray];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id itemToMove = self.todoArray[sourceIndexPath.row];
    [self.todoArray removeObject:itemToMove];
    [self.todoArray insertObject:itemToMove atIndex:destinationIndexPath.row];
    [self.tableView reloadData];
}
@end
