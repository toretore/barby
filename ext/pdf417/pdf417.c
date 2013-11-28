#include <ruby.h>
#include "pdf417lib.h"
#include "pdf417.h"


VALUE rb_cPdf417;
VALUE rb_cPdf417_Lib;


/* :nodoc: */
static void rb_pdf417_lib_cleanup(void *p) {
  pdf417free(p); 
}

/*
 * call-seq:
 *  new
 *
 * Makes a new PDF417 object for the given text string
 */
static VALUE rb_pdf417_lib_new(VALUE klass) {
  pdf417param *ptr;
  VALUE tdata = Data_Make_Struct(klass, pdf417param, 0, rb_pdf417_lib_cleanup, ptr);
  pdf417init(ptr);
  return tdata;
}

/*
 * call-seq:
 *  paintCode
 *
 * Compute paintCode
 */
static VALUE rb_pdf417_lib_paintCode(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  paintCode(ptr);
  return Qnil;
}

/*
 * call-seq:
 *  getAspectRatio
 *
 * The y/x aspect ratio
 */
static VALUE rb_pdf417_lib_getAspectRatio(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return rb_float_new(ptr->aspectRatio);
}

/*
 * call-seq:
 *  setAspectRatio(aspectRatio)
 *
 * The y/x aspect ratio
 */
static VALUE rb_pdf417_lib_setAspectRatio(VALUE self, VALUE aspectRatio) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->aspectRatio = NUM2DBL(aspectRatio);
  return rb_float_new(ptr->aspectRatio);
}

/*
 * call-seq:
 *  getBitColumns
 *
 * The number of code columns
 */
static VALUE rb_pdf417_lib_getBitColumns(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->bitColumns);
}

/*
 * call-seq:
 *  getCodeColumns
 *
 * The number of code columns
 */
static VALUE rb_pdf417_lib_getCodeColumns(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->codeColumns);
}

/*
 * call-seq:
 *  setCodeColumns(codeColumns)
 *
 * The number of code columns
 */
static VALUE rb_pdf417_lib_setCodeColumns(VALUE self, VALUE codeColumns) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->codeColumns = NUM2INT(codeColumns);
  return INT2NUM(ptr->codeColumns);
}

/*
 * call-seq:
 *  getCodeRows
 *
 * The number of code rows and bitmap lines
 */
static VALUE rb_pdf417_lib_getCodeRows(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->codeRows);
}

/*
 * call-seq:
 *  setCodeRows(codeRows)
 *
 * The number of code rows and bitmap lines
 */
static VALUE rb_pdf417_lib_setCodeRows(VALUE self, VALUE codeRows) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->codeRows = NUM2INT(codeRows);
  return INT2NUM(ptr->codeRows);
}

/*
 * call-seq:
 *  getErrorLevel
 *
 * The error level required 0-8
 */
static VALUE rb_pdf417_lib_getErrorLevel(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->errorLevel);
}

/*
 * call-seq:
 *  setErrorLevel(errorLevel)
 *
 * The error level required 0-8
 */
static VALUE rb_pdf417_lib_setErrorLevel(VALUE self, VALUE errorLevel) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->errorLevel = NUM2INT(errorLevel);
  return INT2NUM(ptr->errorLevel);
}

/*
 * call-seq:
 *  getLenCodewords
 *
 * The size of the code words, including error correction codes
 */
static VALUE rb_pdf417_lib_getLenCodewords(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->lenCodewords);
}

/*
 * call-seq:
 *  setLenCodewords(lenCodewords)
 *
 * The size of the code words, including error correction codes
 */
static VALUE rb_pdf417_lib_setLenCodewords(VALUE self, VALUE lenCodewords) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->lenCodewords = NUM2INT(lenCodewords);
  return INT2NUM(ptr->lenCodewords);
}

/*
 * call-seq:
 *  getOutBits
 *
 * Sets the text to convert into a barcode
 */
static VALUE rb_pdf417_lib_getOutBits(VALUE self) {
  VALUE list;
  int lenOutBits, k;
  pdf417param *ptr;

  Data_Get_Struct(self, pdf417param, ptr);
  lenOutBits = strlen(ptr->outBits);

  list = rb_ary_new2(lenOutBits);

  for (k = 0; k < lenOutBits; k++) {
    rb_ary_push(list, INT2NUM(ptr->outBits[k]));
  }

  return list;
}

/*
 * call-seq:
 *  getText
 *
 * Sets the text to convert into a barcode
 */
static VALUE rb_pdf417_lib_getText(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return rb_str_new2(ptr->text);
}

/*
 * call-seq:
 *  setText(text)
 *
 * Sets the text to convert into a barcode
 */
static VALUE rb_pdf417_lib_setText(VALUE self, VALUE text) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->text = StringValuePtr(text);
  return rb_str_new2(ptr->text);
}

/*
 * call-seq:
 *  getYHeight
 *
 * The y/x dot ratio
 */
static VALUE rb_pdf417_lib_getYHeight(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return rb_float_new(ptr->yHeight);
}

/*
 * call-seq:
 *  setYHeight(yHeight)
 *
 * The y/x dot ratio
 */
static VALUE rb_pdf417_lib_setYHeight(VALUE self, VALUE yHeight) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  ptr->yHeight = NUM2DBL(yHeight);
  return rb_float_new(ptr->yHeight);
}


// The initialization method for this module
void Init_pdf417() {
  rb_cPdf417 = rb_define_class("Pdf417", rb_cObject); // Our Pdf417 object    
  rb_cPdf417_Lib = rb_define_class_under(rb_cPdf417, "Lib", rb_cObject); // Our Pdf417::Lib object, to represent the C file
  rb_define_singleton_method(rb_cPdf417_Lib, "new", rb_pdf417_lib_new, 0);

  // Instance methods
  rb_define_method(rb_cPdf417_Lib, "paintCode", rb_pdf417_lib_paintCode, 0);

  // Getters
  rb_define_method(rb_cPdf417_Lib, "getAspectRatio", rb_pdf417_lib_getAspectRatio, 0);
  rb_define_method(rb_cPdf417_Lib, "getBitColumns", rb_pdf417_lib_getBitColumns, 0);
  rb_define_method(rb_cPdf417_Lib, "getCodeColumns", rb_pdf417_lib_getCodeColumns, 0);
  rb_define_method(rb_cPdf417_Lib, "getCodeRows", rb_pdf417_lib_getCodeRows, 0);
  rb_define_method(rb_cPdf417_Lib, "getErrorLevel", rb_pdf417_lib_getErrorLevel, 0);
  rb_define_method(rb_cPdf417_Lib, "getLenCodewords", rb_pdf417_lib_getLenCodewords, 0);
  rb_define_method(rb_cPdf417_Lib, "getOutBits", rb_pdf417_lib_getOutBits, 0);
  rb_define_method(rb_cPdf417_Lib, "getText", rb_pdf417_lib_getText, 0);
  rb_define_method(rb_cPdf417_Lib, "getYHeight", rb_pdf417_lib_getYHeight, 0);

  // Setters
  rb_define_method(rb_cPdf417_Lib, "setAspectRatio", rb_pdf417_lib_setAspectRatio, 1);
  rb_define_method(rb_cPdf417_Lib, "setCodeColumns", rb_pdf417_lib_setCodeColumns, 1);
  rb_define_method(rb_cPdf417_Lib, "setCodeRows", rb_pdf417_lib_setCodeRows, 1);
  rb_define_method(rb_cPdf417_Lib, "setErrorLevel", rb_pdf417_lib_setErrorLevel, 1);
  rb_define_method(rb_cPdf417_Lib, "setLenCodewords", rb_pdf417_lib_setLenCodewords, 1);
  rb_define_method(rb_cPdf417_Lib, "setText", rb_pdf417_lib_setText, 1);
  rb_define_method(rb_cPdf417_Lib, "setYHeight", rb_pdf417_lib_setYHeight, 1);
}
