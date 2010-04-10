//
//  DataViewController.h
//  QSync
//
//  Created by Jason Tratta on 1/3/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LevelTextField.h"
@class QSyncController; 


@interface DataWindowController : NSWindowController {
	
	QSyncController *appDelegate;
	NSManagedObjectContext *moc; 
	IBOutlet NSTreeController *cuesController; 
	IBOutlet NSTableView *masterTable; 
	
	IBOutlet LevelTextField *masterText; 
	IBOutlet LevelTextField *outputOne, *outputTwo, *outputThree, *outputFour, *outputFive, *outputSix, *outputSeven, *outputEight, *outputNine, 
							*outputTen, *outputEleven, *outputTweleve, *outputThirteen, *outputFourteen, *outputFifteen, *outputSixteen, *outputSeventeen, 
							*outputEightteen, *outputNineteen, *outputTwenty, *outputTwentyOne, *outputTwentyTwo, *outputTwentyThree, *outputTwentyFour, 
							*outputTwentyFive, *outputTwentySix, *outputTwentySeven, *outputTwentyEight, *outputTwentyNine, *outputThirty, *outputThirtyOne,
							*outputThirtyTwo, *outputThirtyThree, *outputThirtyFour, *outputThirtyFive, *outputThirtySix, *outputThirtySeven, *outputThirtyEight,
							*outputThirtyNine, *outputFourty, *outputFourtyOne, *outputFourtyTwo, *outputFourtyThree, *outputFourtyFour, *outputFourtyFive, 
							*outputFourtySix, *outputFourtySeven, *outputFourtyEight;
	
	
}

@property (assign) QSyncController *appDelegate;


- (void)setManagedObjectContext:(NSManagedObjectContext *)value;
- (NSManagedObjectContext *)managedObjectContext;

- (DataWindowController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc appDelegate:(QSyncController *)delegate;



- (NSArray*)allCuesSortedBySortID; 
-(IBAction)refreshData:(id)sender;
-(IBAction)test:(id)sender; 


-(NSArray *)selectedCue;

-(double)formatLevelText:(NSString *)string;



@end
