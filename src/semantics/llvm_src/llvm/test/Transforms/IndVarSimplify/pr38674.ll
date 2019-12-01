; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars < %s | FileCheck %s

; Check that we don't reuse %zext instead of %inc11 for LCSSA Phi node. Case
; with constants SCEV.

define i32 @test_01() {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    br label [[FOR_COND4_PREHEADER:%.*]]
; CHECK:       for.cond4.preheader:
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i16 1 to i32
; CHECK-NEXT:    br label [[FOR_BODY6:%.*]]
; CHECK:       for.cond4:
; CHECK-NEXT:    br i1 true, label [[FOR_BODY6]], label [[FOR_END:%.*]]
; CHECK:       for.body6:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[FOR_COND4_PREHEADER]] ], [ [[INC:%.*]], [[FOR_COND4:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i32 [[IV]], [[ZEXT]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[TMP0]], label [[RETURN_LOOPEXIT:%.*]], label [[FOR_COND4]]
; CHECK:       for.end:
; CHECK-NEXT:    br i1 false, label [[FOR_COND4_PREHEADER]], label [[FOR_END9:%.*]]
; CHECK:       for.end9:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_PREHEADER]], label [[RETURN_LOOPEXIT3:%.*]]
; CHECK:       return.loopexit:
; CHECK-NEXT:    unreachable
; CHECK:       return.loopexit3:
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 1
;
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.end9, %entry
  br label %for.cond4.preheader

for.cond4.preheader:                              ; preds = %for.end, %for.cond1.preheader
  %zext = zext i16 1 to i32
  br label %for.body6

for.cond4:                                        ; preds = %for.body6
  %cmp5 = icmp ult i32 %inc, 2
  br i1 %cmp5, label %for.body6, label %for.end

for.body6:                                        ; preds = %for.cond4, %for.cond4.preheader
  %iv = phi i32 [ 0, %for.cond4.preheader ], [ %inc, %for.cond4 ]
  %0 = icmp eq i32 %iv, %zext
  %inc = add nuw nsw i32 %iv, 1
  br i1 %0, label %return.loopexit, label %for.cond4

for.end:                                          ; preds = %for.cond4
  br i1 false, label %for.cond4.preheader, label %for.end9

for.end9:                                         ; preds = %for.end
  %inc11 = add nuw nsw i32 0, 1
  br i1 false, label %for.cond1.preheader, label %return.loopexit3

return.loopexit:                                  ; preds = %for.body6
  unreachable

return.loopexit3:                                 ; preds = %for.end9
  %inc11.lcssa = phi i32 [ %inc11, %for.end9 ]
  br label %return

return:                                           ; preds = %return.loopexit3
  ret i32 %inc11.lcssa
}

; Same as test_01, but the instructions with the same SCEV have a non-constant
; SCEV.
define i32 @test_02(i32 %x) {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    br label [[FOR_COND4_PREHEADER:%.*]]
; CHECK:       for.cond4.preheader:
; CHECK-NEXT:    [[ZEXT:%.*]] = mul i32 [[X:%.*]], 1
; CHECK-NEXT:    br label [[FOR_BODY6:%.*]]
; CHECK:       for.cond4:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp ult i32 [[INC:%.*]], 2
; CHECK-NEXT:    br i1 [[CMP5]], label [[FOR_BODY6]], label [[FOR_END:%.*]]
; CHECK:       for.body6:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[FOR_COND4_PREHEADER]] ], [ [[INC]], [[FOR_COND4:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i32 [[IV]], [[ZEXT]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[TMP0]], label [[RETURN_LOOPEXIT:%.*]], label [[FOR_COND4]]
; CHECK:       for.end:
; CHECK-NEXT:    br i1 false, label [[FOR_COND4_PREHEADER]], label [[FOR_END9:%.*]]
; CHECK:       for.end9:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_PREHEADER]], label [[RETURN_LOOPEXIT3:%.*]]
; CHECK:       return.loopexit:
; CHECK-NEXT:    unreachable
; CHECK:       return.loopexit3:
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.end9, %entry
  br label %for.cond4.preheader

for.cond4.preheader:                              ; preds = %for.end, %for.cond1.preheader
  %zext = mul i32 %x, 1
  br label %for.body6

for.cond4:                                        ; preds = %for.body6
  %cmp5 = icmp ult i32 %inc, 2
  br i1 %cmp5, label %for.body6, label %for.end

for.body6:                                        ; preds = %for.cond4, %for.cond4.preheader
  %iv = phi i32 [ 0, %for.cond4.preheader ], [ %inc, %for.cond4 ]
  %0 = icmp eq i32 %iv, %zext
  %inc = add nuw nsw i32 %iv, 1
  br i1 %0, label %return.loopexit, label %for.cond4

for.end:                                          ; preds = %for.cond4
  br i1 false, label %for.cond4.preheader, label %for.end9

for.end9:                                         ; preds = %for.end
  %inc11 = add nuw nsw i32 0, %x
  br i1 false, label %for.cond1.preheader, label %return.loopexit3

return.loopexit:                                  ; preds = %for.body6
  unreachable

return.loopexit3:                                 ; preds = %for.end9
  %inc11.lcssa = phi i32 [ %inc11, %for.end9 ]
  br label %return

return:                                           ; preds = %return.loopexit3
  ret i32 %inc11.lcssa
}
