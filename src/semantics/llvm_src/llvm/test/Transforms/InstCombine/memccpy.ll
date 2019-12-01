; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

@hello = private constant [11 x i8] c"helloworld\00", align 1

declare i8* @memccpy(i8*, i8*, i32, i64)

define i8* @memccpy_to_memcpy(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 12)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 12) ; 114 is 'r'
  ret i8* %call
}

define i8* @memccpy_to_memcpy2(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy2(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 5)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 5)
  ret i8* %call
}

define void @memccpy_to_memcpy3(i8* %dst) {
; CHECK-LABEL: @memccpy_to_memcpy3(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 5)
; CHECK-NEXT:    ret void
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 5)
  ret void
}

define i8* @memccpy_to_null(i8* %dst, i8* %src, i32 %c) {
; CHECK-LABEL: @memccpy_to_null(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* [[SRC:%.*]], i32 [[C:%.*]], i64 0)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* %src, i32 %c, i64 0)
  ret i8* %call
}

define i8* @memccpy_to_null2(i8* %dst) {
; CHECK-LABEL: @memccpy_to_null2(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 5)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 115, i64 5) ; 115 is 's'
  ret i8* %call
}

; Negative tests
define i8* @unknown_src(i8* %dst, i8* %src) {
; CHECK-LABEL: @unknown_src(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* [[SRC:%.*]], i32 114, i64 12)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* %src, i32 114, i64 12)
  ret i8* %call
}

define i8* @unknown_stop_char(i8* %dst, i32 %c) {
; CHECK-LABEL: @unknown_stop_char(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 [[C:%.*]], i64 12)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 %c, i64 12)
  ret i8* %call
}

define i8* @unknown_size_n(i8* %dst, i64 %n) {
; CHECK-LABEL: @unknown_size_n(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memccpy(i8* [[DST:%.*]], i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @memccpy(i8* %dst, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @hello, i64 0, i64 0), i32 114, i64 %n)
  ret i8* %call
}
