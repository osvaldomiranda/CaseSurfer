//
//  ShareViewController.h
//  casesurfer
//
//  Created by Osvaldo on 15-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareUsersTableViewController.h"
#import "GroupsShareViewController.h"

@interface ShareViewController : UIViewController <ElementToShareDelegate, GroupToShareDelegate>


@property (nonatomic, assign) int caseId;
@property (nonatomic, strong) NSMutableArray *usersShare;
@property (nonatomic, strong) NSMutableArray *groupsShare;

@property (weak, nonatomic) IBOutlet UITextView *txvUsers;
@property (weak, nonatomic) IBOutlet UITextView *txtGroups;

- (IBAction)deleteLast:(id)sender;
- (IBAction)addUsers:(id)sender;
- (IBAction)addGroups:(id)sender;
- (IBAction)deleteLastGroup:(id)sender;

- (IBAction)share:(id)sender;


@end
