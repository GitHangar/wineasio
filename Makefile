### Generated by Winemaker

PREFIX                = /usr
SRCDIR                = .
SUBDIRS               =
DLLS                  = wineasio.dll
EXES                  =



### Common settings

CEXTRA                = -m32 -D_REENTRANT -fPIC -Wall -pipe
CEXTRA               += -fno-strict-aliasing -Wdeclaration-after-statement -Wwrite-strings -Wpointer-arith
CEXTRA               += -Werror=implicit-function-declaration
CEXTRA               += $(shell pkg-config --cflags jack)
RCEXTRA               =
INCLUDE_PATH          = -I. -Irtaudio/include
INCLUDE_PATH         += -I$(PREFIX)/include/wine
INCLUDE_PATH         += -I$(PREFIX)/include/wine/windows
INCLUDE_PATH         += -I$(PREFIX)/include/wine-development
INCLUDE_PATH         += -I$(PREFIX)/include/wine-development/wine/windows
DLL_PATH              =
LIBRARY_PATH          =
LIBRARIES             = -ljack

ifeq ($(DEBUG),true)
CEXTRA               += -O0 -DDEBUG -g -D__WINESRC__
LIBRARIES            +=
else
CEXTRA               += -O2 -DNDEBUG -fvisibility=hidden
endif

### wineasio.dll sources and settings

wineasio_dll_MODULE   = wineasio.dll
wineasio_dll_C_SRCS   = asio.c \
			main.c \
			regsvr.c
wineasio_dll_RC_SRCS  =
wineasio_dll_LDFLAGS  = -shared \
			-m32 \
			-mnocygwin \
			$(wineasio_dll_MODULE:%=%.spec) \
			-L/usr/lib32/wine \
			-L/usr/lib/i386-linux-gnu/wine \
			-L/usr/lib/i386-linux-gnu/wine-development \
			-L/opt/wine-staging/lib \
			-L/opt/wine-staging/lib/wine
wineasio_dll_DLL_PATH =
wineasio_dll_DLLS     = odbc32 \
			ole32 \
			winmm
wineasio_dll_LIBRARY_PATH=
wineasio_dll_LIBRARIES= uuid

wineasio_dll_OBJS     = $(wineasio_dll_C_SRCS:.c=.o) \
			$(wineasio_dll_RC_SRCS:.rc=.res)



### Global source lists

C_SRCS                = $(wineasio_dll_C_SRCS)
RC_SRCS               = $(wineasio_dll_RC_SRCS)


### Tools

CC = gcc
WINECC = winegcc
RC = wrc


### Generic targets

all: rtaudio/include/asio.h $(SUBDIRS) $(DLLS:%=%.so) $(EXES:%=%.so)

### Build rules

.PHONY: all clean dummy

$(SUBDIRS): dummy
	@cd $@ && $(MAKE)

# Implicit rules

.SUFFIXES: .cpp .rc .res
DEFINCL = $(INCLUDE_PATH) $(DEFINES) $(OPTIONS)

.c.o:
	$(CC) -c $(DEFINCL) $(CFLAGS) $(CEXTRA) -o $@ $<

.rc.res:
	$(RC) $(RCFLAGS) $(RCEXTRA) $(DEFINCL) -fo$@ $<

# Rules for cleaning

CLEAN_FILES     = y.tab.c y.tab.h lex.yy.c core *.orig *.rej \
                  \\\#*\\\# *~ *% .\\\#*

clean:: $(SUBDIRS:%=%/__clean__) $(EXTRASUBDIRS:%=%/__clean__)
	$(RM) $(CLEAN_FILES) $(RC_SRCS:.rc=.res) $(C_SRCS:.c=.o)
	$(RM) $(DLLS:%=%.so) $(EXES:%=%.so) $(EXES:%.exe=%)

$(SUBDIRS:%=%/__clean__): dummy
	cd `dirname $@` && $(MAKE) clean

$(EXTRASUBDIRS:%=%/__clean__): dummy
	-cd `dirname $@` && $(RM) $(CLEAN_FILES)

distclean:: clean
	$(RM) asio.h

### Target specific build rules
DEFLIB = $(LIBRARY_PATH) $(LIBRARIES) $(DLL_PATH)

$(wineasio_dll_MODULE).so: $(wineasio_dll_OBJS)
	$(WINECC) $(wineasio_dll_LDFLAGS) -o $@ $(wineasio_dll_OBJS) $(wineasio_dll_LIBRARY_PATH) $(DEFLIB) $(wineasio_dll_DLLS:%=-l%) $(wineasio_dll_LIBRARIES:%=-l%)

install:
	if [ -d $(PREFIX)/lib32/wine ]; then cp wineasio.dll.so $(DESTDIR)$(PREFIX)/lib32/wine; else cp wineasio.dll.so $(DESTDIR)$(PREFIX)/lib/wine; fi
