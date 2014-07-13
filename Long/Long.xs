
#ifdef  __MINGW32__
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#endif

#define PERL_NO_GET_CONTEXT 1

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <complex.h>
#include <stdlib.h>
#include <float.h>

#define MATH_COMPLEX long double _Complex

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

#ifndef Newx
#  define Newx(v,n,t) New(0,v,n,t)
#endif

#ifndef Newxz
#  define Newxz(v,n,t) Newz(0,v,n,t)
#endif

#ifdef LDBL_DIG
int _MATH_COMPLEX_C_LONG_DIGITS = LDBL_DIG;
#else
int _MATH_COMPLEX_C_LONG_DIGITS = 18;
#endif

void long_set_prec(pTHX_ int x) {
    if(x < 1)croak("1st arg (precision) to ld_set_prec must be at least 1");
    _MATH_COMPLEX_C_LONG_DIGITS = x;
}

SV * long_get_prec(pTHX) {
    return newSVuv(_MATH_COMPLEX_C_LONG_DIGITS);
}

int _is_nan(long double x) {
    if(x == x) return 0;
    return 1;
}

int _is_inf(long double x) {
    if(x == 0) return 0;
    if(_is_nan(x)) return 0;
    if(x / x == x / x) return 0;
    if(x < 0) return -1;
    return 1;
}

long double _get_nan(void) {
    long double nan = 0.0 / 0.0;
    return nan;
}

long double _get_neg_nan(void) {
    long double nan = 0.0 / 0.0;
    return -nan;
}

long double _get_inf(void) {
    long double inf = 1.0 / 0.0;
    return inf;
}

long double _get_neg_inf(void) {
    long double inf = -1.0 / 0.0;
    return inf;
}

long double _string_to_ld(pTHX_ SV * x) {
    long double ld;
    char * ptr;

    ld = (long double)SvNV(x);

    if(ld == 0.0L) {
      return strtold(SvPV_nolen(x), &ptr);
    }

    if(ld != ld) return _get_nan(); /* ld is NaN */

    if((ld / ld) != (ld / ld)) {    /* ld is Inf */
      if(ld < 0.0L) return _get_neg_inf();
      return _get_inf();
    }

    return strtold(SvPV_nolen(x), &ptr);
}

SV * create_cl(pTHX) {

     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in create() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     __real__ *pc = _get_nan();
     __imag__ *pc = _get_nan();

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;

}

void assign_cl(pTHX_ SV * rop, SV * d1, SV * d2) {
     long double _d1, _d2;
     char * ptr;

     if(sizeof(NV) == sizeof(long double)) {
       _d1 = (long double)SvNV(d1);
       _d2 = (long double)SvNV(d2);
     }
     else {
       _d1 = _string_to_ld(aTHX_ d1);
       _d2 = _string_to_ld(aTHX_ d2);
     }

     __real__ *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = _d1;
     __imag__ *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = _d2;
}

void LD2cl(pTHX_ SV * rop, SV * d1, SV * d2) {
     long double _d1, _d2;

     if(sv_isobject(d1) && sv_isobject(d2)) {
       const char *h1 = HvNAME(SvSTASH(SvRV(d1)));
       const char *h2 = HvNAME(SvSTASH(SvRV(d2)));
       if(strEQ(h1, "Math::LongDouble") &&
          strEQ(h2, "Math::LongDouble")) {

          _d1 = *(INT2PTR(long double *, SvIV(SvRV(d1))));
          _d2 = *(INT2PTR(long double *, SvIV(SvRV(d2))));

          __real__ *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = _d1;
          __imag__ *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = _d2;
       }
       else croak("Both 2nd and 3rd args supplied to LD2cl need to be Math::LongDouble objects");
     }
     else croak("Both 2nd and 3rd args supplied to LD2cl need to be Math::LongDouble objects");
}

void mul_cl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) *
                                                   *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op2))));
}

void mul_c_nvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) * SvNV(op2);
}

void mul_c_ivl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) * SvIV(op2);
}

void mul_c_uvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) * SvUV(op2);
}

void div_cl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) /
                                                   *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op2))));
}

void div_c_nvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) / SvNV(op2);
}

void div_c_ivl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) / SvIV(op2);
}

void div_c_uvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) / SvUV(op2);
}

void add_cl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) +
                                                   *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op2))));
}

void add_c_nvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) + SvNV(op2);
}

void add_c_ivl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) + SvIV(op2);
}

void add_c_uvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) + SvUV(op2);
}

void sub_cl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) -
                                                   *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op2))));
}

void sub_c_nvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) - SvNV(op2);
}

void sub_c_ivl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) - SvIV(op2);
}

void sub_c_uvl(pTHX_ SV * rop, SV * op1, SV * op2) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op1)))) - SvUV(op2);
}

void DESTROY(pTHX_ SV *  rop) {
     Safefree(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))));
}

SV * real_cl(pTHX_ SV * rop) {
     return newSVnv(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))));
}

SV * imag_cl(pTHX_ SV * rop) {
     return newSVnv(cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))));
}

void real_cl2LD(pTHX_ SV * rop, SV * op) {
     if(sv_isobject(rop)) {
       const char *h = HvNAME(SvSTASH(SvRV(rop)));
       if(strEQ(h, "Math::LongDouble")) {
         *(INT2PTR(long double *, SvIV(SvRV(rop)))) = creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
       }
       else croak("1st arg (a %s object) supplied to real_cl2LD needs to be a Math::LongDouble object", h);
     }
     else croak("1st arg (which needs to be a Math::LongDouble object) supplied to real_cl2LD is not an object");
}

void imag_cl2LD(pTHX_ SV * rop, SV * op) {
     if(sv_isobject(rop)) {
       const char *h = HvNAME(SvSTASH(SvRV(rop)));
       if(strEQ(h, "Math::LongDouble")) {
         *(INT2PTR(long double *, SvIV(SvRV(rop)))) = cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
       }
       else croak("1st arg (a %s object) supplied to imag_cl2LD needs to be a Math::LongDouble object", h);
     }
     else croak("1st arg (which needs to be a Math::LongDouble object) supplied to imag_cl2LD is not an object");
}

SV * arg_cl(pTHX_ SV * rop) {
     return newSVnv(cargl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))));
}

SV * abs_cl(pTHX_ SV * rop) {
     return newSVnv(cabsl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))));
}

void conj_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = conjl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void acos_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = cacosl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void asin_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = casinl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void atan_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = catanl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void cos_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = ccosl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void sin_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = csinl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void tan_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = ctanl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void acosh_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = cacoshl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void asinh_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = casinhl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void atanh_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = catanhl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void cosh_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = ccoshl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void sinh_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = csinhl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void tanh_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = ctanhl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void exp_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))= cexpl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void log_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = clogl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void sqrt_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = csqrtl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void proj_cl(pTHX_ SV * rop, SV * op) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = cprojl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))));
}

void pow_cl(pTHX_ SV * rop, SV * op, SV * exp) {
     *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))) = cpowl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(op)))),
                                                        *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(exp)))));
}

SV * _overload_true(pTHX_ SV * rop, SV * second, SV * third) {
     if (_is_nan(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))))) &&
         _is_nan(cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))))) return newSVuv(0);
     if(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))) ||
        cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))))) return newSVuv(1);
     return newSVuv(0);
}

SV * _overload_not(pTHX_ SV * rop, SV * second, SV * third) {
     if (_is_nan(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))))) &&
         _is_nan(cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))))) return newSVuv(1);
     if(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))) ||
        cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop)))))) return newSVuv(0);
     return newSVuv(1);
}

SV * _overload_equiv(pTHX_ SV * a, SV * b, SV * third) {
     if(SvUOK(b) || SvIOK(b) || SvNOK(b)) {
       if(SvNV(b) == creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))))) &&
          0       == cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))))) return newSVuv(1);
       return newSVuv(0);
     }
     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         if(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))))) == creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))))) &&
            cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))))) == cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))))))
              return newSVuv(1);
         return newSVuv(0);
       }
     }
     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_equiv function");
}

SV * _overload_not_equiv(pTHX_ SV * a, SV * b, SV * third) {
     if(SvUOK(b) || SvIOK(b) || SvNOK(b)) {
       if(SvNV(b) == creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))))) &&
          0       == cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))))) return newSVuv(0);
       return newSVuv(1);
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         if(creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))))) == creall(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))))) &&
            cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))))) == cimagl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))))))
              return newSVuv(0);
         return newSVuv(1);
       }
     }
     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_not_equiv function");
}


SV * _overload_pow(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc, t;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_pow() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);

     if(SvNOK(b) || SvIOK(b) || SvUOK(b) ) {
       __real__ t = SvNV(b);
       __imag__ t = 0.0;
       *pc = cpowl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))), t);
       return obj_ref;
     }
     else if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         *pc = cpowl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))), *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b)))));
         return obj_ref;
       }
     }
     else croak("Invalid argument supplied to Math::Complex_C::Long::_overload_pow function");
}

SV * _overload_mul(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_mul() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);

     if(SvUOK(b)) {
       *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) * SvUV(b);
       return obj_ref;
     }

     if(SvIOK(b)) {
       *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) * SvIV(b);
       return obj_ref;
     }

     if(SvNOK(b)) {
       *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) * SvNV(b);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) * *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_mul function");
}

SV * _overload_add(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_add() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);

     if(SvUOK(b)) {
       *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) + SvUV(b);
       return obj_ref;
     }

     if(SvIOK(b)) {
       *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) + SvIV(b);
       return obj_ref;
     }

     if(SvNOK(b)) {
       *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) + SvNV(b);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) + *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_add function");
}

SV * _overload_div(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_div() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);

     if(SvUOK(b)) {
       if(third == &PL_sv_yes) *pc = SvUV(b) / *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
       else *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) / SvUV(b);
       return obj_ref;
     }

     if(SvIOK(b)) {
       if(third == &PL_sv_yes) *pc = SvIV(b) / *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
       else *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) / SvIV(b);
       return obj_ref;
     }

     if(SvNOK(b)) {
       if(third == &PL_sv_yes) *pc = SvNV(b) / *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
       else *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) / SvNV(b);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) / *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_div function");
}

SV * _overload_sub(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_sub() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);

     if(SvUOK(b)) {
       if(third == &PL_sv_yes) *pc = SvUV(b) - *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
       else *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) - SvUV(b);
       return obj_ref;
     }

     if(SvIOK(b)) {
       if(third == &PL_sv_yes) *pc = SvIV(b) - *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
       else *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) - SvIV(b);
       return obj_ref;
     }

     if(SvNOK(b)) {
       if(third == &PL_sv_yes) *pc = SvNV(b) - *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
       else *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) - SvNV(b);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
         *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) - *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_sub function");
}

SV * _overload_sqrt(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_sqrt() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     *pc = csqrtl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))));

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _overload_pow_eq(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX t;
     SvREFCNT_inc(a);

     if(SvNOK(b) || SvIOK(b) || SvUOK(b)) {
       __real__ t = SvNV(b);
       __imag__ t = 0.0;
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) = cpowl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))), t);
       return a;
     }
     else if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) = cpowl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))),
                                                        *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b)))));
         return a;
       }
     }
     else {
       SvREFCNT_dec(a);
       croak("Invalid argument supplied to Math::Complex_C::Long::_overload_pow_eq function");
     }
}

SV * _overload_mul_eq(pTHX_ SV * a, SV * b, SV * third) {
     SvREFCNT_inc(a);

     if(SvUOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) *= SvUV(b);
       return a;
     }

     if(SvIOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) *= SvIV(b);
       return a;
     }

     if(SvNOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) *= SvNV(b);
       return a;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) *= *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return a;
       }
     }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_mul_eq function");
}

SV * _overload_add_eq(pTHX_ SV * a, SV * b, SV * third) {
     SvREFCNT_inc(a);

     if(SvUOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) += SvUV(b);
       return a;
     }

     if(SvIOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) += SvIV(b);
       return a;
     }

     if(SvNOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) += SvNV(b);
       return a;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) += *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return a;
       }
     }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_add_eq function");
}

SV * _overload_div_eq(pTHX_ SV * a, SV * b, SV * third) {
     SvREFCNT_inc(a);

     if(SvUOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) /= SvUV(b);
       return a;
     }

     if(SvIOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) /= SvIV(b);
       return a;
     }

     if(SvNOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) /= SvNV(b);
       return a;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) /= *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return a;
       }
     }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_div_eq function");
}

SV * _overload_sub_eq(pTHX_ SV * a, SV * b, SV * third) {
     SvREFCNT_inc(a);

     if(SvUOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) -= SvUV(b);
       return a;
     }

     if(SvIOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) -= SvIV(b);
       return a;
     }

     if(SvNOK(b)) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) -= SvNV(b);
       return a;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::Complex_C::Long")) {
       *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) -= *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b))));
         return a;
       }
     }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::Complex_C::Long::_overload_sub_eq function");
}

SV * _overload_copy(pTHX_ SV * a, SV * second, SV * third) {

     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_copy() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     __real__ *pc = __real__ *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));
     __imag__ *pc = __imag__ *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a))));

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;

}

SV * _overload_abs(pTHX_ SV * rop, SV * second, SV * third) {
     return newSVnv(cabsl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(rop))))));
}

SV * _overload_exp(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_exp() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     *pc = cexpl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))));

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _overload_log(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_log() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     *pc = clogl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))));

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _overload_sin(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_sin() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     *pc = csinl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))));

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _overload_cos(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_cos() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     *pc = ccosl(*(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))));

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _overload_atan2(pTHX_ SV * a, SV * b, SV * third) {
     MATH_COMPLEX *pc;
     SV * obj_ref, * obj;

     New(42, pc, 1, MATH_COMPLEX);
     if(pc == NULL) croak("Failed to allocate memory in _overload_atan2() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Complex_C::Long");

     *pc = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(a)))) /
           *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(b)))) ;

     *pc = catanl(*pc);

     sv_setiv(obj, INT2PTR(IV,pc));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * get_nanl(pTHX) {
     return newSVnv(_get_nan());
}

SV * get_neg_nanl(pTHX) {
     return newSVnv(_get_neg_nan());
}

SV * get_infl(pTHX) {
     return newSVnv(_get_inf());
}

SV * get_neg_infl(pTHX) {
     return newSVnv(_get_neg_inf());
}

SV * is_nanl(pTHX_ SV * a) {
     if(SvNV(a) == SvNV(a)) return newSVuv(0);
     return newSVuv(1);
}

SV * is_infl(pTHX_ SV * a) {
     if(SvNV(a) == 0) return newSVuv(0);
     if(SvNV(a) != SvNV(a)) return newSVuv(0);
     if(SvNV(a) / SvNV(a) == SvNV(a) / SvNV(a)) return newSVuv(0);
     if(SvNV(a) < 0) return newSViv(-1);
     return newSViv(1);
}

SV * _complex_type(pTHX) {
    return newSVpv("long double _Complex", 0);
}

SV * _double_type(pTHX) {
    return newSVpv("long double", 0);
}

SV * _get_nv(pTHX_ SV * x) {
     return newSVnv(SvNV(x));
}

SV * _which_package(pTHX_ SV * b) {
     if(sv_isobject(b)) return newSVpv(HvNAME(SvSTASH(SvRV(b))), 0);
     return newSVpv("Not an object", 0);
}

SV * _wrap_count(pTHX) {
     return newSVuv(PL_sv_count);
}

SV * _ivsize(pTHX) {
     return newSViv(sizeof(IV));
}

SV * _nvsize(pTHX) {
     return newSViv(sizeof(NV));
}

SV * _doublesize(pTHX) {
     return newSViv(sizeof(double));
}

SV * _longdoublesize(pTHX) {
     return newSViv(sizeof(long double));
}

SV * _double_Complexsize(pTHX) {
     return newSViv(sizeof(double _Complex));
}

SV * _longdouble_Complexsize(pTHX) {
     return newSViv(sizeof(long double _Complex));
}

void ld_to_str(pTHX_ SV * ld) {
     dXSARGS;
     MATH_COMPLEX t;
     char *rbuffer;

     if(sv_isobject(ld)) {
       const char *h = HvNAME(SvSTASH(SvRV(ld)));
       if(strEQ(h, "Math::Complex_C::Long")) {
          EXTEND(SP, 2);
          t = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(ld))));

          Newx(rbuffer, 8 + _MATH_COMPLEX_C_LONG_DIGITS, char);
          if(rbuffer == NULL) croak("Failed to allocate memory in ld_to_str()");

          sprintf(rbuffer, "%.*Le", _MATH_COMPLEX_C_LONG_DIGITS - 1, __real__ t);
          ST(0) = sv_2mortal(newSVpv(rbuffer, 0));

          sprintf(rbuffer, "%.*Le", _MATH_COMPLEX_C_LONG_DIGITS - 1, __imag__ t);
          ST(1) = sv_2mortal(newSVpv(rbuffer, 0));

          Safefree(rbuffer);
          XSRETURN(2);
       }
       else croak("ld_to_str function needs a Math::Complex_C::Long arg but was supplied with a %s arg", h);
     }
     else croak("Invalid argument supplied to Math::Complex_C::Long::ld_to_str function");
}

void ld_to_strp(pTHX_ SV * ld, int prec) {
     dXSARGS;
     MATH_COMPLEX t;
     char *rbuffer;

     if(sv_isobject(ld)) {
       const char *h = HvNAME(SvSTASH(SvRV(ld)));
       if(strEQ(h, "Math::Complex_C::Long")) {
          EXTEND(SP, 2);
          t = *(INT2PTR(MATH_COMPLEX *, SvIV(SvRV(ld))));

          Newx(rbuffer, 8 + prec, char);
          if(rbuffer == NULL) croak("Failed to allocate memory (real) in ld_to_strp()");

          sprintf(rbuffer, "%.*Le", prec - 1, __real__ t);
          ST(0) = sv_2mortal(newSVpv(rbuffer, 0));

          sprintf(rbuffer, "%.*Le", prec - 1, __imag__ t);
          ST(1) = sv_2mortal(newSVpv(rbuffer, 0));

          Safefree(rbuffer);
          XSRETURN(2);
       }
       else croak("ld_to_strp function needs a Math::Complex_C::Long arg but was supplied with a %s arg", h);
     }
     else croak("Invalid argument supplied to Math::Complex_C::Long::ld_to_strp function");
}

SV * _LDBL_DIG(pTHX) {
#ifdef LDBL_DIG
     return newSViv(LDBL_DIG);
#else
     return 0;
#endif
}

SV * _get_xs_version(pTHX) {
     return newSVpv(XS_VERSION, 0);
}





MODULE = Math::Complex_C::Long	PACKAGE = Math::Complex_C::Long

PROTOTYPES: DISABLE


void
long_set_prec (x)
	int	x
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	long_set_prec(aTHX_ x);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
long_get_prec ()
CODE:
  RETVAL = long_get_prec (aTHX);
OUTPUT:  RETVAL


SV *
create_cl ()
CODE:
  RETVAL = create_cl (aTHX);
OUTPUT:  RETVAL


void
assign_cl (rop, d1, d2)
	SV *	rop
	SV *	d1
	SV *	d2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	assign_cl(aTHX_ rop, d1, d2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
LD2cl (rop, d1, d2)
	SV *	rop
	SV *	d1
	SV *	d2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	LD2cl(aTHX_ rop, d1, d2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
mul_cl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	mul_cl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
mul_c_nvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	mul_c_nvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
mul_c_ivl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	mul_c_ivl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
mul_c_uvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	mul_c_uvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
div_cl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	div_cl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
div_c_nvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	div_c_nvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
div_c_ivl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	div_c_ivl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
div_c_uvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	div_c_uvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
add_cl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	add_cl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
add_c_nvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	add_c_nvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
add_c_ivl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	add_c_ivl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
add_c_uvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	add_c_uvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sub_cl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sub_cl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sub_c_nvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sub_c_nvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sub_c_ivl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sub_c_ivl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sub_c_uvl (rop, op1, op2)
	SV *	rop
	SV *	op1
	SV *	op2
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sub_c_uvl(aTHX_ rop, op1, op2);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
DESTROY (rop)
	SV *	rop
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	DESTROY(aTHX_ rop);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
real_cl (rop)
	SV *	rop
CODE:
  RETVAL = real_cl (aTHX_ rop);
OUTPUT:  RETVAL

SV *
imag_cl (rop)
	SV *	rop
CODE:
  RETVAL = imag_cl (aTHX_ rop);
OUTPUT:  RETVAL

void
real_cl2LD (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	real_cl2LD(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
imag_cl2LD (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	imag_cl2LD(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
arg_cl (rop)
	SV *	rop
CODE:
  RETVAL = arg_cl (aTHX_ rop);
OUTPUT:  RETVAL

SV *
abs_cl (rop)
	SV *	rop
CODE:
  RETVAL = abs_cl (aTHX_ rop);
OUTPUT:  RETVAL

void
conj_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	conj_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
acos_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	acos_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
asin_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	asin_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
atan_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	atan_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
cos_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	cos_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sin_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sin_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
tan_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	tan_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
acosh_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	acosh_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
asinh_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	asinh_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
atanh_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	atanh_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
cosh_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	cosh_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sinh_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sinh_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
tanh_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	tanh_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
exp_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	exp_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
log_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	log_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
sqrt_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	sqrt_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
proj_cl (rop, op)
	SV *	rop
	SV *	op
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	proj_cl(aTHX_ rop, op);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
pow_cl (rop, op, exp)
	SV *	rop
	SV *	op
	SV *	exp
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	pow_cl(aTHX_ rop, op, exp);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
_overload_true (rop, second, third)
	SV *	rop
	SV *	second
	SV *	third
CODE:
  RETVAL = _overload_true (aTHX_ rop, second, third);
OUTPUT:  RETVAL

SV *
_overload_not (rop, second, third)
	SV *	rop
	SV *	second
	SV *	third
CODE:
  RETVAL = _overload_not (aTHX_ rop, second, third);
OUTPUT:  RETVAL

SV *
_overload_equiv (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_equiv (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_not_equiv (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_not_equiv (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_pow (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_pow (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_mul (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_mul (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_add (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_add (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_div (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_div (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_sub (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_sub (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_sqrt (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_sqrt (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_pow_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_pow_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_mul_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_mul_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_add_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_add_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_div_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_div_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_sub_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_sub_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_copy (a, second, third)
	SV *	a
	SV *	second
	SV *	third
CODE:
  RETVAL = _overload_copy (aTHX_ a, second, third);
OUTPUT:  RETVAL

SV *
_overload_abs (rop, second, third)
	SV *	rop
	SV *	second
	SV *	third
CODE:
  RETVAL = _overload_abs (aTHX_ rop, second, third);
OUTPUT:  RETVAL

SV *
_overload_exp (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_exp (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_log (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_log (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_sin (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_sin (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_cos (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_cos (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
_overload_atan2 (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = _overload_atan2 (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
get_nanl ()
CODE:
  RETVAL = get_nanl (aTHX);
OUTPUT:  RETVAL


SV *
get_neg_nanl ()
CODE:
  RETVAL = get_neg_nanl (aTHX);
OUTPUT:  RETVAL


SV *
get_infl ()
CODE:
  RETVAL = get_infl (aTHX);
OUTPUT:  RETVAL


SV *
get_neg_infl ()
CODE:
  RETVAL = get_neg_infl (aTHX);
OUTPUT:  RETVAL


SV *
is_nanl (a)
	SV *	a
CODE:
  RETVAL = is_nanl (aTHX_ a);
OUTPUT:  RETVAL

SV *
is_infl (a)
	SV *	a
CODE:
  RETVAL = is_infl (aTHX_ a);
OUTPUT:  RETVAL

SV *
_complex_type ()
CODE:
  RETVAL = _complex_type (aTHX);
OUTPUT:  RETVAL


SV *
_double_type ()
CODE:
  RETVAL = _double_type (aTHX);
OUTPUT:  RETVAL


SV *
_get_nv (x)
	SV *	x
CODE:
  RETVAL = _get_nv (aTHX_ x);
OUTPUT:  RETVAL

SV *
_which_package (b)
	SV *	b
CODE:
  RETVAL = _which_package (aTHX_ b);
OUTPUT:  RETVAL

SV *
_wrap_count ()
CODE:
  RETVAL = _wrap_count (aTHX);
OUTPUT:  RETVAL


SV *
_ivsize ()
CODE:
  RETVAL = _ivsize (aTHX);
OUTPUT:  RETVAL


SV *
_nvsize ()
CODE:
  RETVAL = _nvsize (aTHX);
OUTPUT:  RETVAL


SV *
_doublesize ()
CODE:
  RETVAL = _doublesize (aTHX);
OUTPUT:  RETVAL


SV *
_longdoublesize ()
CODE:
  RETVAL = _longdoublesize (aTHX);
OUTPUT:  RETVAL


SV *
_double_Complexsize ()
CODE:
  RETVAL = _double_Complexsize (aTHX);
OUTPUT:  RETVAL


SV *
_longdouble_Complexsize ()
CODE:
  RETVAL = _longdouble_Complexsize (aTHX);
OUTPUT:  RETVAL


void
ld_to_str (ld)
	SV *	ld
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	ld_to_str(aTHX_ ld);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
ld_to_strp (ld, prec)
	SV *	ld
	int	prec
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	ld_to_strp(aTHX_ ld, prec);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
_LDBL_DIG ()
CODE:
  RETVAL = _LDBL_DIG (aTHX);
OUTPUT:  RETVAL


SV *
_get_xs_version ()
CODE:
  RETVAL = _get_xs_version (aTHX);
OUTPUT:  RETVAL


