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
-(void) createOrUpdate:(NSString *)albumId action:(NSString *) action  {
    
    NSDictionary *album = @{@"name": self.title};
    
    NSError *error;
    NSData *albumJson = [NSJSONSerialization dataWithJSONObject:album options:kNilOptions error:&error];
    NSString *albumString = [[NSString alloc] initWithData:albumJson encoding:NSUTF8StringEncoding];
    
    albumString = [[NSString stringWithFormat:@"%@", albumString] stringByReplacingOccurrencesOfString:@":" withString:@"=>"];
    albumString = [[NSString stringWithFormat:@"%@", albumString] stringByReplacingOccurrencesOfString:@"\"=>" withString:@"\"=>"];
    
    Session *sess = [[Session alloc] init];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",BASE_PATH, @"/albums.json"]];
    if ([action isEqualToString: @"update"]) {
         url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",BASE_PATH, @"/albums/update.json"]];
    }
    
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

    // add params (all params are strings)
    
    if ([action isEqualToString:@"update"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",albumId] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
   // NSLog(@"IMAGE %@",self.image);
    NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
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

-(void) album_shared: (NSMutableDictionary *) params
      Success:(CaseSuccessArrayBlock)successBlock
        Error:(CaseErrorBlock)errorBlock
{
    
    Session *mySession = [[Session alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth_token": [mySession getToken]}];
   // parameters = @{@"auth_token": [mySession getToken]}.mutableCopy;
    [parameters addEntriesFromDictionary:params];
    
    NSString *url = [NSString stringWithFormat:@"/albums_shared/show.json"];
    
    [[CaseConnect sharedCaseSurfer] getWithUrl:url params:parameters Success:^(NSMutableArray *items) {
        successBlock(items);
    } Error:^(NSError *error) {
         errorBlock(error);
    }];
    
}





@end
