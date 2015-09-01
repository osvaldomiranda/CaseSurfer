//
//  UserTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 29-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>{
    NSMutableArray *itemsArray;
}

@property (nonatomic, assign) int groupId;
@property (nonatomic, assign) NSString *groupName;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (strong,nonatomic) NSMutableArray *usersArray;
@property (strong,nonatomic) NSMutableArray *filteredUserArray;

@property (strong,nonatomic) NSMutableArray *usersToAdd;

@end
