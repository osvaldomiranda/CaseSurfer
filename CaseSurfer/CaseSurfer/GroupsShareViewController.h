//
//  GroupsShareViewController.h
//  casesurfer
//
//  Created by Osvaldo on 14-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@protocol GroupToShareDelegate <NSObject>
- (void)addGroupToShare:(NSString *)groupId
                 groupName:(NSString *)groupName;
@end

@interface GroupsShareViewController : UIViewController{
    NSMutableArray *itemsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (nonatomic, assign) BOOL pullRefreshVisible;
@property (nonatomic, retain) LoadingView *refreshLoadingView;
@property (nonatomic, assign) id<GroupToShareDelegate> delegate;


@end
