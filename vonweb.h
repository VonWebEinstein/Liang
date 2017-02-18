//
// MATLAB Compiler: 4.18.1 (R2013a)
// Date: Sun Jun 14 22:47:11 2015
// Arguments: "-B" "macro_default" "-B" "cpplib:vonweb" "-W" "cpplib:vonweb"
// "-T" "link:lib" "vonweb" "-C" 
//

#ifndef __vonweb_h
#define __vonweb_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_vonweb
#define PUBLIC_vonweb_C_API __global
#else
#define PUBLIC_vonweb_C_API /* No import statement needed. */
#endif

#define LIB_vonweb_C_API PUBLIC_vonweb_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_vonweb
#define PUBLIC_vonweb_C_API __declspec(dllexport)
#else
#define PUBLIC_vonweb_C_API __declspec(dllimport)
#endif

#define LIB_vonweb_C_API PUBLIC_vonweb_C_API


#else

#define LIB_vonweb_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_vonweb_C_API 
#define LIB_vonweb_C_API /* No special import/export declaration */
#endif

extern LIB_vonweb_C_API 
bool MW_CALL_CONV vonwebInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_vonweb_C_API 
bool MW_CALL_CONV vonwebInitialize(void);

extern LIB_vonweb_C_API 
void MW_CALL_CONV vonwebTerminate(void);



extern LIB_vonweb_C_API 
void MW_CALL_CONV vonwebPrintStackTrace(void);

extern LIB_vonweb_C_API 
bool MW_CALL_CONV mlxVonweb(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);


#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__BORLANDC__)

#ifdef EXPORTING_vonweb
#define PUBLIC_vonweb_CPP_API __declspec(dllexport)
#else
#define PUBLIC_vonweb_CPP_API __declspec(dllimport)
#endif

#define LIB_vonweb_CPP_API PUBLIC_vonweb_CPP_API

#else

#if !defined(LIB_vonweb_CPP_API)
#if defined(LIB_vonweb_C_API)
#define LIB_vonweb_CPP_API LIB_vonweb_C_API
#else
#define LIB_vonweb_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_vonweb_CPP_API void MW_CALL_CONV vonweb(int nargout, mwArray& varargout, const mwArray& varargin);

extern LIB_vonweb_CPP_API void MW_CALL_CONV vonweb(int nargout, mwArray& varargout);

extern LIB_vonweb_CPP_API void MW_CALL_CONV vonweb(const mwArray& varargin);

extern LIB_vonweb_CPP_API void MW_CALL_CONV vonweb();

#endif
#endif
