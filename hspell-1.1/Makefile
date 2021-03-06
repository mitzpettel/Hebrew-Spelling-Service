# Hspell Makefile
# Copyright (C) 2002-2009 Nadav Har'El and Dan Kenigsberg
# Modified for the Hebrew Spelling Service on 2006-04-19 by Mitz Pettel
 
# A comment about parallel make:
# Unfortunately, parallel make deals with rules with multiple targets in a way
# I can only describe as "useless". If one rule has multiple targets, and
# more than one of them appear as dependencies in other rules, parallel make
# may run the rule more than once concurrently! To work around this problem,
# we need to change every rule of the form:
# 	a b c:
# 		... create a b and c
# to the form:
# 	a:
# 		... create a b and c
# 	b c: a
# Now, the real rule will be run just once, because a will be created just
# once. This workaround is used several times in the Makefile below.

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
datarootdir = ${prefix}/share

DESTDIR =
PREFIX = /usr/local
BIN = ${exec_prefix}/bin
SHARE = ${datarootdir}/hspell
LIBEXEC = ${exec_prefix}/libexec/hspell
MAN1 = ${datarootdir}/man/man1
MAN3 = ${datarootdir}/man/man3
LIBDIR = ${exec_prefix}/lib
INCLUDEDIR = ${prefix}/include

DICTBASE = $(SHARE)/hebrew.wgz

PERL=/usr/bin/perl
CC=gcc

DEFS=-DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_UINTPTR_T=1 -DHAVE_ZLIB=1 -DDICTIONARY_BASE=\"$(DICTBASE)\"
CFLAGS=-g -O2
LIBS=-lz 
CPPFLAGS=
LDFLAGS=

STRIP=strip

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
	      prefixes.c libhspell.o libhspell.a hspell.exe \
	      hebrew.wgz.desc hebrew.wgz.stems he_affix.dat \
	      he.wl mk_he_affix linginfo.o mk_he_affix.o \
	      hebrew.wgz.lingsizes.tmp dmask.c install.js \
	      spell-he.xpi he.dic he.aff README-he.txt \
	      README_he_IL.txt he_IL.dic he_IL.aff he_IL.zip \
	      specfilter.o specfilter
	rm -f hebeng/install.js hebeng/heb-eng.aff hebeng/heb-eng.dic \
	      hebeng/README-he.txt hebeng/README-en-US.txt \
	      hebeng/spell-heb-eng.xpi
	-rmdir hebeng
	rm -f hunspell/he.aff hunspell/he.dic hunspell/new_he.aff \
	      hunspell/new_he.dic hunspell/num_he.aff hunspell/num_he.dic \
	      hunspell/word hunspell/word2 hunspell/affixcompress[0123].tmp
	-rmdir hunspell
	rm -f ff2/dictionaries/he.aff ff2/dictionaries/he.dic \
	      ff2/dictionaries/license.txt ff2/dictionaries/README-he.txt \
	      ff2/install.js ff2/install.rdf ff2/spell-he-$(VERSION).xpi
	-rmdir ff2/dictionaries ff2

distclean: clean
	rm -f Makefile config.log config.status

# On Windows, this would typically be set to hspell.exe
HSPELL_EXECUTABLE=hspell

install: all
	test -d $(DESTDIR)$(BIN) || mkdir -m 755 -p $(DESTDIR)$(BIN)
	$(STRIP) $(HSPELL_EXECUTABLE)
	-rm -f $(DESTDIR)$(BIN)/$(HSPELL_EXECUTABLE)
	cp $(HSPELL_EXECUTABLE) $(DESTDIR)$(BIN)/$(HSPELL_EXECUTABLE)
	chmod 755 $(DESTDIR)$(BIN)/$(HSPELL_EXECUTABLE)
	cp multispell $(DESTDIR)$(BIN)/multispell
	chmod 755 $(DESTDIR)$(BIN)/multispell
	test -d $(DESTDIR)$(SHARE) || mkdir -m 755 -p $(DESTDIR)$(SHARE)
	cp hebrew.wgz hebrew.wgz.prefixes hebrew.wgz.sizes $(DESTDIR)$(SHARE)/
	gzip -9n < spellinghints > $(DESTDIR)$(SHARE)/hebrew.wgz.hints
	(cd $(DESTDIR)$(SHARE); chmod 644 hebrew.wgz hebrew.wgz.prefixes hebrew.wgz.sizes hebrew.wgz.hints)
	test ! -f hebrew.wgz.stems || cp hebrew.wgz.stems hebrew.wgz.desc $(DESTDIR)$(SHARE)/
	(cd $(DESTDIR)$(SHARE); test ! -f hebrew.wgz.stems || chmod 644 hebrew.wgz.stems hebrew.wgz.desc)
	-rm -f $(DESTDIR)$(BIN)/hspell-i
	-ln -s $(HSPELL_EXECUTABLE) $(DESTDIR)$(BIN)/hspell-i
	test -d $(DESTDIR)$(MAN1) || mkdir -m 755 -p $(DESTDIR)$(MAN1)
	cp hspell.1 $(DESTDIR)$(MAN1)/
	chmod 644 $(DESTDIR)$(MAN1)/hspell.1
	test -d $(DESTDIR)$(MAN3) || mkdir -m 755 -p $(DESTDIR)$(MAN3)
	cp hspell.3 $(DESTDIR)$(MAN3)/
	chmod 644 $(DESTDIR)$(MAN3)/hspell.3
	test -d $(DESTDIR)$(LIBDIR) || mkdir -m 755 -p $(DESTDIR)$(LIBDIR)
	cp libhspell.a $(DESTDIR)$(LIBDIR)/
	chmod 644 $(DESTDIR)$(LIBDIR)/libhspell.a
	test -d $(DESTDIR)$(INCLUDEDIR) || mkdir -m 755 -p $(DESTDIR)$(INCLUDEDIR)
	cp hspell.h linginfo.h $(DESTDIR)$(INCLUDEDIR)/
	chmod 644 $(DESTDIR)$(INCLUDEDIR)/hspell.h $(DESTDIR)$(INCLUDEDIR)/linginfo.h


################################################
# for creating an hspell distribution tar
PACKAGE = hspell
VERSION = 1.1
DISTFILES = COPYING INSTALL LICENSE README WHATSNEW \
	Makefile.in stats wunzip.c wzip \
	hspell.1 \
	wolig.pl wolig.dat biza-nouns milot extrawords \
	woo woo.dat biza-verbs \
	likelyerrors spellinghints \
	corlist.c dict_radix.c \
	dict_radix.h find_sizes.c gimatria.c hspell.c \
	hspell.h libhspell.c gzbuffered.h \
	pmerge PrefixBits.pl genprefixes.pl \
	hash.h tclHash.c tclHash.h \
        binarize-desc.pl pack-desc.pl linginfo.c linginfo.h \
	multispell hspell.3 mk_he_affix.c configure.in configure \
	misc/install.js.pre specfilter.c \
	misc/ff2-install.js.pre misc/ff2-install.rdf.pre \
	doc/niqqudless.odt misc/doubleaffixcompress

DISTDIR = $(PACKAGE)-$(VERSION)

distdir:
	rm -rf ./$(DISTDIR)
	mkdir -m 755 $(DISTDIR)
	cp -a --parents $(DISTFILES) $(DISTDIR)
	#cp -a $(DISTFILES) $(DISTDIR)
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

libhspell.a: dict_radix.o gimatria.o corlist.o libhspell.o $(EXTRAOBJECTS)
	-rm -f $@
	ar cr $@ $^
	-ranlib $@

$(HSPELL_EXECUTABLE): hspell.o tclHash.o libhspell.a
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(HSPELL_EXECUTABLE) hspell.o tclHash.o libhspell.a $(LIBS)

# remember to update this dependency list once in a while...
libhspell.o dict_radix.o find_sizes.o: dict_radix.h
dict_radix.o linginfo.o: gzbuffered.h
libhspell.o mk_he_affix.o: prefixes.c
hspell.o: hash.h tclHash.h
tclHash.o: tclHash.h
corlist.o gimatria.o hspell.o libhspell.o: hspell.h
hspell.o libhspell.o linginfo.o: linginfo.h hspell.h
linginfo.o: dmask.c
specfilter.o: prefixes.c

prefixes.c: genprefixes.pl PrefixBits.pl
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
hebrew.wgz: pmerge PrefixBits.pl $(DICTS) $(GZDICTS)
	(gzip -dc $(GZDICTS); cat $(DICTS)) | ./pmerge -p hebrew.wgz.tmp | ./wzip | gzip -9n > hebrew.wgz
	-rm -f hebrew.wgz.prefixes
	gzip -9n < hebrew.wgz.tmp >hebrew.wgz.prefixes
	-rm -f hebrew.wgz.tmp
hebrew.wgz.prefixes: hebrew.wgz
hebrew.wgz.sizes: hebrew.wgz find_sizes
	gzip -dc hebrew.wgz | ./find_sizes >hebrew.wgz.sizes

###################################### optional linginfo stuff ##############
dolinginfo: linginfo_data $(HSPELL_EXECUTABLE)

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
# detailed information of each word into bitmap (called dmask), produces a
# specifier that tells which prefixes are accepted with the word, and writes its
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
hebrew.wgz.stems: binarize-desc.pl PrefixBits.pl pack-desc.pl $(DICTS) $(GZDICTS) find_sizes
	(gzip -dc $(GZDICTS); cat $(DICTS)) | $(PERL) binarize-desc.pl | \
		sort -u | $(PERL) pack-desc.pl -p hebrew.wgz.prefixes.tmp \
		-d hebrew.wgz.desc.tmp -s hebrew.wgz.stems.tmp \
		-l hebrew.wgz.lingsizes.tmp | \
		./wzip | gzip -9n > hebrew.wgz
	gzip -dc hebrew.wgz | ./find_sizes >hebrew.wgz.sizes
	cat hebrew.wgz.lingsizes.tmp >> hebrew.wgz.sizes
	-rm -f hebrew.wgz.lingsizes.tmp
	-rm -f hebrew.wgz.prefixes
	gzip -9n < hebrew.wgz.prefixes.tmp >hebrew.wgz.prefixes
	-rm -f hebrew.wgz.prefixes.tmp
	-rm -f hebrew.wgz.desc
	gzip -9n < hebrew.wgz.desc.tmp >hebrew.wgz.desc
	-rm -f hebrew.wgz.desc.tmp
	-rm -f hebrew.wgz.stems
	gzip -9n < hebrew.wgz.stems.tmp >hebrew.wgz.stems
	-rm -f hebrew.wgz.stems.tmp
hebrew.wgz.desc hebrew.wgz.lingsizes.tmp dmask.c: hebrew.wgz.stems
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

dout.verbs.gz: woo woo.dat
	$(PERL) -w woo -d woo.dat | sed "$(SEDCMD)" | gzip -4 > $@
shemp.dat: dout.verbs.gz

############################################################################
# The following targets build packages of Hspell's word list in formats
# required for other spell-checkers like Aspell and Myspell. They are not
# necessary for building the native Hspell spell-checker.
############################################################################

# The "he_affix.dat" and "he.wl" files are the two files basic files which
# form an Aspell 0.6 dictionary. The dictionary formats of myspell and
# hunspell, and products using them (such as firefox and openoffice) are
# just various modifications on top of these two basic files:
he.wl: mk_he_affix wunzip hebrew.wgz hebrew.wgz.prefixes specfilter
	./mk_he_affix > he.wl
he_affix.dat: he.wl
mk_he_affix.o: prefixes.c hspell.h

# The "aspell" target generates "he_affix.dat" and "he.wl".
aspell: he_affix.dat he.wl

# The "myspell" target generates the "he.dic" and "he.aff" files needed
# for using Hspell's Hebrew word list in myspell. Myspell is the spell-
# checking library used in both Mozilla and OpenOffice, and its format is
# very similar to the uncompressed aspell dictionary format.
#myspell: he.dic he.aff
#he.dic: he_affix.dat he.wl
#	cat he.wl | wc -l > he.dic
#	cat he.wl >> he.dic
#	echo SET ISO8859-8 > he.aff
#	echo TRY ��������\'\"������������������� >> he.aff
#	cat he_affix.dat >> he.aff
#he.aff: he.dic

# For some unknown reason, hunspell is 10 times faster (!) to load a
# UTF-8 dictionary than ISO8859-8 (on one machine, 3.28 seconds vs 0.35).
# So we use UTF-8 instead, despite this resulting file being twice the
# size. Luckily, the memory use is not affected at all.
myspell: he.dic he.aff
he.dic: he_affix.dat he.wl
	wc -l < he.wl > he.dic
	iconv -f iso-8859-8 -t utf-8 he.wl >> he.dic
	echo SET UTF-8 > he.aff
	echo TRY ��������\'\"������������������� | iconv -f iso-8859-8 -t utf-8 >> he.aff
	iconv -f iso-8859-8 -t utf-8 he_affix.dat >> he.aff
he.aff: he.dic

# The "hunspell" target generates hunspell/new_he.aff, hunspell/new_he.dic.
# Hunspell is a newer format, based on myspell but with the addition of
# secondary affix compression which allows smaller dictionaries, memory use
# and startup times.
hunspell: hunspell/new_he.dic
hunspell/new_he.dic: myspell
	test -d hunspell || mkdir hunspell
	(cd hunspell; ln -sf ../he.aff ../he.dic .; LC_ALL=he_IL.UTF-8 ../misc/doubleaffixcompress he)
	echo WORDCHARS ���������������������������\'\" | iconv -f iso-8859-8 -t utf-8 >> hunspell/new_he.aff
	echo -e "BREAK 3\nBREAK ^\"\nBREAK \"$$\nBREAK ^'" >> hunspell/new_he.aff

# The "mozilla" target generates a ".xpi" file, which is basically a zip
# file containing the dictionaries in Myspell format (similar to the
# uncompressed aspell dictionary format).
mozilla: spell-he.xpi
spell-he.xpi: he.dic he.aff install.js README
	rm -f README-he.txt spell-he.xpi
	cp README README-he.txt
	zip spell-he.xpi install.js README-he.txt he.aff he.dic
install.js: misc/install.js.pre
	sed "s/%VERSION%/$(VERSION)/g; s/%DISPLAY_NAME%/Hebrew (IL) dictionary/g; s/%APP_NAME%/spell-he/g" < misc/install.js.pre > install.js

# A similar target, for newer Firefox
ff2: ff2/spell-he-$(VERSION).xpi
ff2/spell-he-$(VERSION).xpi: he.dic he.aff ff2/install.js ff2/install.rdf README
	mkdir -p ff2/dictionaries
	ln README ff2/dictionaries/README-he.txt
	ln COPYING ff2/dictionaries/license.txt
	ln he.dic he.aff ff2/dictionaries
	( cd ff2; zip spell-he-$(VERSION).xpi install.js install.rdf \
		dictionaries/{README-he.txt,license.txt,he.aff,he.dic} )
ff2/install.js: misc/ff2-install.js.pre
	mkdir -p ff2
	sed "s/%VERSION%/$(VERSION)/g" < misc/ff2-install.js.pre > ff2/install.js
ff2/install.rdf: misc/ff2-install.rdf.pre
	mkdir -p ff2
	sed "s/%VERSION%/$(VERSION)/g" < misc/ff2-install.rdf.pre > ff2/install.rdf

# The "heb-eng-xpi" target generates, like the "mozilla" target, an xpi
# file. But instead of taking only the Hebrew word list, it merges our
# Hebrew word list with another English word list. This is useful in software
# (like Mozilla) which doesn't support multiple dictionaries at the same time,
# but a typical user still wants to check mixed-language documents.
hebeng:
	mkdir hebeng
en-US.dic en-US.aff README-en-US.txt:
	echo \*\*\* Please link to the english dictionary files $@
	false
hebeng/install.js: hebeng misc/install.js.pre
	sed "s/%VERSION%/$(VERSION)/g; s/%DISPLAY_NAME%/Hebrew-English combined dictionary/g; s/%APP_NAME%/spell-heb-eng/g; s/he\.dic/heb-eng.dic/; s/he\.aff/heb-eng.aff/; /var myspell_folder/s/$$/addFile(APP_NAME, \"README-en-US.txt\", myspell_folder, \"\")\;/" < misc/install.js.pre > hebeng/install.js
hebeng/heb-eng.aff: he.aff en-US.aff
	echo SET ISO8859-8 >hebeng/heb-eng.aff
	echo TRY esianrtolcdugmphbyfvkwzESIANRTOLCDUGMPHBYFVKWZ��������\'\"������������������� >> hebeng/heb-eng.aff
	tail +3 en-US.aff >> hebeng/heb-eng.aff
	tail +3 he.aff >> hebeng/heb-eng.aff
hebeng/heb-eng.dic: he.dic en-US.dic
	cat he.dic en-US.dic | wc -l > hebeng/heb-eng.dic
	tail +2 en-US.dic >> hebeng/heb-eng.dic
	tail +2 he.dic >> hebeng/heb-eng.dic
heb-eng-xpi: hebeng hebeng/heb-eng.dic hebeng/heb-eng.aff hebeng/install.js README README-en-US.txt
	(cd hebeng;\
	rm -f README-he.txt spell-heb-eng.xpi ;\
	cp ../README README-he.txt;\
	cp ../README-en-US.txt . ;\
	zip spell-heb-eng.xpi install.js README-he.txt README-en-US.txt heb-eng.aff heb-eng.dic)

#
# The openoffice target generates a .zip file, which contains the files
# that need to be installed in OpenOffice's dictionary directory (e.g.,
# /usr/lib/ooo-1.1/share/dict/ooo/). Additionally, you'll need to add the
# line "DICT he IL he_IL" to the dictionary.lst file in that directory
# (for performance, you may want to remove from that list dictionaries in
# irrelevant languages). The zip itself can be used by DicOOo, OpenOffice's
# automatic dictionary-fetching macro. But you don't need to compile Hspell
# yourself if you plan to do that.
openoffice: he_IL.zip
he_IL.zip: he_IL.dic he_IL.aff README_he_IL.txt
	rm -f he_IL.zip
	zip he_IL.zip he_IL.dic he_IL.aff README_he_IL.txt
# note: zip dereferences symbolic links, so those are enough.
he_IL.dic: he.dic
	ln -s he.dic he_IL.dic
he_IL.aff: he.aff
	ln -s he.aff he_IL.aff
README_he_IL.txt:
	echo "This Hebrew dictionary in Myspell format was generated automatically from" >README_he_IL.txt
	echo "data prepared by the Hspell project:" >>README_he_IL.txt
	echo >>README_he_IL.txt
	echo "	http://ivrix.org.il/projects/spell-checker" >>README_he_IL.txt
	echo >>README_he_IL.txt
	echo "Hspell version $(VERSION) was used." >>README_he_IL.txt
	echo >>README_he_IL.txt
	echo "This dictionary is Copyright (C) 2000-2009, Nadav Har'El and Dan Kenigsberg." >>README_he_IL.txt
	echo "It is licensed under the GNU General Public License (GPL)." >>README_he_IL.txt

