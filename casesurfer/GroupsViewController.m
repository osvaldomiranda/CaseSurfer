//
//  GroupsViewController.m
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupTableViewCell.h"
#import "Group.h"
#import "NewGroupViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setToptButtons];
    
    self.refreshLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    self.refreshLoadingView.hidden = YES;
    self.pullRefreshVisible = NO;
    [self.view addSubview:self.refreshLoadingView];
    self.groupsTableView.separatorColor = [UIColor clearColor];
    itemsArray = [[NSMutableArray alloc] init];
    self.groupsTableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self endEdit];
    [self refrechData];
}


- (void) setToptButtons{
    UIBarButtonItem *lItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(newGroup:)];
    
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(editGroup:)];
    
    [self.navigationItem setLeftBarButtonItem:lItem animated:YES];
    [self.navigationItem setRightBarButtonItem:rItem animated:YES];
}

-(void) refrechData{
    NSMutableDictionary *groupParams =  @{}.mutableCopy;
    Group *groups = [[Group alloc] initWithParams:groupParams];
    [groups index:groupParams Success:^(NSArray *items) {
        [self fillImtensArray:items];
        if (self.pullRefreshVisible) {
            [self loadingViewVisible:NO];
        }
    } Error:^(NSError *error) {
    }];
}

-(void) fillImtensArray:(NSArray *) items{
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
    }
    [self.groupsTableView reloadData];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    [cell.contentView clearsContextBeforeDrawing];
    [cell setCallerViewController:self];
    
    
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    NSString *groupName = [celda valueForKeyPath:@"name"];
    int groupId = [[celda valueForKeyPath:@"id"] intValue];;
    
    NSMutableArray *users = [celda valueForKeyPath:@"users"];
    NSString *members;
    for (NSDictionary *user in users) {
        if(members==nil){
            members = [user valueForKeyPath:@"name"];
        }
        else {
            members = [NSString stringWithFormat:@"%@, %@", [user valueForKeyPath:@"name"], members];
        }
    }
    
    cell.lblGroupMembers.text = members;
    cell.lblGroupName.text = groupName;
    cell.groupId = groupId;
    
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -20){
        if (!self.pullRefreshVisible){
            [self loadingViewVisible:YES];
        }
    }
}


-(void) loadingViewVisible:(BOOL) visible{
    BOOL hidden; int viewMove;
    if (visible) {
        hidden = NO; viewMove = 60;
        self.pullRefreshVisible =TRUE;
    } else {
        hidden = YES; viewMove = -60;
        self.pullRefreshVisible =FALSE;
    }
    [self.refreshLoadingView startLoadingIndicator];
    [UIView transitionWithView:self.groupsTableView
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        CGRect new_frame = self.groupsTableView.frame;
                        new_frame.origin.y += viewMove;
                        self.groupsTableView.frame = new_frame;
                    }
                    completion:nil];
    self.refreshLoadingView.hidden = hidden;
    [self refrechData];
}

- (IBAction)editGroup:(id)sender {
    if (self.groupsTableView.isEditing) {
        [self.groupsTableView setEditing: NO animated: YES];
    } else{
        [self.groupsTableView setEditing: YES animated: YES];
    }
}

- (void) endEdit{
    if (self.groupsTableView.isEditing) {
        [self.groupsTableView setEditing: NO animated: YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    int groupId = [[celda valueForKeyPath:@"id"] intValue];;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteGroup:groupId];
    }
}

-(void) deleteGroup:(int) idGroup{
    NSMutableDictionary *groupParams =  @{}.mutableCopy;
    Group *group = [[Group alloc] initWithParams:groupParams];
    [group delete:idGroup params:groupParams Success:^(NSMutableDictionary *items) {
        [self refrechData];
        [self.groupsTableView reloadData];
    } Error:^(NSError *error) {
    }];
}

- (IBAction)newGroup:(id)sender {
    [self endEdit];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewGroupViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"NewGroup"];
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}



@end
