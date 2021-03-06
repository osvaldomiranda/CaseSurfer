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
#import "Utilities.h"
@protocol cropDelegate

- (void)selectImages:(NSMutableArray *)images;

@end


@interface CropViewController : UIViewController<horizontalGridDelegate>

@property (nonatomic, retain) id<cropDelegate> delegate;

@property (nonatomic, retain) HorizontalGrid *scrollView;
@property (nonatomic, assign) NSMutableArray *photos;
@property (nonatomic, retain) NSMutableArray *photosUpload;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) CropInterface *cropper;
@property (nonatomic, strong) Utilities *util;
@property (weak, nonatomic) NSString *caseId;

@property (nonatomic, assign) int indexImage;
@property (nonatomic, assign) BOOL inCropp;
@property (nonatomic, assign) BOOL isNewCase;


@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (void) setOriginalImage:(UIImage *)originalImage;
- (IBAction)trashImage:(id)sender;

- (IBAction)back:(id)sender ;
- (IBAction)createCase:(id)sender;
- (IBAction)SetCroppedImage:(id)sender;
- (IBAction)okCroppedImage:(id)sender;
@end
