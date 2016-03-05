//
//  rollUpdateViewController.h
//  casesurfer
//
//  Created by Osvaldo on 13-09-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HorizontalGrid.h"
#import "CropViewController.h"
@protocol rollUpdateDelegate

- (void)selectImages:(NSMutableArray *)images;

@end

@interface rollUpdateViewController : UIViewController <GridScrollViewDelegate, UIImagePickerControllerDelegate, horizontalGridDelegate>

@property (nonatomic, retain) id<rollUpdateDelegate> delegate;

@property (nonatomic, retain) GridScrollView *scrollView;
@property (nonatomic, retain) HorizontalGrid *scrollViewCover;
@property (nonatomic, assign) UIImage *imageFull;
@property (nonatomic, assign) NSString *collectionId;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) UIImage *fullImage;
@property (nonatomic, strong) Utilities *util;
@property (weak, nonatomic) NSString *caseId;

@property (nonatomic, retain) UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@property (nonatomic, strong) UIImagePickerController *pickerController;

- (IBAction)back:(id)sender;


@end
