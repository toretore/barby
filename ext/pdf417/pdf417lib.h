/*
 * Copyright 2003 by Paulo Soares.
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the License.
 *
 * The Original Code is 'pdf417lib, a library to generate the bidimensional barcode PDF417'.
 *
 * The Initial Developer of the Original Code is Paulo Soares. Portions created by
 * the Initial Developer are Copyright (C) 2003 by Paulo Soares.
 * All Rights Reserved.
 *
 * Contributor(s): all the names of the contributors are added in the source code
 * where applicable.
 *
 * Alternatively, the contents of this file may be used under the terms of the
 * LGPL license (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
 * provisions of LGPL are applicable instead of those above.  If you wish to
 * allow use of your version of this file only under the terms of the LGPL
 * License and not to allow others to use your version of this file under
 * the MPL, indicate your decision by deleting the provisions above and
 * replace them with the notice and other provisions required by the LGPL.
 * If you do not delete the provisions above, a recipient may use your version
 * of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE.
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the MPL as stated above or under the terms of the GNU
 * Library General Public License as published by the Free Software Foundation;
 * either version 2 of the License, or any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Library general Public License for more
 * details.
 *
 * If you didn't download this code from the following link, you should check if
 * you aren't using an obsolete version:
 * http://sourceforge.net/projects/pdf417lib
 */
#ifndef __PDF417LIB_H__
#define __PDF417LIB_H__

#ifdef __cplusplus
extern "C" {
#endif

#define PDF417_USE_ASPECT_RATIO     0
#define PDF417_FIXED_RECTANGLE      1
#define PDF417_FIXED_COLUMNS        2
#define PDF417_FIXED_ROWS           4
#define PDF417_AUTO_ERROR_LEVEL     0
#define PDF417_USE_ERROR_LEVEL      16
#define PDF417_USE_RAW_CODEWORDS    64
#define PDF417_INVERT_BITMAP        128

#define PDF417_ERROR_SUCCESS        0
#define PDF417_ERROR_TEXT_TOO_BIG   1
#define PDF417_ERROR_INVALID_PARAMS 2


typedef struct _pdf417param {
    char *outBits;
    int lenBits;
    int bitColumns;
    int codeRows;
    int codeColumns;
    int codewords[928];
    int lenCodewords;
    int errorLevel;
    char *text;
    int lenText;
    int options;
    float aspectRatio;
    float yHeight;
    int error;
} pdf417param, *pPdf417param;

void paintCode(pPdf417param p);
void fetchCodewords(pPdf417param p);
void pdf417init(pPdf417param param);
void pdf417free(pPdf417param param);
#ifdef __cplusplus
}
#endif

#endif
