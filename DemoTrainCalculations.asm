
proc    NewCalcUron
       mov eax, [Right_Player.x]
       mov ebx, [Left_Player.x]
       sub ebx, eax
       cmp ebx, 150
       ja  Final
       mov eax, [Right_Player.Health]
       mov ebx, [Left_Player.Health]
   .Jump:
       cmp [Right_Player.Action_State],1
       jne  .Down
       cmp [Left_Player.Action_State],8
       je   Exit
       cmp [Left_Player.Action_State],1
       jne  @f
       sub [Left_Player.Health],3
       sub [Right_Player.Health],3
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],2
       jne  @f
       sub [Left_Player.Health],3
       sub [Right_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],4
       jne  @f
       sub [Left_Player.Health],3
       sub [Right_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],3
       jne  @f
       sub [Left_Player.Health],3
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],5
       jne  @f
       sub [Left_Player.Health],3
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],6
       jne  .Down
       sub [Left_Player.Health],1

   .Down:
       cmp [Right_Player.Action_State],8
       jne  .Huk
       cmp [Left_Player.Action_State],1
       je   Exit
       cmp [Left_Player.Action_State],8
       jne  @f
       sub [Left_Player.Health],1
       sub [Right_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],2
       jne  @f
       sub [Left_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],4
       jne  @f
       sub [Left_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],3
       jne  @f
       sub [Left_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],5
       jne  @f
       sub [Left_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],6
       jne  .Huk
       sub [Left_Player.Health],1

   .Huk:
       cmp [Right_Player.Action_State],2
       jne  .Right
       cmp [Left_Player.Action_State],8
       jne  @f
       sub [Left_Player.Health],3
       sub [Right_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],1
       jne  @f
       sub [Left_Player.Health],3
       sub [Right_Player.Health],3
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],2
       jne  @f
       sub [Left_Player.Health],3
       sub [Right_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],4
       jne  @f
       sub [Left_Player.Health],1
       sub [Right_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],3
       jne  @f
       sub [Left_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],5
       jne  @f
       sub [Left_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],6
       jne  .Right
       sub [Left_Player.Health],1

   .Right:
       cmp [Right_Player.Action_State],4
       jne  .Static
       cmp [Left_Player.Action_State],8
       jne  @f
       sub [Right_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],1
       jne  @f
       sub [Left_Player.Health],1
       sub [Right_Player.Health],3
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],2
       jne  @f
       sub [Left_Player.Health],1
       sub [Right_Player.Health],1
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],4
       jne  @f
       sub [Left_Player.Health],1
       sub [Right_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],3
       jne  @f
       sub [Left_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],5
       jne  @f
       sub [Left_Player.Health],2
       jmp  Exit
   @@:
       cmp [Left_Player.Action_State],6
       jne  .Static
       sub [Left_Player.Health],1

  .Static:
       cmp [Left_Player.Action_State],3
       je  Exit
       cmp [Left_Player.Action_State],5
       je  Exit
       cmp [Left_Player.Action_State],6
       je  Exit
       sub [Right_Player.Health],2
  Exit:
     sub eax,[Right_Player.Health]
     add [Right_Player.Delta_Health],eax
     sub ebx,[Left_Player.Health]
     add [Left_Player.Delta_Health],ebx
  Final:
     ret
endp


proc NewNewCalcUron
        mov eax, [Right_Player.x]
        mov ebx, [Left_Player.x]
        sub ebx, eax
        cmp ebx, 150
        ja  Exit

        mov eax,[Right_Player.Action_State]
        cmp eax,3
        je NotUronR
        cmp eax,5
        je NotUronR
        cmp eax,6
        je NotUronR
        jmp Left
    NotUronR:
        mov eax, 9
    Left:
        mov ebx,[Left_Player.Action_State]
        cmp ebx,3
        je NotUronL
        cmp ebx,5
        je NotUronL
        cmp ebx,6
        je NotUronL
        jmp Uron
    NotUronL:
        mov ebx, 9

    Uron:
        add eax,ebx
        cmp eax, 9
        je  Exit

        sub eax,ebx

        mov ecx, 9
        mov edx, 9
        sub ecx, eax
        cmp ecx,8
        jne @f
        sub ecx,5
        jmp .Next
      @@:
        cmp ecx,7
        jne @f
        sub ecx,4
        jmp .Next
      @@:
        cmp ecx,5
        jne  .Next
        sub  ecx,3
      .Next:
        sub [Left_Player.Health],ecx
        sub edx,ebx

        cmp edx,8
        jne @f
        sub edx,5
        jmp .Next1
      @@:
        cmp edx,7
        jne @f
        sub edx,4
        jmp .Next1
      @@:
        cmp edx,5
        jne  .Next1
        sub  edx,3
      .Next1:
        sub [Right_Player.Health],edx

Exit:
        ret
endp



proc  ShowHealthState
        stdcall TextDraw,[hdcBack],160,60,_string,8,0FFh
        mov eax, [rc.right]
        sub eax, 270
        stdcall TextDraw,[hdcBack],eax,60,_string1,14,0FFh
       invoke  SelectObject,[hdcBack], [hbrRed]
       mov     ebx,[Right_Player.Health]
       add     ebx,50
       invoke  Rectangle,[hdcBack], 50, 100, ebx,130
       invoke  SelectObject,[hdcBack], [hbrBlue]
       mov     eax, [rc.right]
       sub     eax, 50
       mov     ebx,eax
       sub     ebx,[Left_Player.Health]
       invoke  Rectangle,[hdcBack], ebx, 100,eax, 130

      ret
endp

