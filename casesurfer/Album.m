//
//  Album.m
//  casesurfer
//
//  Created by Osvaldo on 07-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "Album.h"
#import "session.h"
#import "Definitions.h"

@implementation Album
-(void) create {
    
    NSDictionary *album = @{@"name": self.title};
    
    NSError *error;
    NSData *albumJson = [NSJSONSerialization dataWithJSONObject:album options:kNilOptions error:&error];
    NSString *albumString = [[NSString alloc] initWithData:albumJson encoding:NSUTF8StringEncoding];
    
    albumString = [[NSString stringWithFormat:@"%@", albumString] stringByReplacingOccurrencesOfString:@":" withString:@"=>"];
    albumString = [[NSString stringWithFormat:@"%@", albumString] stringByReplacingOccurrencesOfString:@"\"=>" withString:@"\"=>"];
    
    Session *sess = [[Session alloc] init];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",BASE_PATH,@"/albums.json"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------BOUNDARY-------";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"auth_token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[sess getToken]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"album"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",albumString] dataUsingEncoding:NSUTF8StringEncoding]];
    
   
        NSData *imageData = UIImageJPEGRepresentation(self.image.image, 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"cover"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            NSString *resp = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"%@",resp);
            //          successBlock(resp);
        }
    }];
    
}

@end
