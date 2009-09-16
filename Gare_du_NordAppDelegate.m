//
//  Gare_du_NordAppDelegate.m
//  Gare du Nord
//
//  Created by Wesley Moore on 15/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Gare_du_NordAppDelegate.h"

@implementation Gare_du_NordAppDelegate

@synthesize window;
@synthesize progress_bar;
@synthesize progress_label;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (IBAction)depart:(id)sender {
	//NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:1000];
	NSURL *url = [NSURL URLWithString:@"http://www.bom.gov.au/fwo/IDV60901/IDV60901.94868.axf"];
	NSOperationQueue *q = [[NSOperationQueue alloc] init];
	
	[q addOperationWithBlock:^ {
		NSString *issues;
		NSArray *lines;
		NSError *errors;
		NSStringEncoding encoding;
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
			[progress_label setStringValue:@"Getting issues"];
			[progress_bar startAnimation:sender];
		}];
		
		issues = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&errors];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
			[progress_bar stopAnimation:sender];
			[progress_label setStringValue:@"Done"];
		}];

		lines = [self linesInString:issues];

		[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
			// Setup the progress bar
			[progress_bar setMaxValue:[lines count]];
			[progress_label setStringValue:@"Processing records"];
		}];
	
		[lines enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger index, BOOL *stop) {
			// Do something with the line here like parse the CSV record
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
				[progress_bar incrementBy:1];
			}];
		}];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
			[progress_label setStringValue:@"Processing done"];
		}];
	}];

	[q release];
}

- (NSArray *)linesInString:(NSString *)string {
	NSUInteger length = [string length];
	NSUInteger line_start = 0, line_end = 0, contents_end = 0;
	NSMutableArray *lines = [[NSMutableArray alloc] init];
	NSRange current_range;
	NSArray *result;
	
	while(line_end < length) {
		[string getLineStart:&line_start end:&line_end contentsEnd:&contents_end forRange:NSMakeRange(line_end, 0)];
		current_range = NSMakeRange(line_start, contents_end - line_start);
		[lines addObject:[string substringWithRange:current_range]];
	}
	
	result = [NSArray arrayWithArray:lines];
	[lines release];
	return result;
}

@end
