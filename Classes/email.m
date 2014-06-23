//
//  email.m
//  sendgrid-ios-demo
//
//  Created by Heitor Sergent on 6/23/14.
//  Copyright (c) 2014 heitortsergent. All rights reserved.
//

#import "Email.h"

@implementation Email

-(id)init {
    self = [super init];
    if (self) {
        self.headers = [NSMutableDictionary new];
        [self setInlinePhoto:false];
    }
    return self;
}

- (void) attachImage:(UIImage *)img {
    //attaches image to be posted
    if (self.imgs == NULL)
        self.imgs = [[NSMutableArray alloc] init];
    [self.imgs addObject:img];
}

- (NSString *)headerEncode:(NSMutableDictionary *)header{
    //Converts NSDictionary of Header arguments to JSON string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:header
                                                       options:0
                                                         error:&error];
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    if (!jsonData)
        NSLog(@"JSON error: %@", error);
    
    
    return JSONString;
}

- (void)addCustomHeader:(id)value withKey:(id)key{
    //Adds custom header arguments to header dictionary
    
    [self.headers setObject:value forKey:key];
}

- (void)configureHeader
{
    //Items to add to Header and convert to json
    if(self.toList != nil){
        [self.headers setObject:self.toList forKey:@"to"];
        self.to = [self.toList objectAtIndex:0];
    }
    
    
    if(self.headers != nil)
        self.xsmtpapi = [self headerEncode:self.headers];
}

- (NSDictionary *)parametersDictionary:(NSString *)apiUser apiKey:(NSString *)apiKey
{
    //Building up Parameter Dictionary
    NSMutableDictionary *parameters =[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"api_user": apiUser,
                                                                                     @"api_key": apiKey,
                                                                                     @"subject":self.subject, @"from":self.from, @"html":self.html,@"to":self.to, @"text":self.text, @"x-smtpapi":self.xsmtpapi}];
    
    
    //optional parameters
    if(self.bcc != nil)
        [parameters setObject:self.bcc forKey:@"bcc"];
    
    if(self.toName != nil)
        [parameters setObject:self.toName forKey:@"toname"];
    
    if(self.fromName != nil)
        [parameters setObject:self.fromName forKey:@"fromname"];
    
    if(self.replyTo != nil)
        [parameters setObject:self.replyTo forKey:@"replyto"];
    
    if(self.date != nil)
        [parameters setObject:self.date forKey:@"date"];
    
    if(self.inlinePhoto)
    {
        for (int i = 0; i < self.imgs.count; i++)
        {
            
            NSString *filename = [NSString stringWithFormat:@"image%d.png", i];
            NSString *key = [NSString stringWithFormat:@"content[image%d.png]", i];
            NSLog(@"name: %@, Filename: %@", key, filename);
            [parameters setObject:filename forKey:key];
            
        }
    }
    
    return parameters;
}

@end
