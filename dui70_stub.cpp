#include <Windows.h>

extern "C" HRESULT __stdcall UnInitThread(void) {
    return 0;
}
extern "C" HRESULT __stdcall InitThread(DWORD nThreadMode) {
    (void)(nThreadMode);
    return 0;
}
extern "C" HRESULT __stdcall UnInitProcessPriv(HINSTANCE hModule) {
    (void)(hModule);
    return 0;
}
extern "C" HRESULT __stdcall InitProcessPriv(DWORD dwExpectedVersion, HINSTANCE a2, CHAR fRegisterControls, CHAR fEnableUIAutomationProvider, BOOL fInitCommctl) {
    (void)(dwExpectedVersion);
    (void)(a2);
    (void)(fRegisterControls);
    (void)(fEnableUIAutomationProvider);
    (void)(fInitCommctl);
    return 0;
}
class DirectUI {
public:
	class Value;

	class DUIXmlParser {
		public:
			static long __stdcall Create(DUIXmlParser** ppParserOut, Value* __stdcall pfnGetSheetCallback(unsigned short const *,void *), void* pGetSheetContext, void __stdcall pfnErrorCallback(unsigned short const*, unsigned short const *, int, void*), void* pErrorContext);
			long __thiscall SetXML(unsigned short const* pBuffer, HINSTANCE hResourceInstance, HINSTANCE hControlsInstance);
			void __thiscall Destroy();
	};
};
long __stdcall DirectUI::DUIXmlParser::Create(DUIXmlParser** ppParserOut, Value* __stdcall pfnGetSheetCallback(unsigned short const *,void *), void* pGetSheetContext, void __stdcall pfnErrorCallback(unsigned short const*, unsigned short const *, int, void*), void* pErrorContext) {
    (void)(ppParserOut);
    (void)(pfnGetSheetCallback);
    (void)(pGetSheetContext);
    (void)(pfnErrorCallback);
    (void)(pErrorContext);
    return 0;
}
long __thiscall DirectUI::DUIXmlParser::SetXML(unsigned short const* pBuffer, HINSTANCE hResourceInstance, HINSTANCE hControlsInstance) {
    (void)(pBuffer);
    (void)(hResourceInstance);
    (void)(hControlsInstance);
    return 0;
}
void __thiscall DirectUI::DUIXmlParser::Destroy() {

}
