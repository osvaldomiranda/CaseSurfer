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
#import <AssetsLibrary/AssetsLibrary.h>

@protocol selectImageDelegate <NSObject>
- (void)onSelectImage:(IndexableImageView *) image;
@end



@interface rollGridChoseImageViewController : UIViewController <GridScrollViewDelegate>

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (nonatomic, retain) GridScrollView *scrollView;
@property (nonatomic, assign) UIImage *imageFull;
@property (nonatomic, assign) NSString *collectionId;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *photos;

@property (nonatomic, assign) id<selectImageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) UIImagePickerController *pickerController;

- (IBAction)back:(id)sender;


@end
