// 
// Author of code: Aron Cedercrantz (2009)
// 
// 
// 
//             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
//                    Version 2, December 2004 
// 
// Copyright (C) 2004 Sam Hocevar 
//  14 rue de Plaisance, 75014 Paris, France 
// Everyone is permitted to copy and distribute verbatim or modified 
// copies of this license document, and changing it is allowed as long 
// as the name is changed. 
// 
//            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
//   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
//
//  0. You just DO WHAT THE FUCK YOU WANT TO. 
//
// This program is free software. It comes without any warranty, to
// the extent permitted by applicable law. You can redistribute it
// and/or modify it under the terms of the Do What The Fuck You Want
// To Public License, Version 2, as published by Sam Hocevar. See
// http://sam.zoy.org/wtfpl/COPYING for more details.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

void detailedOutput(NSArray *);

int main (int argc, const char * argv[]) {	
	SCDynamicStoreRef dynStore = SCDynamicStoreCreate(
		NULL,
		(CFStringRef) [[NSBundle mainBundle] bundleIdentifier],
		NULL,
		NULL
	);
	
	CFArrayRef setupRef = SCDynamicStoreCopyKeyList(dynStore, (CFStringRef)@"Setup:.*");
	CFArrayRef stateRef = SCDynamicStoreCopyKeyList(dynStore, (CFStringRef)@"State:.*");
	CFArrayRef pluginRef = SCDynamicStoreCopyKeyList(dynStore, (CFStringRef)@"Plugin:.*");
	CFArrayRef comRef = SCDynamicStoreCopyKeyList(dynStore, (CFStringRef)@"[a-zA-Z]+\\..*");
	
	NSLog(@"\n\nState:");
	detailedOutput((NSArray *)stateRef);
	NSLog(@"\n\nSetup:");
	detailedOutput((NSArray *)setupRef);
	NSLog(@"\n\nPlugin:");
	detailedOutput((NSArray *)pluginRef);
	NSLog(@"\n\ncom.*:");
	detailedOutput((NSArray *)comRef);
	
	CFRelease(setupRef);
	CFRelease(stateRef);
	CFRelease(pluginRef);
	CFRelease(comRef);
	CFRelease(dynStore);

    return 0;
}


void detailedOutput(NSArray *arr) {
	NSMutableString *outputBuffer = [NSMutableString string];
	
	SCDynamicStoreRef dynStore = SCDynamicStoreCreate(
		NULL,
		CFSTR("SCKDetailedOutputInfoDynStore"),
		NULL,
		NULL
	);
	
	NSString *item = nil;
	CFDictionaryRef plitsDict = NULL;
	for(item in arr) {
		plitsDict = SCDynamicStoreCopyValue(dynStore, (CFStringRef)item);
		[outputBuffer appendFormat:@"\n\"%@\":\n%@", item, (NSDictionary *)plitsDict];
		CFRelease(plitsDict); plitsDict = NULL;
	}
	
	NSLog(@"%@", outputBuffer);

	CFRelease(dynStore);
}
