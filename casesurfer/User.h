//
//  User.h
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApiModel.h"
#import "IndexableImageView.h"

@interface User : BaseApiModel

-(void) updateProfilePic:(IndexableImageView *)picture;

@end
