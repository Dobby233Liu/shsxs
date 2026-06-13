# This is chaotic (no I will never fix that)

#"D:\tools\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x86 8.1 -vcvars_ver=14.0
## or
#"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64_arm 8.1
##
#set WindowsTargetPlatformMinVersion=6.2.9200.0
#call "D:\sdks\VC-LTL-5.1\VC-LTL helper for nmake.cmd"
#nmake /f makefile.mak

!if "$(PLATFORM)" == ""
!error %Platform% is unset, run vcvarsall (set manually if necessary)
!endif
!if "$(VC_LTL_ROOT)" == ""
!error VC-LTL environment is not set up, run "VC-LTL helper for nmake.cmd" v5.1.1
!endif

# VS2022 vcvarsall fails to find 8.1 SDK includes?
# also 26100 UCRT headers get picked up for some reason, which use intrinsics that break compilation
!ifndef UCRT_INCLUDES
UCRTVERSION = 10.0.10240.0
UCRT_INCLUDES = $(UNIVERSALCRTSDKDIR)Include\$(UCRTVERSION)^\
!endif
INCLUDE = $(UCRT_INCLUDES)ucrt;$(WINDOWSSDKDIR)include\shared;$(WINDOWSSDKDIR)include\um;$(INCLUDE)
INCLUDE = $(VC_LTL_ROOT)TargetPlatform\header;$(VC_LTL_ROOT)TargetPlatform\$(LTLWINDOWSTARGETPLATFORMMINVERSION)\header;$(INCLUDE)

CDEF = /DWIN32 /D_WIN32 /DWINVER=0x601 /D_WINVER_WINNT=0x601 /DUNICODE /D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE
CPPFLAGS = $(CPPFLAGS) /nologo /Ox /W3 /WX $(CDEF) /DNDEBUG /LD /MT /Zl
RFLAGS = $(RFLAGS) /nologo $(CDEF)

SDK_LIB_PATH = $(WINDOWSSDKDIR)lib\$(WINDOWSSDKLIBVERSION)um\$(PLATFORM)

VC_LTL_PLATFORM = $(PLATFORM)
!if "$(VC_LTL_PLATFORM)" == "X86" || "$(VC_LTL_PLATFORM)" == "x86"
VC_LTL_PLATFORM = Win32
!else if "$(VC_LTL_PLATFORM)" == "x64" || "$(VC_LTL_PLATFORM)" == "X64"
VC_LTL_PLATFORM = x64
!endif
VC_LTL_LIB_PATH = $(VC_LTL_ROOT)TargetPlatform\$(LTLWINDOWSTARGETPLATFORMMINVERSION)\lib\$(PLATFORM)

EXT_PLATFORM = $(VC_LTL_PLATFORM)
!if "$(EXT_PLATFORM)" == "Win32"
EXT_PLATFORM = x86
!else if "$(EXT_PLATFORM)" == "ARM"
EXT_PLATFORM = arm
!endif

LINK = link
# /nodefaultlibs makes link ignore %LIB%? or is it just the same bug as above
LFLAGS = $(LFLAGS) /nologo \
		/subsystem:console,6.10 /dll /noentry /release \
		/nodefaultlib /libpath:"$(VC_LTL_LIB_PATH)" /libpath:"$(SDK_LIB_PATH)" /libpath:"external\$(EXT_PLATFORM)"

LIBTOOL = lib

LIBS = \
	libcmt.lib ucrt.lib vcruntime.lib \
	kernel32.lib user32.lib \
	advapi32.lib ole32.lib uuid.lib \
	shell32.lib shlwapi.lib \
	gdi32.lib uxtheme.lib \
	dui70.lib

DLL_NAME = shsxs
OUT_DIR = obj\$(PLATFORM)

.SUFFIXES: .cpp .rc .obj .dll .lib
all: $(OUT_DIR) $(OUT_DIR)\$(DLL_NAME).dll
OBJS = $(OUT_DIR)\shsxs.obj $(OUT_DIR)\duilib.obj $(OUT_DIR)\shsxs.res

$(OUT_DIR):
	@if not exist "$(OUT_DIR)" mkdir "$(OUT_DIR)"

.cpp{$(OUT_DIR)\}.obj:
	$(CPP) $(CPPFLAGS) /Fo"$@" /c $<

.rc{$(OUT_DIR)\}.res:
	$(RC) $(RFLAGS) /fo"$@" /r $<

$(OUT_DIR)\$(DLL_NAME).dll: $(OBJS)
	$(LINK) $(LFLAGS) /def:"$(DLL_NAME).def" /out:"$@" /pdbaltpath:"$(DLL_NAME).pdb" $** $(LIBS)

# for manual creation of dui70.lib for x86
$(OUT_DIR)\dui70.lib: $(OUT_DIR)\dui70_stub.obj
	$(LIBTOOL) /nologo /def:"dui70_stub.def" /out:"$@" $**
