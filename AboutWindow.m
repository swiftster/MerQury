//
//  AboutWindow.m
//  QSync
//
//  Created by jtratta on 12/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutWindow.h"


@implementation AboutWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
    self = [super
			initWithContentRect:contentRect
			styleMask:(NSTitledWindowMask | 
					   NSClosableWindowMask | NSMiniaturizableWindowMask)
					   
			backing:bufferingType
			defer:deferCreation];
    if (self)
    {
        
        [self setBackgroundColor:[NSColor whiteColor]];
		
    }
    return self;
}


	
	

@end
