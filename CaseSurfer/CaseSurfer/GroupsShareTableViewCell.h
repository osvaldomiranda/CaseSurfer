//
//  GroupsShareTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 14-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupsShareTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupName;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupMembers;
@property (nonatomic, assign) int groupId;



@end
