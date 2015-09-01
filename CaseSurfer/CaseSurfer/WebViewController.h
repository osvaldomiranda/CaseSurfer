//
//  WebViewController.h
//  casesurfer
//
//  Created by Osvaldo on 04-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *leadsWeb;
@property (nonatomic, retain) NSString *urlLead;

- (IBAction)back:(id)sender;

@end
