//
//  NewAlbumViewController.h
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexableImageView.h"
#import "rollGridChoseImageViewController.h"

@interface NewAlbumViewController : UIViewController <selectImageDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (nonatomic, retain) IndexableImageView *imageInfo;
@property (nonatomic, assign) int albumId;

- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)selectImage:(id)sender;

@end
