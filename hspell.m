/* Copyright (C) 2003 Nadav Har'El and Dan Kenigsberg 		*/
/* Modified for HSpellService by Mitz Pettel on Fri Mar 15 2003.*/
/* and on Tue Dec 23 2003.*/
/* and on Fri Dec 2 2005.*/
/* and on Mon May 15 2006.*/
/* and by Nir Soffer on Sun Jul 16 2006.*/

#import <Foundation/Foundation.h>
#import "NSString-MPAdditions.h"
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>

#include "hash.h"
#include "hspell.h"
#ifdef USE_LINGINFO
#include "linginfo.h"
#endif

#define MAX_COMPLETIONS 100

const char *dictionary_base;

#define VERSION_IDENTIFICATION ("@(#) International Ispell Version 3.1.20 " \
			       "(but really Hspell/C %d.%d%s)\n")

// Hebrew letters, cantillation marks and points
#define isUhebrew(c) (((c)>=0x05d0 && (c)<=0x05ea) || ((c)>=0x0591 && (c)<=0x05c2 && (c)!=0x05ba && (c)!=0x05be && (c)!=0x05c0))

static struct dict_radix *dict = NULL;

void initialize()
{
	if (!dict) {
		dictionary_base = [[NSFileManager defaultManager] fileSystemRepresentationWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hebrew.wgz"]];
		hspell_set_dictionary_path(dictionary_base);
		hspell_init(&dict, 0);
	}
}

NSRange hspell( NSSpellServer *spellServer, NSString *stringToCheck, int *wordCount, BOOL countOnly )
{
    // Default value (no match) is {NSNotFound, 0}. This is the same
    // value other range methods return in Cocoa. e.g. -rangeOfString
    NSRange range = NSMakeRange(NSNotFound, 0);

#define MAXWORD 30
	char word[MAXWORD+1], *w;
	int wordLength = 0, offset = 0, wordOffset = 0;
	UniChar uc;
	int res;
	int preflen; /* used by -l */

	int textLength = [stringToCheck length];
	*wordCount = 0;

    initialize();
    
	for( offset = 0; offset<=textLength; offset++ )
    {
		uc = ( offset==textLength ? 0 : [stringToCheck characterAtIndex:offset] );
                
		if(isUhebrew(uc) || uc=='\'' || uc=='"' || uc==0x05f3 || uc==0x05f4){
			/* swallow up another letter into the word (if the word
			 * is too long, lose the last letters) */
			if((wordLength)<MAXWORD)
				word[(wordLength)++]=( uc<0x05d0 ? uc : uc==0x05f3 ? '\'' : uc==0x05f4 ? '"' : uc-0x04f0 );
		} else if(wordLength){
                        (*wordCount)++;
			/* found word seperator, after a non-empty word */
			word[wordLength]='\0';
			(wordOffset) = offset-(wordLength);
			/* TODO: convert two single quotes ('') into one
			 * double quote ("). For TeX junkies. */
                    if ( !countOnly )
                    {
			/* remove quotes from end or beginning of the word
			 * (we do leave, however, single quotes in the middle
			 * of the word - used to signify "j" sound in Hebrew,
			 * for example, and double quotes used to signify
			 * acronyms. A single quote at the end of the word is
			 * used to signify an abbreviate - or can be an actual
			 * quote (there is no difference in ASCII...), so we
			 * must check both possibilities. */
			w=word;
			if(*w=='"' || *w=='\''){
				w++; (wordLength)--; (wordOffset)++;
			}
			if(w[(wordLength)-1]=='"'){
				w[(wordLength)-1]='\0'; (wordLength)--;
			}
			res=hspell_check_word(dict,w,&preflen);
			if(res!=1 && (res=hspell_is_canonic_gimatria(w))){
				if(hspell_debug)
					fprintf(stderr,"found canonic gimatria\n");
				res=1;
			}
			if(res!=1 && w[(wordLength)-1]=='\''){
				/* try again, without the quote */
				w[(wordLength)-1]='\0'; (wordLength)--;
				res=hspell_check_word(dict,w,&preflen);
			}

			if(res){
				if(hspell_debug)
					fprintf(stderr,"correct: %s\n",w);
			} else {
                // Found a misspelled word - but the user may like to
                // ignore it.
                
                NSRange misspelledRange = NSMakeRange(wordOffset, wordLength);
                
                NSString *misspelledWord = [stringToCheck substringWithRange:
                    misspelledRange];
                
                if (![spellServer isWordInUserDictionaries:misspelledWord 
                                             caseSensitive:NO]) {
                    // Remember the rage
                    range =  misspelledRange;
                    
                    if(hspell_debug)
                        fprintf(stderr,"mispelling: %s\n",w);
                    
                    break;
                }			
            }
                    }
			/* we're done with this word: */
			(wordLength)=0;
		}
    }
        
	return range;
}

/* try to find corrections for word */
NSArray *trycorrect( NSString *word, BOOL useGereshAndGershayim )
{
	const char		*w = [word cStringWithEncoding:kCFStringEncodingWindowsHebrew];
	NSMutableArray	*result;
	struct corlist  cl;
	int i;
	
	corlist_init( &cl );

    initialize();

	hspell_trycorrect( dict, w, &cl );
	
	result = [NSMutableArray arrayWithCapacity:cl.n];
	for ( i = 0; i<cl.n; i++ ) {
		NSString *correction = [NSString stringWithCString:cl.correction[i] CFStringEncoding:kCFStringEncodingWindowsHebrew];
        if (useGereshAndGershayim)
            correction = [correction stringByReplacingStraightQuotesWithGershayim];

		[result addObject:correction];
    }
    corlist_free(&cl);
	return result;
}

void foundCompletion(const char *completion, void *context)
{
    [(NSMutableArray *)context addObject:[NSString stringWithCString:completion CFStringEncoding:kCFStringEncodingWindowsHebrew]];
}

NSArray *completions(NSString *word, BOOL useGereshAndGershayim)
{
	const char		*w = [word cStringWithEncoding:kCFStringEncodingWindowsHebrew];
	NSMutableArray	*result = [NSMutableArray arrayWithCapacity:MAX_COMPLETIONS];
	
    initialize();

	hspell_completions(dict, w, MAX_COMPLETIONS, foundCompletion, result);

    if (useGereshAndGershayim) {
        int count = [result count];
        int i;
        for (i = 0; i < count; i++)
            [result replaceObjectAtIndex:i withObject:[[result objectAtIndex:i] stringByReplacingStraightQuotesWithGershayim]];
    }
	
    return [result sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}