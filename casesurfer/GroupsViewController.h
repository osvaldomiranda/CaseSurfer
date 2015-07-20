//
//  GroupsViewController.h
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface GroupsViewController : UIViewController{
    NSMutableArray *itemsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (nonatomic, assign) BOOL pullRefreshVisible;
@property (nonatomic, retain) LoadingView *refreshLoadingView;

- (IBAction)editGroup:(id)sender;
- (IBAction)newGroup:(id)sender;


@end
