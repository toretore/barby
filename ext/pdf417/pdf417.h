
VALUE rb_cPdf417;
VALUE rb_cPdf417_Lib;
static VALUE rb_pdf417_lib_encode_text(VALUE self, VALUE text);
static VALUE rb_pdf417_lib_codewords(VALUE self);
static VALUE rb_pdf417_lib_to_blob(VALUE self);
static VALUE rb_pdf417_lib_new(VALUE class, VALUE text);
static void rb_pdf417_lib_cleanup(void *p);
static VALUE rb_pdf417_lib_init(VALUE self, VALUE text);
static VALUE rb_pdf417_lib_bitColumns(VALUE self);
static VALUE rb_pdf417_lib_lenBits(VALUE self);
static VALUE rb_pdf417_lib_codeRows(VALUE self);
static VALUE rb_pdf417_lib_codeColumns(VALUE self);
static VALUE rb_pdf417_lib_lenCodewords(VALUE self);
static VALUE rb_pdf417_lib_errorLevel(VALUE self);
static VALUE rb_pdf417_lib_aspectRatio(VALUE self);
static VALUE rb_pdf417_lib_yHeight(VALUE self);
static VALUE rb_pdf417_lib_error(VALUE self);