//
//  CaseDescripViewController.h
//  casesurfer
//
//  Created by Osvaldo on 08-10-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDescripViewController : UIViewController

@property (nonatomic, retain) NSString *descripText;
@property (weak, nonatomic) IBOutlet UITextView *txtDescript;

@end
