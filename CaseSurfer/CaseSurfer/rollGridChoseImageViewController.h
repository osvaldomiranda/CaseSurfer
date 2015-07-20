//
//  rollGridChoseImageViewController.h
//  casesurfer
//
//  Created by Osvaldo on 14-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridScrollView.h"
#import "IndexableImageView.h"
#import "NewAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface rollGridChoseImageViewController : UIViewController <GridScrollViewDelegate>

@property (nonatomic, retain) GridScrollView *scrollView;
@property (nonatomic, assign) UIImage *imageFull;
@property (nonatomic, assign) NSString *collectionId;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *photos;

- (IBAction)back:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
