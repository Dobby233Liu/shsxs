#ifndef DUI70_H
#define DUI70_H

#include <Windows.h>

extern "C" __declspec(dllimport) HRESULT __stdcall UnInitThread();
extern "C" __declspec(dllimport) HRESULT __stdcall InitThread(DWORD nThreadMode);
extern "C" __declspec(dllimport) HRESULT __stdcall UnInitProcessPriv(HINSTANCE hModule);
extern "C" __declspec(dllimport) HRESULT __stdcall InitProcessPriv(DWORD dwExpectedVersion, HINSTANCE a2, CHAR fRegisterControls, CHAR fEnableUIAutomationProvider, BOOL fInitCommctl);

class DirectUI {
public:
	class Value;

	class DUIXmlParser {
		public:
			__declspec(dllimport) static long __stdcall Create(DUIXmlParser** ppParserOut, Value* __stdcall pfnGetSheetCallback(unsigned short const *,void *), void* pGetSheetContext, void __stdcall pfnErrorCallback(unsigned short const*, unsigned short const *, int, void*), void* pErrorContext);
			__declspec(dllimport) long __thiscall SetXML(unsigned short const* pBuffer, HINSTANCE hResourceInstance, HINSTANCE hControlsInstance);
			__declspec(dllimport) void __thiscall Destroy();
	};
};

#endif
