//
//  GroupsShareViewController.m
//  casesurfer
//
//  Created by Osvaldo on 14-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GroupsShareViewController.h"
#import "Definitions.h"
#import "UserTableViewController.h"
#import "Group.h"
#import "GroupsShareTableViewCell.h"
#import "ShareUsersTableViewController.h"


@interface GroupsShareViewController ()

@end

@implementation GroupsShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self refrechData];
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
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupsShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupsShareCell"];
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


-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return indexPath;
    
}
#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    NSString *groupName = [celda valueForKeyPath:@"name"];
    NSString *groupId = [celda valueForKeyPath:@"id"];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
         [self.delegate addGroupToShare:groupId groupName:groupName];
    }
    
    
}







@end
