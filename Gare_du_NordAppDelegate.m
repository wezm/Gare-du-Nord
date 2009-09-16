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
@synthesize go_button;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (IBAction)depart:(id)sender {
	//NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:1000];
	NSURL *url = [NSURL URLWithString:@"http://www.bom.gov.au/fwo/IDV60901/IDV60901.94868.axf"];
	dispatch_queue_t global_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	[progress_label setStringValue:@"Getting issues"];
	[progress_bar startAnimation:sender];
	[go_button setEnabled:NO];	
	
	dispatch_async(global_q, ^{
		NSArray *lines;
		NSError *errors;
		NSStringEncoding encoding;
		NSString *issues = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&errors];
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[progress_bar stopAnimation:sender];
			[progress_label setStringValue:@"Done"];
		});
		
		lines = [self linesInString:issues];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			// Setup the progress bar
			[progress_bar setIndeterminate:NO];
			[progress_bar setMaxValue:[lines count]];
			[progress_label setStringValue:[NSString stringWithFormat:@"Processing %d records", [lines count]]];
		});
		
		[lines enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger index, BOOL *stop) {
			// Do something with the line here like parse the CSV record
			//usleep(100000);
			int max = 90000000;
			for(int i = 0; i <= 90000000; i++) {
				if(i == max) NSLog(@"%d done", index);
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				[progress_bar incrementBy:1];
			});
		}];

		dispatch_async(dispatch_get_main_queue(), ^{
			[progress_label setStringValue:@"Processing done"];
			[progress_bar setIndeterminate:YES];
			[progress_bar setDoubleValue:0];
			[go_button setEnabled:YES];
		});
		
		[pool drain];
	});
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
