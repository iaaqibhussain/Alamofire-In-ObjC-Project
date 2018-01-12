//
//  ViewController.m
//  AlamofireInObjC
//
//  Created by Aaqib Hussain on 12/01/2018.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

#import "ViewController.h"
#import <Alamofire/Alamofire-Swift.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = @"https://jsonplaceholder.typicode.com/todos/1";
//    [AlamofireWrapper requestWithMethod:RequestMethodGET URLString:url parameters:nil encoding:RequestParameterEncodingURL headers:nil success:^(NSURLRequest* request, NSHTTPURLResponse* response, id* json) {
//        NSLog(@"%@", json);
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError * error) {
//        
//    }];
    
    [AlamofireWrapper requestWithMethod:RequestMethodGET URLString:url parameters:nil encoding:RequestParameterEncodingURL headers:nil success:^(NSURLRequest * req, NSHTTPURLResponse * resp, id json) {
       
        NSDictionary *data = (NSDictionary*)json;
        NSLog(@"Data:%@",[data valueForKey:@"title"]);
    } failure:^(NSURLRequest *req,  NSHTTPURLResponse * resp, NSError * error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
