//
//  WebViewController.m
//  casesurfer
//
//  Created by Osvaldo on 04-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController



- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL* nsUrl = [NSURL URLWithString:self.urlLead];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    
    self.leadsWeb.delegate = self;
    [self.leadsWeb loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (IBAction)back:(id)sender {
  
    [self.navigationController popViewControllerAnimated:TRUE];
}





@end
