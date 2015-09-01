//
//  GroupMembersViewController.h
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "LoadingView.h"

@interface GroupMembersViewController : UIViewController{
    NSMutableArray *membersArray;
}

@property (weak, nonatomic) IBOutlet UITableView *membersTableView;
@property (nonatomic, assign) int groupId;
@property (nonatomic, assign) BOOL pullRefreshVisible;
@property (nonatomic, retain) LoadingView *refreshLoadingView;

- (IBAction)addMembers:(id)sender;
- (IBAction)editMembers:(id)sender;
- (IBAction)back:(id)sender;

@end
