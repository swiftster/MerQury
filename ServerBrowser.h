//
//  ServerBrowser.h
//  QSync
//
//  Created by jtratta on 2/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface ServerBrowser :  NSManagedObject  
{
	NSNetService *netService;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * isConnected;
@property (readwrite, assign) NSNetService *netService; 

@end



