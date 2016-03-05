//
//  ShareUsersTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 14-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ShareUsersTableViewController.h"
#import "User.h"
#import "SearchUserTableViewCell.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"
#import "SearchUser.h"
#import "Group.h"
#import "ShareUsersTableViewCell.h"


@interface ShareUsersTableViewController ()

@end

@implementation ShareUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    itemsArray = [[NSMutableArray alloc] init];
    self.filteredUserArray  = [[NSMutableArray alloc] init];
    self.usersArray  = [[NSMutableArray alloc] init];
  
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
    
    static NSString *CellIdentifier = @"ShareUserCell";
    ShareUsersTableViewCell *cell = (ShareUsersTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ShareUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *celda;
    
    
    NSString *url;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchUser *sUser = [self.filteredUserArray objectAtIndex:indexPath.row];
        cell.lblUserName.text = sUser.name;
    }
    else {
        celda = [itemsArray objectAtIndex:indexPath.row];
        NSDictionary *ppic= [celda valueForKeyPath:@"profile_pic"];
        NSDictionary *profile_pic = [ppic valueForKeyPath:@"profile_pic"];
        NSDictionary *thumb = [profile_pic valueForKeyPath:@"thumb"];
        url = [thumb valueForKeyPath:@"url"];
        cell.lblUserName.text = [celda valueForKeyPath:@"name"];
    }

    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", url];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cell.imageAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    
    return cell;
}



#pragma mark - TableView Delegate
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
        [self.delegate addElementToShare:userId userName:userName name:name];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.delegate addElementToShare:userId userName:userName name:name];
        if (tableView == self.searchDisplayController.searchResultsTableView){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

    
    
    
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.delegate addElementToShare:@"1" userName:@"prueba" name:@"prueba"];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;        
    }
    return indexPath;
}



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



@end
