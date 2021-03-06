//
//  AlbumsViewController.h
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumsViewController : UIViewController <GridScrollViewDelegate>

@property (nonatomic, retain) GridScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *Albums;
@property (nonatomic, assign) int selectedAlbumId;
@property (nonatomic, assign) bool inEdit;
@property (nonatomic, assign) bool ordered;

@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;

- (IBAction)addAction:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)order:(id)sender;
- (IBAction)search:(id)sender;
@end
