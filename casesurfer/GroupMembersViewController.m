//
//  GroupMembersViewController.m
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GroupMembersViewController.h"
#import "GroupMemberTableViewCell.h"
#import "Member.h"
#import "Definitions.h"
#import "UserTableViewController.h"

@interface GroupMembersViewController ()

@end

@implementation GroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle: self.groupName];
    
    self.refreshLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 64, 400, 60)];
    self.refreshLoadingView.hidden = YES;
    self.pullRefreshVisible = NO;
    [self.view addSubview:self.refreshLoadingView];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    self.membersTableView.separatorColor = [UIColor clearColor];
    itemsArray = [[NSMutableArray alloc] init];
    [self refrechData];
    
   // self.membersTableView.allowsMultipleSelectionDuringEditing = NO;
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:TRUE];
}


-(void) refrechData{
    [self fillImtensArray:self.members];
  /*
    NSMutableDictionary *groupParams =  @{}.mutableCopy;
    Member *members = [[Member alloc] initWithParams:groupParams];
    
    [members index:groupParams Success:^(NSArray *items) {
        
        NSLog(@"Members %@",items);
        
        [self fillImtensArray:items];
        if (self.pullRefreshVisible) {
            [self loadingViewVisible:NO];
        }
    } Error:^(NSError *error) {
    }];
  */
}

-(void) fillImtensArray:(NSArray *) items{
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
    }
    [self.membersTableView reloadData];
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMember"];
    [cell.contentView clearsContextBeforeDrawing];
    
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    
    NSDictionary *pics = [celda valueForKeyPath:@"profile_pic"];
    NSDictionary *thumb = [pics valueForKeyPath:@"thumb"];
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", [thumb valueForKeyPath:@"url"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cell.imageAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    cell.lblUserName.text = [celda valueForKeyPath:@"name"];
   
    
    return cell;
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  /*  if (scrollView.contentOffset.y < -20){
        if (!self.pullRefreshVisible){
            [self loadingViewVisible:YES];
        }
    }
   */
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

- (IBAction)addMembers:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"SearchUser"];
    [cController.navigationController setNavigationBarHidden:NO];
    cController.groupName = self.groupName;
    cController.groupId = self.groupId;
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (IBAction)editMembers:(id)sender {
    if (self.membersTableView.isEditing) {
        [self.membersTableView setEditing: NO animated: YES];
    } else{
        [self.membersTableView setEditing: YES animated: YES];
    }
}



@end
