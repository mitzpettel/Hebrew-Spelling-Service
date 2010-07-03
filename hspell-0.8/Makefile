# Hspell Makefile
# Copyright (C) 2002-2004 Nadav Har'El and Dan Kenigsberg
# Modified for the Hebrew Spelling Service on 2004-06-21 by Mitz Pettel

# Locale override:
# Some of the things we do here (like sort), and Perl scripts we run can be
# distracted by the user's locale setting, which are irrelevant (Hspell's
# source and data are all in ISO-8859-8, and that has nothing to do with the
# builder's choice of locale). So we need to override them. The best would
# have been to do:
#     export LANG=C
#     export LC_ALL=C
# But the "export" directive is only supported by Gnu make, so let's instead
# redfine all the relevant LC_* variables the user might have set... Note that
# the following only modified environment variables that were already exported
# by the user - which is actually ok (but this makes us have to set all these
# different variables).
LANG=C
LC_ALL=C
LC_CTYPE=C
LC_COLLATE=C



# build and installation paths
prefix = /usr/local
exec_prefix = ${prefix}

DESTDIR =
PREFIX = /usr/local
BIN = ${exec_prefix}/bin
SHARE = ${prefix}/share/hspell
LIBEXEC = ${exec_prefix}/libexec/hspell
MAN1 = ${prefix}/man/man1
MAN3 = ${prefix}/man/man3
LIBDIR = ${exec_prefix}/lib
INCLUDEDIR = ${prefix}/include

PERL=/usr/bin/perl
CC=gcc

DEFS=-DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_ZLIB=1 
CFLAGS=-g -O2 -DDICTIONARY_BASE=\"$(DICTBASE)\"
LIBS=-lz 
CPPFLAGS=
LDFLAGS=

DICTBASE=$(SHARE)/hebrew.wgz

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(DEFS) $<

# Our TARGETS variable chooses what to compile. Some things are
# optionally compiled depending on --enable-* paramters to configure.
TARGETS = hebrew.wgz.sizes prefixes.c
all: $(TARGETS)

# SEDCMD controls on whether objective-kinuyim - about 130,000 rare verb
# forms - are left during build or removed. It is set to the appropriate
# strings when "configure" is run (depending on whether --enable-fatverb
# is given).
SEDCMD=/\+/d

# EXTRAOBJECTS - for --enable-linginfo
EXTRAOBJECTS=

clean:
	rm -f out.nouns out.verbs out.nouns-shemp hspell.pl_full \
	      hspell.pl_wzip wunzip wordlist.wgz shemp.dat \
              corlist.o dict_radix.o find_sizes.o gimatria.o \
	      hspell.o tclHash.o hebrew.wgz hebrew.wgz.sizes \
	      hebrew.wgz.prefixes dout.nouns.shemp.gz shemp.dat \
	      dout.nouns.wolig.gz dout.verbs.gz hspell find_sizes \
	      prefixes.c libhspell.o libhspell.a \
	      hebrew.wgz.desc hebrew.wgz.stems he_affix.dat \
	      he.cwl mk_he_affix linginfo.o mk_he_affix.o \
	      hebrew.wgz.lingsizes.tmp

distclean: clean
	rm -f Makefile config.log config.status

install: all


################################################
# for creating an hspell distribution tar
PACKAGE = hspell
VERSION = 0.8
DISTFILES = COPYING INSTALL LICENSE README WHATSNEW TODO \
	Makefile.in stats wunzip.c wzip \
	hspell.1 \
	wolig.pl wolig.dat biza-nouns milot extrawords \
	woo woo.dat biza-verbs \
	likelyerrors spellinghints \
	hspell.spec \
	corlist.c dict_radix.c \
	dict_radix.h find_sizes.c gimatria.c hspell.c \
	hspell.h libhspell.c gzbuffered.h \
	pmerge PrefixBits.pl genprefixes.pl \
	hash.h tclHash.c tclHash.h \
        binarize-desc.pl pack-desc.pl linginfo.c linginfo.h \
	multispell hspell.3 mk_he_affix.c configure.in configure

DISTDIR = $(PACKAGE)-$(VERSION)

distdir:
	rm -rf ./$(DISTDIR)
	mkdir -m 755 $(DISTDIR)
	cp -a --parents $(DISTFILES) $(DISTDIR)
# Note that Oron Peled suggested a more eleborate version that makes hard
# links instead of copies:
#	for file in $(DISTFILES); do \
#		if test -d $$file; then \
#			cp -pr $$file $(distdir)/$$file; \
#		else \
#			test -f $(distdir)/$$file \
#			|| ln $$file $(distdir)/$$file 2> /dev/null \
#			|| cp -p $$file $(distdir)/$$file || :; \
#		fi; \
#	done

dist: distdir
	tar zcvf $(DISTDIR).tar.gz $(DISTDIR)
	rm -rf ./$(DISTDIR)

############################################################################
############################################################################
# moved from c/Makefile:

#normal: hebrew.wgz.sizes hspell

libhspell.a: dict_radix.o gimatria.o corlist.o libhspell.o $(EXTRAOBJECTS)
	-rm -f $@
	ar cr $@ $^
	-ranlib $@

hspell: hspell.o tclHash.o libhspell.a
	$(CC) $(CFLAGS) $(LDFLAGS) -o hspell hspell.o tclHash.o libhspell.a $(LIBS)

# remember to update this dependency list once in a while...
libhspell.o dict_radix.o find_sizes.o: dict_radix.h
dict_radix.o linginfo.o: gzbuffered.h
libhspell.o: prefixes.c
hspell.o: hash.h tclHash.h
tclHash.o: tclHash.h
corlist.o gimatria.o hspell.o libhspell.o: hspell.h
hspell.o libhspell.o linginfo.o: linginfo.h hspell.h
linginfo.o: dmask.c

prefixes.c: genprefixes.pl
	$(PERL) -w ./genprefixes.pl >prefixes.c

find_sizes: find_sizes.o dict_radix.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o find_sizes find_sizes.o dict_radix.o $(LIBS)

GZDICTS= dout.nouns.wolig.gz dout.verbs.gz dout.nouns.shemp.gz
DICTS=milot extrawords biza-verbs biza-nouns


# hebrew.wgz contains all the words without any prefix hints like B,L,+ we
#   previously had. 
# hebrew.wgz.prefixes is the prefix hints (one byte per word, compressed).
# hebrew.wgz.sizes contains the memory sizes that reading hebrew.wgz will
#   require (this makes it easier for hspell to preallocate the needed sizes).
hebrew.wgz hebrew.wgz.prefixes: pmerge $(DICTS) $(GZDICTS)
	(gzip -dc $(GZDICTS); cat $(DICTS)) | ./pmerge -p hebrew.wgz.tmp | ./wzip | gzip -9 > hebrew.wgz
	-rm -f hebrew.wgz.prefixes
	gzip -9 < hebrew.wgz.tmp >hebrew.wgz.prefixes
	-rm -f hebrew.wgz.tmp
hebrew.wgz.sizes: hebrew.wgz find_sizes
	gzip -dc hebrew.wgz | ./find_sizes >hebrew.wgz.sizes

###################################### optional linginfo stuff ##############
dolinginfo: linginfo_data hspell

# hebrew.wgz contains all the words without any prefix hints like B,L,+ we
#   previously had. 
# hebrew.wgz.prefixes is the prefix hints (one byte per word, compressed).
# hebrew.wgz.sizes contains the memory sizes that reading hebrew.wgz will
#   require (this makes it easier for hspell to preallocate the needed sizes).
# dmask.c contains an array of all possible values of the description bitmask.
#   It is generated by pack-desc.pl. This array is not too long (no more than
#   300 for the default dictionary).
#
# In the following long rule, the complete list of all words with linguistic
# details is concatanated and sent to binarize-desc.pl, which converts the
# detail information of each word into bitmap (called dmask), produces a
# spesifier that tell which prefixes are accepted with the word, and writes its
# stem. Then the words list is sorted, packed (a-la uniq), and the output files
# are written.
#
# OLD NOTE/TODO:
# The "linginfo_data:" target line below is ugly and un-make-like. Not only
# that, it doesn't know when it's necessary to build the files again, and
# when it is not. The better make targets (hebrew.wgz et al. and
# hebrew.wgz.sizes) are commented out because the same targets were used above
# for building the version without linginfo. When building with linginfo
# becomes the default, we should remove the following line and uncomment the
# real targets.

# TODO: make pack-desc.pl/binarize-desc.pl and pmerge into just one script
# (with options on whether to generate stems, etc.), and then we won't have
# this ugliness of two different rules generating hebrew.wgz in two ways
# (this is not only ugly, it's unsafe. If we use linginfo (--enable-linginfo
# and change, say, "extrawords", and run "make hebrew.wgz" we will get the
# wrong program run. "make" will work properly because we stick an extra
# target in front of the default targets.

linginfo_data: hebrew.wgz.stems
hebrew.wgz.desc hebrew.wgz.stems hebrew.wgz.lingsizes.tmp dmask.c: binarize-desc.pl pack-desc.pl $(DICTS) $(GZDICTS) find_sizes
#hebrew.wgz hebrew.wgz.prefixes hebrew.wgz.desc hebrew.wgz.stems hebrew.wgz.lingsizes.tmp dmask.c: binarize-desc.pl pack-desc.pl $(DICTS) $(GZDICTS)
	(gzip -dc $(GZDICTS); cat $(DICTS)) | $(PERL) binarize-desc.pl | \
		sort -u | $(PERL) pack-desc.pl -p hebrew.wgz.prefixes.tmp \
		-d hebrew.wgz.desc.tmp -s hebrew.wgz.stems.tmp \
		-l hebrew.wgz.lingsizes.tmp | \
		./wzip | gzip -9 > hebrew.wgz
	gzip -dc hebrew.wgz | ./find_sizes >hebrew.wgz.sizes
	cat hebrew.wgz.lingsizes.tmp >> hebrew.wgz.sizes
	-rm -f hebrew.wgz.lingsizes.tmp
	-rm -f hebrew.wgz.prefixes
	gzip -9 < hebrew.wgz.prefixes.tmp >hebrew.wgz.prefixes
	-rm -f hebrew.wgz.prefixes.tmp
	-rm -f hebrew.wgz.desc
	gzip -9 < hebrew.wgz.desc.tmp >hebrew.wgz.desc
	-rm -f hebrew.wgz.desc.tmp
	-rm -f hebrew.wgz.stems
	gzip -9 < hebrew.wgz.stems.tmp >hebrew.wgz.stems
	-rm -f hebrew.wgz.stems.tmp
############################################################################


# dout.* are the outputs from the various word-list generators with the
# -d option (i.e., with an explanation on how each word was derived)
#
# The dout files are quite large, as much as 10MB. To lower the amount
# of temporary space needed during compilation (is this necessary nowadays?)
# we compress them.
dout.nouns.%:  %.dat wolig.pl
	$(PERL) -w wolig.pl -d $< > $@
dout.nouns.%.gz:  %.dat wolig.pl
	$(PERL) -w wolig.pl -d $< | gzip -4 > $@
dout.nouns.shemp.gz:  shemp.dat wolig.pl
	$(PERL) -w wolig.pl -d shemp.dat | gzip -4 > $@

dout.verbs.gz shemp.dat: woo woo.dat
	$(PERL) -w woo -d woo.dat | sed "$(SEDCMD)" | gzip -4 > $@

############################################################################
# The "aspell" target generates the "he_affix.dat" and "he.cwl" files needed
# for using aspell with Hspell's Hebrew word list.
# This assumes that Aspell's "word-list-compress" utility is already installed.
aspell: wunzip he_affix.dat he.cwl
mk_he_affix.o: prefixes.c hspell.h
he_affix.dat he.cwl: mk_he_affix hebrew.wgz hebrew.wgz.prefixes
	mk_he_affix | word-list-compress c > he.cwl
