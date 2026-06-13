# This is chaotic (no I will never fix that)

#"D:\\tools\\Program Files\\Microsoft Visual Studio\\2022\\BuildTools\\VC\\Auxiliary\\Build\\vcvarsall.bat" x64 8.1 -vcvars_ver=14.0
#set WindowsTargetPlatformMinVersion=6.2.9200.0
#call "D:\\sdks\\VC-LTL-5.1\\VC-LTL helper for nmake.cmd"
!if "$(VC_LTL_ROOT)" == ""
!error Run VC-LTL helper for nmake.cmd v5.1.1
!endif

OUTDIR = obj\$(PLATFORM)

# VS2022 vcvarsall fails to find this
# also it doesnt pick up 10240 ucrt headers explicitly
INCLUDE = $(WINDOWSSDKDIR)include\shared;$(WINDOWSSDKDIR)include\um;$(WINDOWSSDKDIR)..\10\Include\10.0.10240.0\ucrt;$(INCLUDE)
INCLUDE = $(VC_LTL_ROOT)TargetPlatform\header;$(VC_LTL_ROOT)TargetPlatform\$(LTLWINDOWSTARGETPLATFORMMINVERSION)\header;$(INCLUDE)

CDEF = /DWIN32 /D_WIN32 /DWINVER=0x601 /D_WINVER_WINNT=0x601 /DUNICODE /D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE
CPPFLAGS = $(CPPFLAGS) /nologo /Ox /W3 /WX $(CDEF) /DNDEBUG /LD /MT /Zl
RFLAGS = $(RFLAGS) /nologo $(CDEF)

# /nodefaultlibs makes link ignore %LIB%? or is it just the same bug as above
SDK_LIB_PATH = $(WINDOWSSDKDIR)lib\$(WINDOWSSDKLIBVERSION)um\$(PLATFORM)

VC_LTL_PLATFORM = $(PLATFORM)
!if "$(VC_LTL_PLATFORM)" == "X86"
VC_LTL_PLATFORM = Win32
!else if "$(VC_LTL_PLATFORM)" == "X64"
VC_LTL_PLATFORM = x64
!endif
VC_LTL_LIB_PATH = $(VC_LTL_ROOT)TargetPlatform\6.2.9200.0\lib\$(PLATFORM)

EXT_PLATFORM = $(PLATFORM)
!if "$(VC_LTL_PLATFORM)" == "x64"
EXT_PLATFORM = amd64
!endif

LINK = link
LFLAGS = $(LFLAGS) /nologo \
		/subsystem:console,6.10 /dll /noentry /release \
		/nodefaultlib /libpath:"$(VC_LTL_LIB_PATH)" /libpath:"$(SDK_LIB_PATH)" /libpath:"external\$(EXT_PLATFORM)"

LIBS = \
	libcmt.lib ucrt.lib vcruntime.lib \
	kernel32.lib user32.lib \
	advapi32.lib ole32.lib uuid.lib \
	shell32.lib shlwapi.lib \
	gdi32.lib uxtheme.lib \
	dui70.lib

LIBTOOL = lib

.SUFFIXES: .cpp .rc .obj .dll .lib

all: $(OUTDIR) $(OUTDIR)\shsxs.dll

$(OUTDIR):
	@if not exist "$(OUTDIR)" mkdir "$(OUTDIR)"

.cpp{$(OUTDIR)\}.obj:
	$(CPP) $(CPPFLAGS) /Fo"$@" /c $<

.rc{$(OUTDIR)\}.res:
	$(RC) $(RFLAGS) /fo"$@" /r $<

$(OUTDIR)\shsxs.dll: $(OUTDIR)\shsxs.obj $(OUTDIR)\duilib.obj $(OUTDIR)\shsxs.res
	$(LINK) $(LFLAGS) /def:"shsxs.def" /out:"$@" /pdbaltpath:"shsxs.pdb" $** $(LIBS)

$(OUTDIR)\dui70_stub.lib: $(OUTDIR)\dui70_stub.obj
	$(LIBTOOL) $** /def:"dui70_stub_x86.def" /out:"$@"
