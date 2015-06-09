//
//  GroupMemberTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GroupMemberTableViewCell.h"

@implementation GroupMemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [self.imageAvatar.layer setMasksToBounds:YES];
    [self.imageAvatar.layer setCornerRadius:17.5f];
}

@end
