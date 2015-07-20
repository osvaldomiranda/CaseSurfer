//
//  NewAlbumViewController.h
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexableImageView.h"

@interface NewAlbumViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (nonatomic, retain) IndexableImageView *imageInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;

@end
