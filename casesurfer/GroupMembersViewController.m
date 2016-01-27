//
//  GroupMembersViewController.m
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GroupMembersViewController.h"
#import "GroupMemberTableViewCell.h"
#import "Definitions.h"
#import "UserTableViewController.h"
#import "Group.h"
#import "Group_user.h"

@interface GroupMembersViewController ()

@end

@implementation GroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 64, 400, 60)];
    self.refreshLoadingView.hidden = YES;
    self.pullRefreshVisible = NO;
    [self.view addSubview:self.refreshLoadingView];
    self.membersTableView.allowsMultipleSelectionDuringEditing = NO;
    
    membersArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self setToptButtons];
    [self refrechData];
    
}

- (void) setToptButtons{
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(editMembers:)];
    
    [self.navigationItem setRightBarButtonItem:rItem animated:YES];
}

-(void) refrechData{
    NSMutableDictionary *groupParams =  @{}.mutableCopy;
    Group *groups = [[Group alloc] initWithParams:groupParams];
    [groups find:self.groupId Success:^(NSMutableDictionary *items) {
       [self fillImtensArray: [items valueForKeyPath:@"users"]];
        if (self.pullRefreshVisible) {
            [self loadingViewVisible:NO];
        }
    } Error:^(NSError *error) {
    }];
}

-(void) fillImtensArray:(NSArray *) items{
    [membersArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [membersArray addObject:item];
    }
    [self.membersTableView reloadData];
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
    [UIView transitionWithView:self.membersTableView
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        CGRect new_frame = self.membersTableView.frame;
                        new_frame.origin.y += viewMove;
                        self.membersTableView.frame = new_frame;
                    }
                    completion:nil];
    self.refreshLoadingView.hidden = hidden;
    [self refrechData];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return membersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMember"];
    [cell.contentView clearsContextBeforeDrawing];
    
    NSDictionary *celda = [membersArray objectAtIndex:indexPath.row];
    NSDictionary *pics = [celda valueForKeyPath:@"profile_pic"];
    NSDictionary *thumb = [pics valueForKeyPath:@"thumb"];
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@%@", DEV_BASE_PATH, [thumb valueForKeyPath:@"url"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cell.imageAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    cell.lblUserName.text = [celda valueForKeyPath:@"name"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)editMembers:(id)sender{
    if (self.membersTableView.isEditing) {
        [self.membersTableView setEditing: NO animated: YES];
    } else{
        [self.membersTableView setEditing: YES animated: YES];
    }
}

- (void) endEdit{
    if (self.membersTableView.isEditing) {
        [self.membersTableView setEditing: NO animated: YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *celda = [membersArray objectAtIndex:indexPath.row];
    NSString *idUser = [celda valueForKeyPath:@"id"];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      //  NSLog(@"ELiminar");

        [self deleteGroupUser:self.groupId idUser:[idUser intValue]];
    }
}

- (IBAction)addMembers:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"SearchUser"];
    [cController.navigationController setNavigationBarHidden:NO];
    cController.groupId = self.groupId;
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

-(void) deleteGroupUser:(int) idGroup idUser:(int) idUser{
    NSMutableDictionary *groupParams =  @{@"group_id" : [NSString stringWithFormat:@"%d", idGroup],
                                          @"user_id" : [NSString stringWithFormat:@"%d", idUser]
                                          }.mutableCopy;
    Group_user *groupUser = [[Group_user alloc] init];
    [groupUser delete:1 params:groupParams Success:^(NSMutableDictionary *items) {
        [self refrechData];
        [self.membersTableView reloadData];
    } Error:^(NSError *error) {
    }];
}



@end
