//
//  LargerImageViewController.h
//  casesurfer
//
//  Created by Osvaldo on 27-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargerImageViewController : UIViewController

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;

- (IBAction)back:(id)sender;

@end
