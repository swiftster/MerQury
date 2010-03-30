//
//  OutputTextFields.m
//  QSync
//
//  Created by Jason Tratta on 3/30/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import "OutputTextFields.h"


@implementation OutputTextFields


- (void)textDidEndEditing:(NSNotification *)notification
{
	NSLog(@"Output Text Field Edited");
	
}

-(void)textDidChange:(NSNotification *)aNotification
{
	NSLog(@"Value Changed"); 
	
}


@end
