/*
 *  HSSpellChecker.m
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
#import "HSSpellChecker.h"

NSRange hspell( NSSpellServer *spellServer, NSString *stringToCheck, int *wordCount, BOOL countOnly );
NSArray *trycorrect( NSString *word );

@implementation HSSpellChecker

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(int *)wordCount countOnly:(BOOL)countOnly
{
    return hspell( sender, stringToCheck, wordCount, countOnly );
}

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language
{
    return trycorrect(word);
}

@end
