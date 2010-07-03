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
    
    if ( [spellServer registerLanguage:@"Hebrew" byVendor:@"hspell"] )
    {
        [spellServer setDelegate:[HSSpellChecker new]];
        [spellServer run];
        NSLog( @"Unexpected death of hspell" );
    }
    else
        NSLog( @"Unable to check in hspell" );

    [pool release];
    return 0;
}
