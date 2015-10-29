//
//  UserTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 29-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UserTableViewController.h"
#import "User.h"
#import "SearchUserTableViewCell.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"
#import "SearchUser.h"
#import "Group.h"


@interface UserTableViewController ()

@end

@implementation UserTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self setRightButton];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    itemsArray = [[NSMutableArray alloc] init];
    self.filteredUserArray  = [[NSMutableArray alloc] init];
    self.usersArray  = [[NSMutableArray alloc] init];
    self.usersToAdd = [[NSMutableArray alloc] init];
    
    
    [self refrechData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) setRightButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"+Done"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(done:)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}
 

-(void) refrechData{
    NSMutableDictionary *userParams =  @{}.mutableCopy;
    User *user = [[User alloc] initWithParams:userParams];
    
    [user index:userParams Success:^(NSArray *items) {
        [self fillImtensArray:items];
    } Error:^(NSError *error) {
    }];
}

-(void) fillImtensArray:(NSArray *) items{
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
        
        NSString *name = [item valueForKeyPath:@"name"];
        NSString *idUser = [item valueForKeyPath:@"id"];
        NSString *username = [item valueForKeyPath:@"username"];
        SearchUser *sUser = [[SearchUser alloc] initWithName:name andId:idUser username:username];
        [self.filteredUserArray addObject:sUser];
        [self.usersArray addObject:sUser];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredUserArray.count;
    }
    else {
         return itemsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchUserCell";
    SearchUserTableViewCell *cell = (SearchUserTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[SearchUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *celda;
    
    
    NSString *url;
    
    NSLog(@"GIGUALDAD  %d, tableView %@, result %@",tableView == self.searchDisplayController.searchResultsTableView,tableView, self.searchDisplayController.searchResultsTableView);
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchUser *sUser = [self.filteredUserArray objectAtIndex:indexPath.row];
        cell.lblUserName.text = sUser.name;
        cell.lblDone.text = @"";
        
    } else {
        
            celda = [itemsArray objectAtIndex:indexPath.row];
            
            NSDictionary *ppic= [celda valueForKeyPath:@"profile_pic"];
            NSDictionary *profile_pic = [ppic valueForKeyPath:@"profile_pic"];
            NSDictionary *thumb = [profile_pic valueForKeyPath:@"thumb"];
            url = [thumb valueForKeyPath:@"url"];
            
            cell.lblUserName.text = [celda valueForKeyPath:@"name"];
            cell.lblDone.text = @"";
    
    }
   
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", url];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cell.imageAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    
 
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *celda;
    NSString *userId;
    NSString *userName;
    NSString *name;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchUser *sUser = [self.filteredUserArray objectAtIndex:indexPath.row];
        userId = sUser.idUser;
        userName = sUser.username;
        name = sUser.name;
    }
    else {
        celda = [itemsArray objectAtIndex:indexPath.row];
        name = [celda valueForKeyPath:@"name"];
        userId = [celda valueForKeyPath:@"id"];
        userName = [celda valueForKeyPath:@"username"];
    }
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self adduserToGroup:userId userName:userName name:name];
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            [self done:self];
        }
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *celda;
    NSString *userId;
    NSString *userName;
    NSString *name;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchUser *sUser = [self.filteredUserArray objectAtIndex:indexPath.row];
        userId = sUser.idUser;
        userName = sUser.username;
        name = sUser.name;
    }
    else {
        celda = [itemsArray objectAtIndex:indexPath.row];
        name = [celda valueForKeyPath:@"name"];
        userId = [celda valueForKeyPath:@"id"];
        userName = [celda valueForKeyPath:@"username"];
    }
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self removeUserToGroup:userId userName:userName name:name];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return indexPath;
}
#pragma mark - TableView Delegate


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredUserArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    self.filteredUserArray = [NSMutableArray arrayWithArray:[self.usersArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}


- (void)adduserToGroup:(NSString *)userId userName:(NSString *)userName name:(NSString *)name {
    SearchUser *sUser = [[SearchUser alloc] initWithName:name andId:userId username:userName];
    [self addUserToArray:sUser];
}

- (void) addUserToArray:(SearchUser *)user{
    BOOL find=false;
    for (SearchUser *u in self.usersToAdd) {
        if (u.idUser == user.idUser) {
            find = true;
        }
    }
    if (!find) {
        [self.usersToAdd addObject:user];
    }
}

- (void)removeUserToGroup:(NSString *)userId userName:(NSString *)userName name:(NSString *)name {
    SearchUser *sUser = [[SearchUser alloc] initWithName:name andId:userId username:userName];
    [self delUserToArray:sUser];
}

- (void) delUserToArray:(SearchUser *)user{
    int i = 0;
    for (SearchUser *u in self.usersToAdd) {
        if (u.idUser == user.idUser) {
            [self.usersToAdd removeObjectAtIndex:i];
        }
        i++;
    }
}

- (IBAction)done:(id)sender{
    if (self.usersToAdd.count>0)  {
        
        NSString *receivers = [self getReceivers];
        NSMutableDictionary *shareData = @{@"group_user_ids": receivers,
                                           }.mutableCopy;
        NSMutableDictionary *medcaseParams =  @{@"group" : shareData}.mutableCopy;
        
        Group *group = [[Group alloc] init];
        [group update:self.groupId params:medcaseParams Success:^(NSMutableDictionary *items) {
            [self.navigationController popViewControllerAnimated:TRUE];
        } Error:^(NSError *error) {
            
        }];
    }
 //   {"utf8"=>"✓", "authenticity_token"=>"afJrGhc0rZmyvHRdtnMI/DWsw5y+V904czuBPwV2qSM=", "group"=>{"group_user_ids"=>"[osva2] - osva2"}, "commit"=>"Add members", "id"=>"1"}
}


-(NSString *) getReceivers {
    NSString *receiv = @"";
    int i=0;
    for (SearchUser *user in self.usersToAdd) {
        if(i==0){
            receiv = [NSString stringWithFormat:@"[%@] - %@", user.username, user.username];
        }
        else{
            receiv = [NSString stringWithFormat:@"%@,[%@] - %@",receiv, user.username, user.username];
        }
        i++;
    }
    return receiv;
}





@end
