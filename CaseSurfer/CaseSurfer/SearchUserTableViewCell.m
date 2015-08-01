//
//  SearchUserTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 29-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "SearchUserTableViewCell.h"

@implementation SearchUserTableViewCell

- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

-(void)layoutSubviews
{
    [self.imageAvatar.layer setMasksToBounds:YES];
    [self.imageAvatar.layer setCornerRadius:17.5f];
}

@end
