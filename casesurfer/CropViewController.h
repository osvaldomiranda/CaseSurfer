//
//  CropViewController.h
//  casesurfer
//
//  Created by Osvaldo on 26-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalGrid.h"
#import "CropInterface.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface CropViewController : UIViewController<horizontalGridDelegate>

@property (nonatomic, retain) HorizontalGrid *scrollView;
@property (nonatomic, assign) NSMutableArray *photos;
@property (nonatomic, retain) NSMutableArray *photosUpload;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) CropInterface *cropper;
@property (nonatomic, assign) int indexImage;
@property (nonatomic, assign) BOOL inCropp;

- (void) setOriginalImage:(UIImage *)originalImage;
- (IBAction)trashImage:(id)sender;

- (IBAction)back:(id)sender ;
- (IBAction)createCase:(id)sender;
- (IBAction) SetCroppedImage:(id)sender;
- (IBAction) okCroppedImage:(id)sender;
@end
