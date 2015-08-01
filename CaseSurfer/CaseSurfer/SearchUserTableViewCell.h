//
//  SearchUserTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 29-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDone;

@end
