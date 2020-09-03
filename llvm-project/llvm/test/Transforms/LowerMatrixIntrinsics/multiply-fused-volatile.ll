; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -fuse-matrix-use-loops -fuse-matrix-tile-size=2 -matrix-allow-contract -force-fuse-matrix -verify-dom-info %s -S | FileCheck %s

; REQUIRES: aarch64-registered-target

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "aarch64-apple-ios"

define void @multiply_all_volatile(<4 x double>* noalias %A, <4 x double>* noalias %B, <4 x double>* noalias %C) {
; CHECK-LABEL: @multiply_all_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[COLS_HEADER:%.*]]
; CHECK:       cols.header:
; CHECK-NEXT:    [[COLS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[COLS_STEP:%.*]], [[COLS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[COLS_BODY:%.*]]
; CHECK:       cols.body:
; CHECK-NEXT:    br label [[ROWS_HEADER:%.*]]
; CHECK:       rows.header:
; CHECK-NEXT:    [[ROWS_IV:%.*]] = phi i64 [ 0, [[COLS_BODY]] ], [ [[ROWS_STEP:%.*]], [[ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[ROWS_BODY:%.*]]
; CHECK:       rows.body:
; CHECK-NEXT:    br label [[INNER_HEADER:%.*]]
; CHECK:       inner.header:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[ROWS_BODY]] ], [ [[INNER_STEP:%.*]], [[INNER_LATCH:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP17:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP23:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    br label [[INNER_BODY:%.*]]
; CHECK:       inner.body:
; CHECK-NEXT:    [[TMP2:%.*]] = mul i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[TMP2]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x double>* [[A:%.*]] to double*
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr double, double* [[TMP4]], i64 [[TMP3]]
; CHECK-NEXT:    [[COL_CAST:%.*]] = bitcast double* [[TMP5]] to <4 x double>*
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <4 x double>* [[COL_CAST]] to double*
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP6]], i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = add i64 [[TMP7]], [[INNER_IV]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <4 x double>* [[B:%.*]] to double*
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr double, double* [[TMP9]], i64 [[TMP8]]
; CHECK-NEXT:    [[COL_CAST3:%.*]] = bitcast double* [[TMP10]] to <4 x double>*
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast <4 x double>* [[COL_CAST3]] to double*
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[TMP11]], i64 2
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK9:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <2 x double> undef, double [[TMP12]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK9]], <2 x double> [[SPLAT_SPLAT]], <2 x double> [[BLOCK]])
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <2 x double> undef, double [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT11]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK10]], <2 x double> [[SPLAT_SPLAT12]], <2 x double> [[TMP13]])
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <2 x double> [[TMP15]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP17]] = shufflevector <2 x double> [[TMP0]], <2 x double> [[TMP16]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK14:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT15:%.*]] = insertelement <2 x double> undef, double [[TMP18]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT15]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK14]], <2 x double> [[SPLAT_SPLAT16]], <2 x double> [[BLOCK13]])
; CHECK-NEXT:    [[BLOCK17:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT18:%.*]] = insertelement <2 x double> undef, double [[TMP20]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT18]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP21:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK17]], <2 x double> [[SPLAT_SPLAT19]], <2 x double> [[TMP19]])
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <2 x double> [[TMP21]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP23]] = shufflevector <2 x double> [[TMP1]], <2 x double> [[TMP22]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    br label [[INNER_LATCH]]
; CHECK:       inner.latch:
; CHECK-NEXT:    [[INNER_STEP]] = add i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[INNER_COND:%.*]] = icmp ne i64 [[INNER_STEP]], 2
; CHECK-NEXT:    br i1 [[INNER_COND]], label [[INNER_HEADER]], label [[ROWS_LATCH]], !llvm.loop !0
; CHECK:       rows.latch:
; CHECK-NEXT:    [[ROWS_STEP]] = add i64 [[ROWS_IV]], 2
; CHECK-NEXT:    [[ROWS_COND:%.*]] = icmp ne i64 [[ROWS_STEP]], 2
; CHECK-NEXT:    [[TMP24:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP25:%.*]] = add i64 [[TMP24]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <4 x double>* [[C:%.*]] to double*
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr double, double* [[TMP26]], i64 [[TMP25]]
; CHECK-NEXT:    [[COL_CAST20:%.*]] = bitcast double* [[TMP27]] to <4 x double>*
; CHECK-NEXT:    [[TMP28:%.*]] = bitcast <4 x double>* [[COL_CAST20]] to double*
; CHECK-NEXT:    [[VEC_CAST21:%.*]] = bitcast double* [[TMP28]] to <2 x double>*
; CHECK-NEXT:    store volatile <2 x double> [[TMP17]], <2 x double>* [[VEC_CAST21]], align 8
; CHECK-NEXT:    [[VEC_GEP22:%.*]] = getelementptr double, double* [[TMP28]], i64 2
; CHECK-NEXT:    [[VEC_CAST23:%.*]] = bitcast double* [[VEC_GEP22]] to <2 x double>*
; CHECK-NEXT:    store volatile <2 x double> [[TMP23]], <2 x double>* [[VEC_CAST23]], align 8
; CHECK-NEXT:    br i1 [[ROWS_COND]], label [[ROWS_HEADER]], label [[COLS_LATCH]]
; CHECK:       cols.latch:
; CHECK-NEXT:    [[COLS_STEP]] = add i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[COLS_COND:%.*]] = icmp ne i64 [[COLS_STEP]], 2
; CHECK-NEXT:    br i1 [[COLS_COND]], label [[COLS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    ret void
;


entry:
  %a = load volatile <4 x double>, <4 x double>* %A, align 8
  %b = load volatile <4 x double>, <4 x double>* %B, align 8

  %c = call <4 x double> @llvm.matrix.multiply(<4 x double> %a, <4 x double> %b, i32 2, i32 2, i32 2)

  store volatile <4 x double> %c, <4 x double>* %C, align 8
  ret void
}


define void @multiply_load0_volatile(<4 x double>* noalias %A, <4 x double>* noalias %B, <4 x double>* noalias %C) {
; CHECK-LABEL: @multiply_load0_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[COLS_HEADER:%.*]]
; CHECK:       cols.header:
; CHECK-NEXT:    [[COLS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[COLS_STEP:%.*]], [[COLS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[COLS_BODY:%.*]]
; CHECK:       cols.body:
; CHECK-NEXT:    br label [[ROWS_HEADER:%.*]]
; CHECK:       rows.header:
; CHECK-NEXT:    [[ROWS_IV:%.*]] = phi i64 [ 0, [[COLS_BODY]] ], [ [[ROWS_STEP:%.*]], [[ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[ROWS_BODY:%.*]]
; CHECK:       rows.body:
; CHECK-NEXT:    br label [[INNER_HEADER:%.*]]
; CHECK:       inner.header:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[ROWS_BODY]] ], [ [[INNER_STEP:%.*]], [[INNER_LATCH:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP17:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP23:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    br label [[INNER_BODY:%.*]]
; CHECK:       inner.body:
; CHECK-NEXT:    [[TMP2:%.*]] = mul i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[TMP2]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x double>* [[A:%.*]] to double*
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr double, double* [[TMP4]], i64 [[TMP3]]
; CHECK-NEXT:    [[COL_CAST:%.*]] = bitcast double* [[TMP5]] to <4 x double>*
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <4 x double>* [[COL_CAST]] to double*
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP6]], i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = add i64 [[TMP7]], [[INNER_IV]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <4 x double>* [[B:%.*]] to double*
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr double, double* [[TMP9]], i64 [[TMP8]]
; CHECK-NEXT:    [[COL_CAST3:%.*]] = bitcast double* [[TMP10]] to <4 x double>*
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast <4 x double>* [[COL_CAST3]] to double*
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[TMP11]], i64 2
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK9:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <2 x double> undef, double [[TMP12]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK9]], <2 x double> [[SPLAT_SPLAT]], <2 x double> [[BLOCK]])
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <2 x double> undef, double [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT11]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK10]], <2 x double> [[SPLAT_SPLAT12]], <2 x double> [[TMP13]])
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <2 x double> [[TMP15]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP17]] = shufflevector <2 x double> [[TMP0]], <2 x double> [[TMP16]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK14:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT15:%.*]] = insertelement <2 x double> undef, double [[TMP18]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT15]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK14]], <2 x double> [[SPLAT_SPLAT16]], <2 x double> [[BLOCK13]])
; CHECK-NEXT:    [[BLOCK17:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT18:%.*]] = insertelement <2 x double> undef, double [[TMP20]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT18]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP21:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK17]], <2 x double> [[SPLAT_SPLAT19]], <2 x double> [[TMP19]])
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <2 x double> [[TMP21]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP23]] = shufflevector <2 x double> [[TMP1]], <2 x double> [[TMP22]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    br label [[INNER_LATCH]]
; CHECK:       inner.latch:
; CHECK-NEXT:    [[INNER_STEP]] = add i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[INNER_COND:%.*]] = icmp ne i64 [[INNER_STEP]], 2
; CHECK-NEXT:    br i1 [[INNER_COND]], label [[INNER_HEADER]], label [[ROWS_LATCH]], !llvm.loop !2
; CHECK:       rows.latch:
; CHECK-NEXT:    [[ROWS_STEP]] = add i64 [[ROWS_IV]], 2
; CHECK-NEXT:    [[ROWS_COND:%.*]] = icmp ne i64 [[ROWS_STEP]], 2
; CHECK-NEXT:    [[TMP24:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP25:%.*]] = add i64 [[TMP24]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <4 x double>* [[C:%.*]] to double*
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr double, double* [[TMP26]], i64 [[TMP25]]
; CHECK-NEXT:    [[COL_CAST20:%.*]] = bitcast double* [[TMP27]] to <4 x double>*
; CHECK-NEXT:    [[TMP28:%.*]] = bitcast <4 x double>* [[COL_CAST20]] to double*
; CHECK-NEXT:    [[VEC_CAST21:%.*]] = bitcast double* [[TMP28]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP17]], <2 x double>* [[VEC_CAST21]], align 8
; CHECK-NEXT:    [[VEC_GEP22:%.*]] = getelementptr double, double* [[TMP28]], i64 2
; CHECK-NEXT:    [[VEC_CAST23:%.*]] = bitcast double* [[VEC_GEP22]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP23]], <2 x double>* [[VEC_CAST23]], align 8
; CHECK-NEXT:    br i1 [[ROWS_COND]], label [[ROWS_HEADER]], label [[COLS_LATCH]]
; CHECK:       cols.latch:
; CHECK-NEXT:    [[COLS_STEP]] = add i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[COLS_COND:%.*]] = icmp ne i64 [[COLS_STEP]], 2
; CHECK-NEXT:    br i1 [[COLS_COND]], label [[COLS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    ret void
;


entry:
  %a = load volatile <4 x double>, <4 x double>* %A, align 8
  %b = load <4 x double>, <4 x double>* %B, align 8

  %c = call <4 x double> @llvm.matrix.multiply(<4 x double> %a, <4 x double> %b, i32 2, i32 2, i32 2)

  store <4 x double> %c, <4 x double>* %C, align 8
  ret void
}

define void @multiply_load1_volatile(<4 x double>* noalias %A, <4 x double>* noalias %B, <4 x double>* noalias %C) {
; CHECK-LABEL: @multiply_load1_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[COLS_HEADER:%.*]]
; CHECK:       cols.header:
; CHECK-NEXT:    [[COLS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[COLS_STEP:%.*]], [[COLS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[COLS_BODY:%.*]]
; CHECK:       cols.body:
; CHECK-NEXT:    br label [[ROWS_HEADER:%.*]]
; CHECK:       rows.header:
; CHECK-NEXT:    [[ROWS_IV:%.*]] = phi i64 [ 0, [[COLS_BODY]] ], [ [[ROWS_STEP:%.*]], [[ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[ROWS_BODY:%.*]]
; CHECK:       rows.body:
; CHECK-NEXT:    br label [[INNER_HEADER:%.*]]
; CHECK:       inner.header:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[ROWS_BODY]] ], [ [[INNER_STEP:%.*]], [[INNER_LATCH:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP17:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP23:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    br label [[INNER_BODY:%.*]]
; CHECK:       inner.body:
; CHECK-NEXT:    [[TMP2:%.*]] = mul i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[TMP2]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x double>* [[A:%.*]] to double*
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr double, double* [[TMP4]], i64 [[TMP3]]
; CHECK-NEXT:    [[COL_CAST:%.*]] = bitcast double* [[TMP5]] to <4 x double>*
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <4 x double>* [[COL_CAST]] to double*
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP6]], i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = add i64 [[TMP7]], [[INNER_IV]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <4 x double>* [[B:%.*]] to double*
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr double, double* [[TMP9]], i64 [[TMP8]]
; CHECK-NEXT:    [[COL_CAST3:%.*]] = bitcast double* [[TMP10]] to <4 x double>*
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast <4 x double>* [[COL_CAST3]] to double*
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[TMP11]], i64 2
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK9:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <2 x double> undef, double [[TMP12]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK9]], <2 x double> [[SPLAT_SPLAT]], <2 x double> [[BLOCK]])
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <2 x double> undef, double [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT11]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK10]], <2 x double> [[SPLAT_SPLAT12]], <2 x double> [[TMP13]])
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <2 x double> [[TMP15]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP17]] = shufflevector <2 x double> [[TMP0]], <2 x double> [[TMP16]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK14:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT15:%.*]] = insertelement <2 x double> undef, double [[TMP18]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT15]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK14]], <2 x double> [[SPLAT_SPLAT16]], <2 x double> [[BLOCK13]])
; CHECK-NEXT:    [[BLOCK17:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT18:%.*]] = insertelement <2 x double> undef, double [[TMP20]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT18]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP21:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK17]], <2 x double> [[SPLAT_SPLAT19]], <2 x double> [[TMP19]])
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <2 x double> [[TMP21]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP23]] = shufflevector <2 x double> [[TMP1]], <2 x double> [[TMP22]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    br label [[INNER_LATCH]]
; CHECK:       inner.latch:
; CHECK-NEXT:    [[INNER_STEP]] = add i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[INNER_COND:%.*]] = icmp ne i64 [[INNER_STEP]], 2
; CHECK-NEXT:    br i1 [[INNER_COND]], label [[INNER_HEADER]], label [[ROWS_LATCH]], !llvm.loop !3
; CHECK:       rows.latch:
; CHECK-NEXT:    [[ROWS_STEP]] = add i64 [[ROWS_IV]], 2
; CHECK-NEXT:    [[ROWS_COND:%.*]] = icmp ne i64 [[ROWS_STEP]], 2
; CHECK-NEXT:    [[TMP24:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP25:%.*]] = add i64 [[TMP24]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <4 x double>* [[C:%.*]] to double*
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr double, double* [[TMP26]], i64 [[TMP25]]
; CHECK-NEXT:    [[COL_CAST20:%.*]] = bitcast double* [[TMP27]] to <4 x double>*
; CHECK-NEXT:    [[TMP28:%.*]] = bitcast <4 x double>* [[COL_CAST20]] to double*
; CHECK-NEXT:    [[VEC_CAST21:%.*]] = bitcast double* [[TMP28]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP17]], <2 x double>* [[VEC_CAST21]], align 8
; CHECK-NEXT:    [[VEC_GEP22:%.*]] = getelementptr double, double* [[TMP28]], i64 2
; CHECK-NEXT:    [[VEC_CAST23:%.*]] = bitcast double* [[VEC_GEP22]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP23]], <2 x double>* [[VEC_CAST23]], align 8
; CHECK-NEXT:    br i1 [[ROWS_COND]], label [[ROWS_HEADER]], label [[COLS_LATCH]]
; CHECK:       cols.latch:
; CHECK-NEXT:    [[COLS_STEP]] = add i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[COLS_COND:%.*]] = icmp ne i64 [[COLS_STEP]], 2
; CHECK-NEXT:    br i1 [[COLS_COND]], label [[COLS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    ret void
;


entry:
  %a = load <4 x double>, <4 x double>* %A, align 8
  %b = load volatile <4 x double>, <4 x double>* %B, align 8

  %c = call <4 x double> @llvm.matrix.multiply(<4 x double> %a, <4 x double> %b, i32 2, i32 2, i32 2)

  store <4 x double> %c, <4 x double>* %C, align 8
  ret void
}

define void @multiply_store_volatile(<4 x double>* noalias %A, <4 x double>* noalias %B, <4 x double>* noalias %C) {
; CHECK-LABEL: @multiply_store_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[COLS_HEADER:%.*]]
; CHECK:       cols.header:
; CHECK-NEXT:    [[COLS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[COLS_STEP:%.*]], [[COLS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[COLS_BODY:%.*]]
; CHECK:       cols.body:
; CHECK-NEXT:    br label [[ROWS_HEADER:%.*]]
; CHECK:       rows.header:
; CHECK-NEXT:    [[ROWS_IV:%.*]] = phi i64 [ 0, [[COLS_BODY]] ], [ [[ROWS_STEP:%.*]], [[ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[ROWS_BODY:%.*]]
; CHECK:       rows.body:
; CHECK-NEXT:    br label [[INNER_HEADER:%.*]]
; CHECK:       inner.header:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[ROWS_BODY]] ], [ [[INNER_STEP:%.*]], [[INNER_LATCH:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP17:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ zeroinitializer, [[ROWS_BODY]] ], [ [[TMP23:%.*]], [[INNER_LATCH]] ]
; CHECK-NEXT:    br label [[INNER_BODY:%.*]]
; CHECK:       inner.body:
; CHECK-NEXT:    [[TMP2:%.*]] = mul i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[TMP2]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x double>* [[A:%.*]] to double*
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr double, double* [[TMP4]], i64 [[TMP3]]
; CHECK-NEXT:    [[COL_CAST:%.*]] = bitcast double* [[TMP5]] to <4 x double>*
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <4 x double>* [[COL_CAST]] to double*
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP6]], i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = add i64 [[TMP7]], [[INNER_IV]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <4 x double>* [[B:%.*]] to double*
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr double, double* [[TMP9]], i64 [[TMP8]]
; CHECK-NEXT:    [[COL_CAST3:%.*]] = bitcast double* [[TMP10]] to <4 x double>*
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast <4 x double>* [[COL_CAST3]] to double*
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[TMP11]], i64 2
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK9:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <2 x double> undef, double [[TMP12]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK9]], <2 x double> [[SPLAT_SPLAT]], <2 x double> [[BLOCK]])
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[COL_LOAD5]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <2 x double> undef, double [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT11]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK10]], <2 x double> [[SPLAT_SPLAT12]], <2 x double> [[TMP13]])
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <2 x double> [[TMP15]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP17]] = shufflevector <2 x double> [[TMP0]], <2 x double> [[TMP16]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[BLOCK14:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT15:%.*]] = insertelement <2 x double> undef, double [[TMP18]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT15]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK14]], <2 x double> [[SPLAT_SPLAT16]], <2 x double> [[BLOCK13]])
; CHECK-NEXT:    [[BLOCK17:%.*]] = shufflevector <2 x double> [[COL_LOAD2]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <2 x double> [[COL_LOAD8]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT18:%.*]] = insertelement <2 x double> undef, double [[TMP20]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <2 x double> [[SPLAT_SPLATINSERT18]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP21:%.*]] = call <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[BLOCK17]], <2 x double> [[SPLAT_SPLAT19]], <2 x double> [[TMP19]])
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <2 x double> [[TMP21]], <2 x double> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP23]] = shufflevector <2 x double> [[TMP1]], <2 x double> [[TMP22]], <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    br label [[INNER_LATCH]]
; CHECK:       inner.latch:
; CHECK-NEXT:    [[INNER_STEP]] = add i64 [[INNER_IV]], 2
; CHECK-NEXT:    [[INNER_COND:%.*]] = icmp ne i64 [[INNER_STEP]], 2
; CHECK-NEXT:    br i1 [[INNER_COND]], label [[INNER_HEADER]], label [[ROWS_LATCH]], !llvm.loop !4
; CHECK:       rows.latch:
; CHECK-NEXT:    [[ROWS_STEP]] = add i64 [[ROWS_IV]], 2
; CHECK-NEXT:    [[ROWS_COND:%.*]] = icmp ne i64 [[ROWS_STEP]], 2
; CHECK-NEXT:    [[TMP24:%.*]] = mul i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[TMP25:%.*]] = add i64 [[TMP24]], [[ROWS_IV]]
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <4 x double>* [[C:%.*]] to double*
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr double, double* [[TMP26]], i64 [[TMP25]]
; CHECK-NEXT:    [[COL_CAST20:%.*]] = bitcast double* [[TMP27]] to <4 x double>*
; CHECK-NEXT:    [[TMP28:%.*]] = bitcast <4 x double>* [[COL_CAST20]] to double*
; CHECK-NEXT:    [[VEC_CAST21:%.*]] = bitcast double* [[TMP28]] to <2 x double>*
; CHECK-NEXT:    store volatile <2 x double> [[TMP17]], <2 x double>* [[VEC_CAST21]], align 8
; CHECK-NEXT:    [[VEC_GEP22:%.*]] = getelementptr double, double* [[TMP28]], i64 2
; CHECK-NEXT:    [[VEC_CAST23:%.*]] = bitcast double* [[VEC_GEP22]] to <2 x double>*
; CHECK-NEXT:    store volatile <2 x double> [[TMP23]], <2 x double>* [[VEC_CAST23]], align 8
; CHECK-NEXT:    br i1 [[ROWS_COND]], label [[ROWS_HEADER]], label [[COLS_LATCH]]
; CHECK:       cols.latch:
; CHECK-NEXT:    [[COLS_STEP]] = add i64 [[COLS_IV]], 2
; CHECK-NEXT:    [[COLS_COND:%.*]] = icmp ne i64 [[COLS_STEP]], 2
; CHECK-NEXT:    br i1 [[COLS_COND]], label [[COLS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    ret void
;

entry:
  %a = load <4 x double>, <4 x double>* %A, align 8
  %b = load <4 x double>, <4 x double>* %B, align 8

  %c = call <4 x double> @llvm.matrix.multiply(<4 x double> %a, <4 x double> %b, i32 2, i32 2, i32 2)

  store volatile <4 x double> %c, <4 x double>* %C, align 8
  ret void
}

declare <4 x double> @llvm.matrix.multiply(<4 x double>, <4 x double>, i32, i32, i32)