/*
 *  main.m
 *  HSPellService
 *
 *  Created by Mitz Pettel on Fri Oct 25 2003.
 *  Copyright (c) 2003 Mitz Pettel <source@mitzpettel.com>. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */
#import <Foundation/Foundation.h>
#import "HSSpellChecker.h"

int main(int argc, const char * argv[])
{
    NSAutoreleasePool	*pool = [[NSAutoreleasePool alloc] init];
    NSSpellServer	*spellServer = [[NSSpellServer alloc] init];
	
	[[NSUserDefaults standardUserDefaults]
		registerDefaults:[NSDictionary
			dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:YES],  HSSuicideSettingName,
				[NSNumber numberWithBool:NO],  HSLogSettingName,
				nil
		]
	];
    
    if ( [spellServer registerLanguage:LANG_HEBREW byVendor:VENDOR_HSPELL] )
    {
        [spellServer setDelegate:[HSSpellChecker new]];
		
		if ( [[NSUserDefaults standardUserDefaults] boolForKey:HSLogSettingName] )
			NSLog( @"Starting spell server" );
			
        [spellServer run];
		
        NSLog( @"Terminated unexpectedly" );
    }
    else
        NSLog( @"Couldn't register" );

    [pool release];
    return 0;
}
