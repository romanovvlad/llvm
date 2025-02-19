; RUN: llvm-as < %s -o %t.bc
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r -emit-opaque-pointers %t.spv -o - | llvm-dis -o %t.ll
; RUN: llc -mtriple=x86_64-apple-darwin -filetype=obj < %t.ll \
; RUN:     | llvm-dwarfdump -v -debug-info - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-V4
; RUN: llc -mtriple=x86_64-apple-darwin -filetype=obj -dwarf-version=3 < %t.ll \
; RUN:     | llvm-dwarfdump -v -debug-info - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-V3

; RUN: llvm-spirv %t.bc -o %t.spv --spirv-debug-info-version=nonsemantic-shader-100
; RUN: llvm-spirv -r -emit-opaque-pointers %t.spv -o - | llvm-dis -o %t.ll
; RUN: llc -mtriple=x86_64-apple-darwin -filetype=obj < %t.ll \
; RUN:     | llvm-dwarfdump -v -debug-info - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-V4
; RUN: llc -mtriple=x86_64-apple-darwin -filetype=obj -dwarf-version=3 < %t.ll \
; RUN:     | llvm-dwarfdump -v -debug-info - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-V3

; RUN: llvm-spirv %t.bc -o %t.spv --spirv-debug-info-version=nonsemantic-shader-200
; RUN: llvm-spirv -r -emit-opaque-pointers %t.spv -o - | llvm-dis -o %t.ll
; RUN: llc -mtriple=x86_64-apple-darwin -filetype=obj < %t.ll \
; RUN:     | llvm-dwarfdump -v -debug-info - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-V4
; RUN: llc -mtriple=x86_64-apple-darwin -filetype=obj -dwarf-version=3 < %t.ll \
; RUN:     | llvm-dwarfdump -v -debug-info - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-V3

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64"
target triple = "spir64-unknown-unknown"


; Check that we use DW_AT_low_pc and that it has the right encoding depending
; on dwarf version.

; CHECK: DW_TAG_compile_unit [1]
; CHECK-NOT: DW_TAG
; CHECK: DW_AT_low_pc [DW_FORM_addr]       (0x0000000000000000)
; CHECK-NOT: DW_TAG
; CHECK-V3: DW_AT_high_pc [DW_FORM_addr]
; CHECK-V4: DW_AT_high_pc [DW_FORM_data4]
; CHECK: DW_TAG_subprogram [2]
; CHECK-NOT: DW_TAG
; CHECK: DW_AT_low_pc [DW_FORM_addr]
; CHECK-NOT: DW_TAG
; CHECK-V3: DW_AT_high_pc [DW_FORM_addr]
; CHECK-V4: DW_AT_high_pc [DW_FORM_data4]

; Function Attrs: nounwind uwtable
define void @z() #0 !dbg !4 {
entry:
  ret void, !dbg !11
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.5.0 (trunk 204164) (llvm/trunk 204183)", isOptimized: false, emissionKind: FullDebug, file: !1, enums: !2, retainedTypes: !2, globals: !2, imports: !2)
!1 = !DIFile(filename: "z.c", directory: "/usr/local/google/home/echristo")
!2 = !{}
!4 = distinct !DISubprogram(name: "z", line: 1, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 1, file: !1, scope: !5, type: !6, retainedNodes: !2)
!5 = !DIFile(filename: "z.c", directory: "/usr/local/google/home/echristo")
!6 = !DISubroutineType(types: !7)
!7 = !{null}
!8 = !{i32 2, !"Dwarf Version", i32 4}
!9 = !{i32 1, !"Debug Info Version", i32 3}
!10 = !{!"clang version 3.5.0 (trunk 204164) (llvm/trunk 204183)"}
!11 = !DILocation(line: 1, scope: !4)
