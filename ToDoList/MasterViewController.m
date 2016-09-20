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
    
    [self addData];
    
    [self setUpRightSwipe];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addData {
    
    Todo *homework = [[Todo alloc] init];
    homework.title = @"Homework";
    homework.todoDescription = @"I have to do all the programming tasks Dan gave us.";
    homework.priorityNumber = @1;
    homework.isCompleted = NO;
    NSDateComponents *deadlineHomework  =[[NSDateComponents alloc] init];
    [deadlineHomework setDay:26];
    [deadlineHomework setMonth: 9];
    [deadlineHomework setYear: 2016];
    [deadlineHomework setHour:16];
    [deadlineHomework setMinute:02];
    NSCalendar *gregorianCalendar = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    homework.deadline = [gregorianCalendar dateFromComponents:deadlineHomework];
    
    Todo *tidyUpAppartment = [[Todo alloc] init];
    tidyUpAppartment.title = @"Tidy up appartment";
    tidyUpAppartment.todoDescription = @"I have to tidy up my appartment.";
    tidyUpAppartment.priorityNumber = @2;
    tidyUpAppartment.isCompleted = NO;
    NSDateComponents *deadlineTidying  =[[NSDateComponents alloc] init];
    [deadlineTidying setDay:30];
    [deadlineTidying setMonth: 9];
    [deadlineTidying setYear: 2016];
    [deadlineTidying setHour:16];
    [deadlineTidying setMinute:02];
    tidyUpAppartment.deadline = [gregorianCalendar dateFromComponents:deadlineTidying];
    
    Todo *buyGroceries = [[Todo alloc] init];
    buyGroceries.title = @"Buy groceries";
    buyGroceries.todoDescription = @"I have to buy bananas, apples, bread, toothpaste, and some water.";
    buyGroceries.priorityNumber = @3;
    buyGroceries.isCompleted = NO;
    NSDateComponents *deadlineGroceries  =[[NSDateComponents alloc] init];
    [deadlineGroceries setDay:28];
    [deadlineGroceries setMonth: 9];
    [deadlineGroceries setYear: 2016];
    [deadlineGroceries setHour:16];
    [deadlineGroceries setMinute:02];
    buyGroceries.deadline = [gregorianCalendar dateFromComponents:deadlineGroceries];
    
    
    self.todoArray = [@[
                        homework, tidyUpAppartment, buyGroceries
                        ] mutableCopy];
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
