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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    itemsArray = [[NSMutableArray alloc] init];
    self.filteredUserArray  = [[NSMutableArray alloc] init];
    self.usersArray  = [[NSMutableArray alloc] init];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self refrechData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) refrechData{
    NSMutableDictionary *userParams =  @{}.mutableCopy;
    User *user = [[User alloc] initWithParams:userParams];
    
    [user index:userParams Success:^(NSArray *items) {
        [self fillImtensArray:items];
        
        NSLog(@"users: %@",items);
        
    } Error:^(NSError *error) {
    }];
}

-(void) fillImtensArray:(NSArray *) items{
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
        
        NSString *name = [item valueForKeyPath:@"name"];
        NSString *idUser = [item valueForKeyPath:@"id"];
        SearchUser *sUser = [[SearchUser alloc] initWithName:name andId:idUser];
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
         return itemsArray.count+1;
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchUser *sUser = [self.filteredUserArray objectAtIndex:indexPath.row];
        cell.lblUserName.text = sUser.name;
        cell.lblDone.text = @"";
        
    } else {
        
        if (indexPath.row>0) {
            celda = [itemsArray objectAtIndex:indexPath.row-1];
            
            NSDictionary *ppic= [celda valueForKeyPath:@"profile_pic"];
            NSDictionary *profile_pic = [ppic valueForKeyPath:@"profile_pic"];
            NSDictionary *thumb = [profile_pic valueForKeyPath:@"thumb"];
            url = [thumb valueForKeyPath:@"url"];
            
            cell.lblUserName.text = [celda valueForKeyPath:@"name"];
            cell.lblDone.text = @"";
        }
        else{
            cell.lblUserName.text = [NSString stringWithFormat:@"Add Members to %@"  ,self.groupName];
            cell.lblDone.text = @"Done";
            url = @"";
        }
    }
   
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", url];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cell.imageAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    
 
    return cell;
}




#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row>0) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        if (tableView != self.searchDisplayController.searchResultsTableView){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    

    
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row>0) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    return indexPath;

}



-(void) addMember {
 /*
    NSDictionary *groupData = @{@"name": self.txtGroupName.text, @"group_user_ids": @""};
    
    NSMutableDictionary *groupParams =  @{@"group" : groupData}.mutableCopy;
    
    Group *group = [[Group alloc] initWithParams:groupParams];
    
    
    
    [group save:groupParams withSession:YES Success:^(NSMutableDictionary *items) {
        
    
        
    } Error:^(NSError *error) {
    }];
*/
}



#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredUserArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSLog(@"Users Array %@",self.usersArray);
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



@end
