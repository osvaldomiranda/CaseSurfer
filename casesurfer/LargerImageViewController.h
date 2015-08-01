//
//  LargerImageViewController.h
//  casesurfer
//
//  Created by Osvaldo on 27-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photoGalery.h"

@interface LargerImageViewController : UIViewController  <photoGaleryDelegate>

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;

@property (nonatomic, retain) photoGalery *scrollView;
@property (nonatomic, strong) NSArray *images;

- (IBAction)back:(id)sender;

@end
