//
//  Album.h
//  casesurfer
//
//  Created by Osvaldo on 07-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApiModel.h"
#import "IndexableImageView.h"

@interface Album : BaseApiModel

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) IndexableImageView *image;
-(void) create;
@end
