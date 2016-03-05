//
//  AvatarTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 07-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexableImageView.h"

@interface AvatarTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, assign) IndexableImageView *imageInfo;
@property (nonatomic, assign) NSString *userId;

- (IBAction)update:(id)sender;
@end
