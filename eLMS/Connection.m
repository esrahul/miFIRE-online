//
//  Connection.m
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/5/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//

#import "Connection.h"
//#import "SBJSON.h"
#import "JSON.h"
#import "DashBoardViewController.h"
//#import "DoleAppDelegate.h"


@implementation Connection
@synthesize delegate;

//Passed the URL string for the post method

-(void) postMethod:(NSString *) getStr passedURL:(NSString *) getURL
{
   // ////NSLog(@"the get str is %@", getStr);

    NSData *requestData = [NSData dataWithBytes: [getStr UTF8String] length: [getStr length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:getURL]];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:requestData];  
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
    
    if( theConnection ){            
        receiveData = [NSMutableData data];
    }  
    
    /*////NSLog(@"getstr is %@ and get url is %@", getStr,getURL);
	//Get the URL String and passed to the NSURL
 	NSURL *url = [NSURL URLWithString:getURL];
	//Passed the URL into the URL Request
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	// Get the length of the XML String
    NSString *msgLength = [NSString stringWithFormat:@"%d", [getStr length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	//Set the Request to the Post Method
    [theRequest setHTTPMethod:@"POST"];
	//Set the HTTP Body for the Request
    [theRequest setHTTPBody: [getStr dataUsingEncoding:NSUTF8StringEncoding]];
	//Initialize the connection for NSURL Connection
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
  	if( theConnection ){
		//Initialize the data and retain the data
 		receiveData = [[NSMutableData data] retain];
	}
	// Release the connection instance
	[theConnection release];*/
    
   /*  NSData *requestData = [NSData dataWithBytes: [getStr UTF8String] length: [getStr length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:getURL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
    
    if( theConnection ){           
        receiveData = [[NSMutableData data] retain];
    }  */
}
-(void) getMethod:(NSString *) getStr
{
    start = [NSDate timeIntervalSinceReferenceDate];
    
	//NSLog(@"the get str is %@", getStr);
  	//Get the URL String and passed to the URL Request
 	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
	//Initialize the connection for NSURL Connection
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
 	if(theConnection)
	{
		//Initialize the data and retain the data
		receiveData = [NSMutableData data];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please check internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				//[alert release];
		
	}

	// Release the connection instance
	//[theConnection release];
} 
 //If the connection is fails to load 
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    ////NSLog(@"It took %f seconds for connection failed ",[NSDate timeIntervalSinceReferenceDate] - start);
    NSString * infoString = [NSString stringWithFormat:@"Switching to Offline Mode.Do Mannual Sync from Settings,once Network connection is Restored."];
    UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Failed" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlert show];
    [HUD hide:YES];
   
    appDelegate = (DoleAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate loadView];
  	
	////NSLog(@"......didFailWithError");
	//[connection release];
}	

//Connection loads a data incrementally
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	////NSLog(@"didReceiveResponse");
	[receiveData setLength:0];
    ////NSLog(@"didReceiveResponse.......%@",response);

}

//If the connection has received the sufficient data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {   
	////NSLog(@"didReceiveData");
	[receiveData appendData:data];
	
}	
//If the connection finished successfully
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	////NSLog(@"It took %f seconds in method <methodname>",[NSDate timeIntervalSinceReferenceDate] - start);
	// Get the data from the server
    ////NSLog(@"%@",receiveData);
 	NSString *urlDataString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
	//NSLog(@"urldata sreing is %@", urlDataString);
   	//Initialize the SBJSON and parsing the JSON data 
 
  	//SBJSON *parser = [[SBJSON alloc] init];
   	//NSError *error = nil;
	//Stored the JSON results into the Mutable Array
 	//resultArray = [NSJSONSerialization JSONObjectWithData: receiveData options: NSJSONReadingMutableContainers error: &error];//[parser objectWithString:urlDataString error:&error];
	//Pass the result array into the delegate method
//    NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	//Here im getting json response so parsing using json files, You can get an xml reponse too.check out for xml response
//	
//	////NSLog(@"the content=%@",contents);
	
	SBJSON *parser = [[SBJSON alloc] init];
   	NSError *error = nil;
	//Stored the JSON results into the Mutable Array
  NSMutableArray *resultArray1 = [parser objectWithString:urlDataString error:&error];
    //NSLog(@"result of appppp is...%@",resultArray1);
	//resultArray
	//contentsArray = [NSMutableArray new];
	accountDict = [[NSMutableDictionary alloc]init];
	
	accountDict = [resultArray1 valueForKey:@"Data"];
	
	resultArray = [accountDict copy];
	//NSArray *results = [accountant objectForKey:@"results"];
	//////NSLog(@"results %@",resultArray);
   //[self addToDatabase];
    //[self submit];
 	[self getResult:resultArray];
    
 }
   
   
//It returns the result array for the partical request
-(void)getResult:(id)_result{
  	//Stored the results in the _result of the Connection delegate Method
	[delegate getResult:_result];
}

@end
