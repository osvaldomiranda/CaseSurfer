//
//  rollGridViewController.h
//  Cranberry
//
//  Created by Osvaldo on 23-01-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridScrollView.h"
#import "HorizontalGrid.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface rollGridViewController : UIViewController <GridScrollViewDelegate, horizontalGridDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, retain) HorizontalGrid *scrollViewH;
@property (nonatomic, retain) GridScrollView *scrollView;
@property (nonatomic, assign) UIImage *imageFull;
@property (nonatomic, assign) NSString *collectionId;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) UIImagePickerController *pickerController;

- (IBAction)back:(id)sender;
- (IBAction) callCrop:(id)sender;

@end
