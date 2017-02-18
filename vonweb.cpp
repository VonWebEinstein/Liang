//
// MATLAB Compiler: 4.18.1 (R2013a)
// Date: Sun Jun 14 22:47:11 2015
// Arguments: "-B" "macro_default" "-B" "cpplib:vonweb" "-W" "cpplib:vonweb"
// "-T" "link:lib" "vonweb" "-C" 
//

#include <stdio.h>
#define EXPORTING_vonweb 1
#include "vonweb.h"

static HMCRINSTANCE _mcr_inst = NULL;


#if defined( _MSC_VER) || defined(__BORLANDC__) || defined(__WATCOMC__) || defined(__LCC__)
#ifdef __LCC__
#undef EXTERN_C
#endif
#include <windows.h>

static char path_to_dll[_MAX_PATH];

BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, void *pv)
{
    if (dwReason == DLL_PROCESS_ATTACH)
    {
        if (GetModuleFileName(hInstance, path_to_dll, _MAX_PATH) == 0)
            return FALSE;
    }
    else if (dwReason == DLL_PROCESS_DETACH)
    {
    }
    return TRUE;
}
#endif
#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_vonweb_C_API
#define LIB_vonweb_C_API /* No special import/export declaration */
#endif

LIB_vonweb_C_API 
bool MW_CALL_CONV vonwebInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
  if (!GetModuleFileName(GetModuleHandle("vonweb"), path_to_dll, _MAX_PATH))
    return false;
    bResult = mclInitializeComponentInstanceNonEmbeddedStandalone(  &_mcr_inst,
                                                                    path_to_dll,
                                                                    "vonweb",
                                                                    LibTarget,
                                                                    error_handler, 
                                                                    print_handler);
    if (!bResult)
    return false;
  return true;
}

LIB_vonweb_C_API 
bool MW_CALL_CONV vonwebInitialize(void)
{
  return vonwebInitializeWithHandlers(mclDefaultErrorHandler, mclDefaultPrintHandler);
}

LIB_vonweb_C_API 
void MW_CALL_CONV vonwebTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_vonweb_C_API 
void MW_CALL_CONV vonwebPrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(&stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_vonweb_C_API 
bool MW_CALL_CONV mlxVonweb(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "vonweb", nlhs, plhs, nrhs, prhs);
}

LIB_vonweb_CPP_API 
void MW_CALL_CONV vonweb(int nargout, mwArray& varargout, const mwArray& varargin)
{
  mclcppMlfFeval(_mcr_inst, "vonweb", nargout, -1, -1, &varargout, &varargin);
}

LIB_vonweb_CPP_API 
void MW_CALL_CONV vonweb(int nargout, mwArray& varargout)
{
  mclcppMlfFeval(_mcr_inst, "vonweb", nargout, -1, 0, &varargout);
}

LIB_vonweb_CPP_API 
void MW_CALL_CONV vonweb(const mwArray& varargin)
{
  mclcppMlfFeval(_mcr_inst, "vonweb", 0, 0, -1, &varargin);
}

LIB_vonweb_CPP_API 
void MW_CALL_CONV vonweb()
{
  mclcppMlfFeval(_mcr_inst, "vonweb", 0, 0, 0);
}

