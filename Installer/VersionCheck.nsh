!macro VersionCheckV5 Ver1 Ver2 OutVar
 Push "${Ver1}"
 Push "${Ver2}"
  Call VersionCheckV5
 Pop "${OutVar}"
!macroend
!define VersionCheckV5 "!insertmacro VersionCheckV5"

Function VersionCheckV5
 Exch $R0 ; second version number
 Exch
 Exch $R1 ; first version number
 Push $R2
 Push $R3
 Push $R4
 Push $R5 ; second version part
 Push $R6 ; first version part

  StrCpy $R1 $R1.
  StrCpy $R0 $R0.

 Next: StrCmp $R0$R1 "" 0 +3
  StrCpy $R0 0
  Goto Done

  StrCmp $R0 "" 0 +2
   StrCpy $R0 0.
  StrCmp $R1 "" 0 +2
   StrCpy $R1 0.

 StrCpy $R2 0
  IntOp $R2 $R2 + 1
  StrCpy $R4 $R1 1 $R2
  StrCmp $R4 . 0 -2
    StrCpy $R6 $R1 $R2
    IntOp $R2 $R2 + 1
    StrCpy $R1 $R1 "" $R2

 StrCpy $R2 0
  IntOp $R2 $R2 + 1
  StrCpy $R4 $R0 1 $R2
  StrCmp $R4 . 0 -2
    StrCpy $R5 $R0 $R2
    IntOp $R2 $R2 + 1
    StrCpy $R0 $R0 "" $R2

 IntCmp $R5 0 Compare
 IntCmp $R6 0 Compare

 StrCpy $R3 0
  StrCpy $R4 $R6 1 $R3
  IntOp $R3 $R3 + 1
  StrCmp $R4 0 -2

 StrCpy $R2 0
  StrCpy $R4 $R5 1 $R2
  IntOp $R2 $R2 + 1
  StrCmp $R4 0 -2

 IntCmp $R3 $R2 0 +2 +4
 Compare: IntCmp 1$R5 1$R6 Next 0 +3

  StrCpy $R0 1
  Goto Done
  StrCpy $R0 2

 Done:
 Pop $R6
 Pop $R5
 Pop $R4
 Pop $R3
 Pop $R2
 Pop $R1
 Exch $R0 ; output
FunctionEnd
