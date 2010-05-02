//
//  PreferenceController.m
//  QSync
//
//  Created by Jason Tratta on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"


@implementation PreferenceController



-(id)init 
{ 
	if (![super initWithWindowNibName:@"PreferenceWindow"])
		return nil;
	
	 
	
	return self; 
}

-(void)windowDidLoad 
{ 
	NSLog(@"About Nib is loaded"); 
	
}




@end
