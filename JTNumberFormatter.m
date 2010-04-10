//
//  JTNumberFormatter.m
//  QSync
//
//  Created by Jason Tratta on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JTNumberFormatter.h"


@implementation JTNumberFormatter



-(BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error

{
	NSNumber *max = [NSNumber numberWithInt:100]; 
	NSNumber *min = [NSNumber numberWithInt:-100]; 
	[self setMaximum:max]; 
	[self setMinimum:min]; 
	
	
	
	
	NSString *minusSign = [self minusSign]; 
	NSString *plusSign = [self plusSign]; 
	
	NSScanner *scanner = [NSScanner scannerWithString:string]; 
	
	//Did the user type a + sign?  
	
	
		
		if ([scanner scanString:plusSign intoString:NULL]) { 
			//NSLog(@"Plus Sign!: StringValue:%f",[string doubleValue]);  
			if([string doubleValue] > 12) { 
				string = [NSString stringWithFormat:@"+12"];
			}
			
		} else {
	
		
          if ([scanner scanString:minusSign intoString:NULL]) { 
			
			//NSLog(@"Minus Sign!");  //Do Nothing 
		  
		
		  } else {
		//NSLog(@"No Prefix");
		
	NSString *tempString = @"-"; 
	NSString *secondTempString = string; 
	string = [tempString stringByAppendingFormat:secondTempString];

		  }

		}

	
	
	//NSLog(@"String:%@ :DblValue:%f",string,[string doubleValue]);
	
	return [super getObjectValue:obj forString:string errorDescription:error];

	}


@end
