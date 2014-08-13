//
//  NoteTableViewController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/13/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "NoteTableViewController.h"
#import "CoreDataHelper.h"
#import "NoteTableViewCell.h"

@interface NoteTableViewController ()

@end

@implementation NoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.worker = [CoreDataHelper currentUser];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:NO];
    
    
    self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    self.title = @"My Notes";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonAction)];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.noteArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    [cell setCell:self.noteArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 50;
    
    Note *note = self.noteArray[indexPath.row];
    
    CGFloat height = [self heightForText:note.comments];
    
    cellHeight += (height - 20);
    
    return cellHeight;
}

-(CGFloat)heightForText:(NSString *)text
{
    NSInteger MAX_HEIGHT = 2000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 304, MAX_HEIGHT)];
    textView.text = text;
    textView.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    [textView sizeToFit];
    return textView.frame.size.height;
}

#pragma mark - Action Sheet

-(void)sortButtonAction {
    UIActionSheet *sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Criteria" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Name A-Z", @"Last Name Z-A", @"By Newest", @"By Oldest", nil];
    
    [sortActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"connection.lastName" ascending:YES];
            
            self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.tableView reloadData];
        }
            break;
            
        case 1: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"connection.lastName" ascending:NO];
            
            self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.tableView reloadData];
        }
            break;
            
        case 2: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"date" ascending:NO];
            
            self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.tableView reloadData];
        }
            break;
            
        case 3: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"date" ascending:YES];
            
            self.noteArray = [[self.worker valueForKey:@"notes"] sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
