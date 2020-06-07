proc  TextDraw hdc,left,top,string,strlen,color  ;Вывод текста
    ;locals
       ; newFont dd ?
        ;oldFont dd ?
   ; endl
    invoke SetBkColor,[hdc],0h
    invoke SetTextColor,[hdc],[color]
    invoke TextOut,[hdc],[left],[top],[string],[strlen]
    ;invoke SelectObject,[hdc],[oldFont]
    ;invoke DeleteObject,[oldFont]
    ;invoke DeleteObject,[newFont]
        ret
endp

proc StopWalking,Player
      mov ecx,[Player]
      mov     [ecx+PLAYER.Walk_Stopped],1
      mov     [ecx+PLAYER.Action_State],3
      stdcall InitBitmap,[Player]
     ret
endp

proc AnimateBitmap seg_w,seg_h,x0,y0,iterat,hbmImage,color,Player  ;Анимация битмапа взависимости от числа замены кадров
      invoke  GetObjectA,[hbmImage],sizeof.BITMAP, bm
      mov ecx,[Player]
      inc [ecx+PLAYER.Cadr_Change]
      mov ebx,[iterat]
      cmp  [ecx+PLAYER.Cadr_Change],ebx
      jne  @f
      stdcall Dinamics,[seg_w],[seg_h],[bm.bmWidth],[bm.bmHeight],[Player]
      mov  [ecx+PLAYER.Cadr_Change],0
      @@:
        invoke SelectObject,[hdcMem], [hbmImage]
        mov ecx,[Player]
        invoke GdiTransparentBlt,[hdcBack],[x0],[y0],[seg_w],[seg_h],[hdcMem],[ecx+PLAYER.Bitmap_begX],[ecx+PLAYER.Bitmap_begY],[seg_w],[seg_h],[color]
     ret
endp

proc Dinamics w,h,full_w,full_h,Player        ;Нарезка битмапа на необходимые по текущему времени части
      mov ebx,[w]
      mov ecx,[Player]
      add [ecx+PLAYER.Bitmap_begX],ebx
      sub [full_w],50
      mov ebx,[full_w]
      cmp [ecx+PLAYER.Bitmap_begX],ebx
      jb .Stop
      mov [ecx+PLAYER.Bitmap_begX],0
      mov ebx,[h]
      add [ecx+PLAYER.Bitmap_begY],ebx
      sub [full_h],30
      mov ebx,[full_h]
      cmp [ecx+PLAYER.Bitmap_begY],ebx
      jb .Stop
      mov [ecx+PLAYER.Bitmap_begY],0
     .Stop:
        ret
endp

proc  InitBitmap Player                                       ;Сброс кадров битмапа
      mov ecx,[Player]
      mov [ecx+PLAYER.Bitmap_begX],0
      mov [ecx+PLAYER.Bitmap_begY],0
      mov [ecx+PLAYER.Action_Time_End],0
      ret
endp

proc  DetectHitKey  Animation_Priority,Animation_Interval,Player      ;Инициаизация данных по клавишу удара
       mov ebx,[time]
       mov ecx,[Player]
       cmp ebx,[ecx+PLAYER.Action_Time_End]
       jb     WindowProc.defwndproc
       je     @f
       stdcall InitBitmap,[Player]
       mov     ebx,[Animation_Priority]
       mov     [ecx+PLAYER.Action_State],ebx
       mov     eax,[time]
       add     eax,[Animation_Interval]
       mov     [ecx+PLAYER.Action_Time_End],eax
       jmp     WindowProc.finish
       @@:
       mov     [ecx+PLAYER.Action_Time_End],0
       mov     [ecx+PLAYER.Action_State],3
       jmp     WindowProc.finish
      ret
endp

proc DetectMoveKey   Animation_Priority,Animation_Interval,Player     ;Инициализация данных под клавишу движения
       mov ecx,[Player]
       mov ebx,[time]
       cmp ebx,[ecx+PLAYER.Action_Time_End]
       jb     WindowProc.defwndproc
       stdcall InitBitmap,[Player]
       mov     ebx,[Animation_Priority]
       mov     [ecx+PLAYER.Action_State],ebx
       mov     eax,[time]
       add     eax,[Animation_Interval]
       mov     [ecx+PLAYER.Action_Time_End],eax
       mov     [ecx+PLAYER.Walk_Stopped],3
       jmp     WindowProc.finish
      ret
endp

proc  CheckForZero Player                                     ;Проверка окончания анимации
       mov ecx,[Player]
       mov ebx,[time]
       cmp ebx,[ecx+PLAYER.Action_Time_End]
       jbe  .Next
       mov     [ecx+PLAYER.Action_State],3
       mov     [ecx+PLAYER.Cadr_Change],0
       mov     [ecx+PLAYER.Action_Time_End],0
       stdcall InitBitmap,[Player]
    .Next:
      ret
endp


proc  DrawBackGround Bitmap_Name,f                   ;Вывод фона
       cmp [f],0
       jne @f
           invoke CreatePatternBrush,[Bitmap_Name]
           mov [hbr],eax
           jmp .Next
       @@:
           invoke CreateSolidBrush,0h
           mov [hbr],eax
       .Next:
           invoke FillRect,[hdcBack],rc,[hbr]
           invoke DeleteObject,[hbr]
      ret
endp

proc ChooseBitmap
      .PaintRight:
        cmp [Right_Player.Action_State],4
        jne  @f
        stdcall CheckForZero,Right_Player
        mov ebx,[time]
        cmp ebx,[Right_Player.Action_Time_End]
        ja @f
        ;stdcall TextDraw,[hdc],300,100,_string,13
        mov eax, [rc.bottom]
        sub eax, 530
        stdcall AnimateBitmap,222,499,[Right_Player.x],eax,1,[hbmImage15],0h,Right_Player
        jmp  .PaintLeft
      @@:
        cmp [Right_Player.Action_State],2
        jne  @f
        stdcall CheckForZero,Right_Player
        mov ebx,[time]
        cmp ebx,[Right_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 530
        stdcall AnimateBitmap,295,499,[Right_Player.x],eax,1,[hbmImage16],0h,Right_Player
        jmp  .PaintLeft
     @@:
        cmp [Right_Player.Action_State],8
        jne  @f
        stdcall CheckForZero,Right_Player
        mov ebx,[time]
        cmp ebx,[Right_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 630
        stdcall AnimateBitmap,355,599,[Right_Player.x],eax,1,[hbmImage20],0h,Right_Player
        mov    ebx,[Right_Player.x]
        add    ebx,200
        cmp    [Left_Player.x],ebx
        jbe    .PaintLeft
        add   [Right_Player.x],10
        jmp   .PaintLeft
     @@:
        cmp [Right_Player.Action_State],1
        jne  @f
        stdcall CheckForZero,Right_Player
        mov ebx,[time]
        cmp ebx,[Right_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 630
        stdcall AnimateBitmap,262,599,[Right_Player.x],eax,1,[hbmImage21],0h,Right_Player
        mov    ebx,[Right_Player.x]
        add    ebx,150
        cmp    [Left_Player.x],ebx
        jbe    .PaintLeft
        add   [Right_Player.x],10
        jmp   .PaintLeft
     @@:
        cmp [Right_Player.Action_State],6
        jne  @f
        cmp [Right_Player.Walk_Stopped],1
        je .PaintLeft
        mov eax, [rc.bottom]
        sub eax, 630
        stdcall AnimateBitmap,355,599,[Right_Player.x],eax,1,[hbmImage18],0h,Right_Player
        mov    ebx,[Right_Player.x]
        add    ebx,200
        cmp    [Left_Player.x],ebx
        jbe    .PaintLeft
        add   [Right_Player.x],20
        jmp   .PaintLeft
      @@:
        cmp [Right_Player.Action_State],5
        jne  @f
        cmp [Right_Player.Walk_Stopped],1
        je .PaintLeft
        mov eax, [rc.bottom]
        sub eax, 630
        stdcall AnimateBitmap,355,599,[Right_Player.x],eax,1,[hbmImage10],0h,Right_Player
       ; mov    ebx,[Right_Player.x]
        ;add    ebx,200
        ;cmp    [Left_Player.x],ebx
        ;mov    ebx,0
        cmp    [Right_Player.x],30
        jbe    .PaintLeft
        sub   [Right_Player.x],20
        jmp   .PaintLeft
      @@:
        cmp [Right_Player.Action_State],3
        jne .PaintLeft
        mov eax, [rc.bottom]
        sub eax, 530
        stdcall AnimateBitmap,222,499,[Right_Player.x],eax,1,[hbmImage17],0h,Right_Player
        jmp  .PaintLeft


    .PaintLeft:
        cmp [Left_Player.Action_State],4
        jne  @f
        stdcall CheckForZero,Left_Player
        mov ebx,[time]
        cmp ebx,[Left_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 430
        stdcall AnimateBitmap,308,399,[Left_Player.x],eax,1,[hbmImage13],0h,Left_Player
        jmp  .Next
      @@:
        cmp [Left_Player.Action_State],2
        jne  @f
        stdcall CheckForZero,Left_Player
        mov ebx,[time]
        cmp ebx,[Left_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 430
        stdcall AnimateBitmap,283,399,[Left_Player.x],eax,1,[hbmImage1],0h,Left_Player
        jmp  .Next
      @@:
        cmp [Left_Player.Action_State],8
        jne  @f
        stdcall CheckForZero,Left_Player
        mov ebx,[time]
        cmp ebx,[Left_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 430
        stdcall AnimateBitmap,316,399,[Left_Player.x],eax,1,[hbmImage2],0h,Left_Player
        mov    ebx,[Right_Player.x]
        add    ebx,200
        cmp    [Left_Player.x],ebx
        jbe    .Next
        sub   [Left_Player.x],10
        jmp   .Next
      @@:
        cmp [Left_Player.Action_State],1
        jne  @f
        stdcall CheckForZero,Left_Player
        mov ebx,[time]
        cmp ebx,[Left_Player.Action_Time_End]
        ja @f
        mov eax, [rc.bottom]
        sub eax, 630
        stdcall AnimateBitmap,300,599,[Left_Player.x],eax,1,[hbmImage26],0h,Left_Player
        mov    ebx,[Right_Player.x]
        add    ebx,150
        cmp    [Left_Player.x],ebx
        jbe    .Next
        sub   [Left_Player.x],10
        jmp   .Next
      @@:
        cmp [Left_Player.Action_State],6
        jne  @f
        cmp [Left_Player.Walk_Stopped],1
        je  .Next
        mov eax, [rc.bottom]
        sub eax, 430
        stdcall AnimateBitmap,236,399,[Left_Player.x],eax,1,[hbmImage28],0h,Left_Player
        mov    ebx,[Left_Player.x]
        add    ebx,200
        cmp    ebx,1350
        jae     .Next
        add   [Left_Player.x],20
        jmp   .Next
      @@:
        cmp [Left_Player.Action_State],5
        jne  @f
        cmp [Left_Player.Walk_Stopped],1
        je  .Next
        mov eax, [rc.bottom]
        sub eax, 430
        stdcall AnimateBitmap,236,399,[Left_Player.x],eax,1,[hbmImage27],0h,Left_Player
        mov    ebx,[Right_Player.x]
        add    ebx,100
        cmp    [Left_Player.x],ebx
        jbe     .Next
        sub   [Left_Player.x],20
        jmp   .Next
     @@:
        cmp [Left_Player.Action_State],3
        jne .Next
        mov eax, [rc.bottom]
        sub eax, 430
        stdcall AnimateBitmap,237,399,[Left_Player.x],eax,1,[hbmImage12],0h,Left_Player
    .Next:
     ret
endp

proc  DetectCursor
        cmp    [Mouse_Enabled],1
        jne    .End
        cmp    [Game_State],0
        jne    .Pause
        invoke GetCursorPos,pt
        invoke PtInRect,rcbtBeer,[pt.x],[pt.y]
        test eax,eax
        jz @f
        invoke  mciSendString,_cmd_open,0,0,0
        invoke  mciSendString,_cmd_eject,0,0,0
        invoke  mciSendString,_cmd_close,0,0,0
        @@:
        invoke PtInRect,rcbtStart,[pt.x],[pt.y]
        test   eax,eax
        jz    @f
        mov    eax,[time]
        mov    [Init_time],eax
        mov    [Fight_time],eax
        add    [Init_time],80
        add    [Fight_time],100
        mov   [Game_State],1
        mov   [Mouse_Enabled],0
        mov [Is_Keys_Enabled],0
        mov [Death_Duration],1
        mov [Death_time],0
        mov [tolpaduration],256
        stdcall InitPlayer,Left_Player
        mov ebx, [rc.bottom]
        sub ebx, 400
        mov [Right_Player.y], ebx
        stdcall InitPlayer,Right_Player
        mov eax, [rc.right]
        sub eax, 250
        mov [Left_Player.x],eax
        mov [Left_Player.y], ebx
        invoke PlaySound,SND_GONG,0,SND_ASYNC
      @@:
        invoke PtInRect,rcbtExit,[pt.x],[pt.y]
        test   eax,eax
        jz    .End
        jmp    WindowProc.wmdestroy
     .Pause:
        ;cmp    [Game_State],2
        ;jne    .End
        invoke GetCursorPos,pt
        invoke PtInRect,rcbtStart,[pt.x],[pt.y]
        test   eax,eax
        jz    @f
        mov   [Game_State],1
        mov   [Mouse_Enabled],0
        mov   [Is_Keys_Enabled],1
      @@:
        invoke PtInRect,rcbtExit,[pt.x],[pt.y]
        test   eax,eax
        jz    .End
        jmp     WindowProc.wmdestroy
     .End:
        jmp     WindowProc.finish
      ret
endp

proc  InitPlayer Player
      mov ecx,[Player]
      mov [ecx+PLAYER.Action_Time_End], 0
      mov [ecx+PLAYER.Action_State],3
      mov [ecx+PLAYER.Walk_Stopped],1
      mov [ecx+PLAYER.Cadr_Change],0
      mov [ecx+PLAYER.x],0
      mov [ecx+PLAYER.y],0
      mov [ecx+PLAYER.Bitmap_begX],0
      mov [ecx+PLAYER.Bitmap_begY],0
      mov [ecx+PLAYER.Health],300
      mov [ecx+PLAYER.Blood_Time],0
      mov [ecx+PLAYER.Kicks_for_Fall],0
      mov [ecx+PLAYER.Delta_Health],0
      mov [tolpaduration],120
      ret
endp




