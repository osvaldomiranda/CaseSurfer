//
//  ShareUsersTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 14-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareUsersTableViewCell.h"

@protocol ElementToShareDelegate <NSObject>
- (void)addElementToShare:(NSString *)userId
                 userName:(NSString *)userName
                     name:(NSString *)name;
@end

@interface ShareUsersTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>{
    NSMutableArray *itemsArray;
}

@property (nonatomic, assign) int groupId;
@property (nonatomic, assign) NSString *groupName;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (strong,nonatomic) NSMutableArray *usersArray;
@property (strong,nonatomic) NSMutableArray *filteredUserArray;
@property (nonatomic, assign) id<ElementToShareDelegate> delegate;


@end
