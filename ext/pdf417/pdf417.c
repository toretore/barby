/*  NOTE:  This relies on the PDF417 Library from http://sourceforge.net/projects/pdf417lib and is included here 
 * It is a little odd and not too C-like, because it is called 'pdf417' but defines both the PDF417 and the PDF417::Lib
 * class.  Note that the majority of the functions are for the PDF417::Lib class, the PDF417 class is only a placeholder.
*/

#include <ruby.h>
#include "pdf417lib.h"
#include "pdf417.h"

/*  A wrapper for the pdf417lib C Library, from the README:

      A library to generate the 2D barcode PDF417

      Project: http://sourceforge.net/projects/pdf417.lib
      Creator: Paulo Soares (psoares@consiste.pt)
      License: LGPL or MPL 1.1

      This library generates a PDF417 image of the barcode in a 1x1 scale.
      It requires that the displayed image be as least stretched 3 times
      in the vertical direction in relation with the horizontal dimension.
   
   This class will interface with the C library to take a text string representing
   the barcode data and produce a list of data codewords, or a binary string (blob)
   representing a bitmap.

 */


// The initialization method for this module
void Init_pdf417() {
  rb_cPdf417 = rb_define_class("PDF417", rb_cObject); // Our PDF417 object    
  rb_cPdf417_Lib = rb_define_class_under(rb_cPdf417, "Lib", rb_cObject); // Our PDF417::Lib object, to represent the C file
  rb_define_singleton_method(rb_cPdf417_Lib, "encode_text", rb_pdf417_lib_encode_text, 1);
  rb_define_singleton_method(rb_cPdf417_Lib, "new", rb_pdf417_lib_new, 1);
  rb_define_method(rb_cPdf417_Lib, "initialize", rb_pdf417_lib_init, 1);
  rb_define_method(rb_cPdf417_Lib, "codewords", rb_pdf417_lib_codewords, 0);
  rb_define_method(rb_cPdf417_Lib, "to_blob", rb_pdf417_lib_to_blob, 0);
  rb_define_method(rb_cPdf417_Lib, "bit_columns", rb_pdf417_lib_bitColumns, 0);
  rb_define_method(rb_cPdf417_Lib, "bit_length", rb_pdf417_lib_lenBits, 0);
  rb_define_method(rb_cPdf417_Lib, "code_rows", rb_pdf417_lib_codeRows, 0);
  rb_define_method(rb_cPdf417_Lib, "code_cols", rb_pdf417_lib_codeColumns, 0);
  rb_define_method(rb_cPdf417_Lib, "codeword_length", rb_pdf417_lib_lenCodewords, 0);
  rb_define_method(rb_cPdf417_Lib, "error_level", rb_pdf417_lib_errorLevel, 0);
  rb_define_method(rb_cPdf417_Lib, "aspect_ratio", rb_pdf417_lib_aspectRatio, 0);
  rb_define_method(rb_cPdf417_Lib, "y_height", rb_pdf417_lib_yHeight, 0);
  rb_define_method(rb_cPdf417_Lib, "generation_error", rb_pdf417_lib_error, 0);  
}

/*
 * call-seq:
 *   encode_text(text)
 *
 * Returns an array of integers showing the codewords
 */
static VALUE rb_pdf417_lib_encode_text(VALUE self, VALUE text) {
  VALUE list;
  int k;
  
  pdf417param p;
  pdf417init(&p);
  p.text = StringValuePtr(text);
  fetchCodewords(&p);
  if (p.error) {
      pdf417free(&p);
      return Qnil; //could also return list or raise something
  }
  
  list = rb_ary_new2(p.lenCodewords);
  
  pdf417free(&p); 
  
  for (k = 0; k < p.lenCodewords; ++k) {
    rb_ary_push(list, INT2NUM(p.codewords[k]));
  }
  return list;
}

/* :nodoc: */
static void rb_pdf417_lib_cleanup(void *p) {
  pdf417free(p); 
}

/* :nodoc: */
static VALUE rb_pdf417_lib_init(VALUE self, VALUE text) {
  rb_iv_set(self, "@text", text);
  return self;
}

/*
 * call-seq:
 *  new(text)
 *
 * Makes a new PDF417 object for the given text string
 */
static VALUE rb_pdf417_lib_new(VALUE class, VALUE text) {
  VALUE argv[1];
  pdf417param *ptr;
  VALUE tdata = Data_Make_Struct(class, pdf417param, 0, rb_pdf417_lib_cleanup, ptr);
  pdf417init(ptr);
  rb_iv_set(tdata, "@generation_options", INT2NUM(ptr->options));
  argv[0] = text;
  rb_obj_call_init(tdata, 1, argv);
  return tdata;
}

/*
 * call-seq:
 *  codewords
 *
 * Generates an array of codewords from the current text attribute
 */
static VALUE rb_pdf417_lib_codewords(VALUE self) {
  VALUE list, text;
  int k;
  pdf417param p;
  
  
  text = rb_iv_get(self, "@text"); 
  pdf417init(&p);
  p.text = StringValuePtr(text);
  fetchCodewords(&p);
  if (p.error) {
      pdf417free(&p);
      return Qnil; //could also return list or raise something
  }
  
  list = rb_ary_new2(p.lenCodewords);
  
  pdf417free(&p); 
  
  for (k = 0; k < p.lenCodewords; ++k) {
    rb_ary_push(list, INT2NUM(p.codewords[k]));
  }
  return list;
}

/*
 * call-seq:
 *  to_blob
 *
 * Returns a binary string representing the image bits, requires scaling before display
 */
static VALUE rb_pdf417_lib_to_blob(VALUE self) {
  VALUE generation_options, text, aspect_ratio, raw_codewords, y_height, error_level, code_rows, code_cols;
  pdf417param *ptr;
  int options = 0;
  
  Data_Get_Struct(self, pdf417param, ptr);
  generation_options = rb_iv_get(self, "@generation_options");
  text = rb_iv_get(self, "@text"); 
  aspect_ratio = rb_iv_get(self, "@aspect_ratio");
  raw_codewords = rb_iv_get(self, "@raw_codewords");
  y_height = rb_iv_get(self, "@y_height");
  error_level = rb_iv_get(self, "@error_level");
  code_rows = rb_iv_get(self, "@code_rows");
  code_cols = rb_iv_get(self, "@code_cols");
  
  // re-set our internal variables
  pdf417init(ptr);
  
  // Always set the text, can't really go wrong here
  ptr->text = StringValuePtr(text);
  
  // Start setting them based off of what we got
  if ( TYPE(generation_options) == T_FIXNUM ){
    ptr->options = FIX2INT(generation_options);
  }
  
  if ( TYPE(aspect_ratio) == T_FLOAT ){
    ptr->aspectRatio = (float)NUM2DBL(aspect_ratio);
  }
  
  if ( TYPE(y_height) == T_FLOAT ){
    ptr->yHeight = (float)NUM2DBL(y_height);
  }
  
  if ( TYPE(error_level) == T_FIXNUM ){
    ptr->errorLevel = FIX2INT(error_level);
  }
  
  if ( TYPE(code_rows) == T_FIXNUM ){    
    ptr->codeRows = FIX2INT(code_rows);
  }

  if ( TYPE(code_cols) == T_FIXNUM ){
    ptr->codeColumns = FIX2INT(code_cols);
  }
    
  if ( TYPE(raw_codewords) == T_ARRAY && ptr->options & PDF417_USE_RAW_CODEWORDS){
    ptr->lenCodewords = RARRAY_LEN(raw_codewords);
    int k;
    for (k = 0; k < ptr->lenCodewords; ++k) {
      ptr->codewords[k] = FIX2INT(rb_ary_entry(raw_codewords, k));
    }
  }
  
  paintCode(ptr); 
  
  if (ptr->error && ptr->error != PDF417_ERROR_SUCCESS) {
      return Qnil; //could also return list
  }
  
  return rb_str_new2(ptr->outBits);
}

/*
 * call-seq:
 *  bit_columns
 *
 * The number of column bits in the bitmap
 */
static VALUE rb_pdf417_lib_bitColumns(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->bitColumns);
}

/*
 * call-seq:
 *  bit_length
 *
 * The size in bytes of the bitmap
 */
static VALUE rb_pdf417_lib_lenBits(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->lenBits);
}

/*
 * call-seq:
 *  code_rows
 *
 * The number of code rows and bitmap lines
 */
static VALUE rb_pdf417_lib_codeRows(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->codeRows);
}

/*
 * call-seq:
 *  code_cols
 *
 * The number of code columns
 */
static VALUE rb_pdf417_lib_codeColumns(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->codeColumns);
}

/*
 * call-seq:
 *  codeword_length
 *
 * The size of the code words, including error correction codes
 */
static VALUE rb_pdf417_lib_lenCodewords(VALUE self) {
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->lenCodewords);
}

/*
 * call-seq:
 *  error_level
 *
 * The error level required 0-8
 */
static VALUE rb_pdf417_lib_errorLevel(VALUE self){
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->errorLevel);
}

/*
 * call-seq:
 *  aspect_ratio
 *
 * The y/x aspect ratio
 */
static VALUE rb_pdf417_lib_aspectRatio(VALUE self){
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return rb_float_new(ptr->aspectRatio);
}

/*
 * call-seq:
 *  y_height
 *
 * The y/x dot ratio
 */
static VALUE rb_pdf417_lib_yHeight(VALUE self){
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return rb_float_new(ptr->yHeight);
}

/*
 * call-seq:
 *  generation_error
 *
 * The error returned as an int, defined in C as:
 * [PDF417_ERROR_SUCCESS] no errors
 * [PDF417_ERROR_TEXT_TOO_BIG] the text was too big the PDF417 specifications
 * [PDF417_ERROR_INVALID_PARAMS] invalid parameters. Only used with PDF417_USE_RAW_CODEWORDS
 */
static VALUE rb_pdf417_lib_error(VALUE self){
  pdf417param *ptr;
  Data_Get_Struct(self, pdf417param, ptr);
  return INT2NUM(ptr->error);
}
