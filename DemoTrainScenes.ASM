proc DrawScene
        cmp  [Game_State],0
        jne  @f
        invoke PlaySound,SND_START,0,SND_ASYNC or SND_NOSTOP
        stdcall WelcomeWindow,[hbmbtStart],[hbmbtExit],[hbmCurrBack]
        jmp  .Next
      @@:
        cmp  [Game_State],2
        jne  @f
        stdcall WelcomeWindow,[hbmbtStart],[hbmbtExit],[hbmCurrBack]
        jmp  .Next
      @@:
        mov [tolpaduration],256
        stdcall GamePlayDraw
      .Next:
        ret
endp

proc DrawIntroVs
        mov eax,[time]
        cmp eax,[Init_time]
        jne @f
        invoke PlaySound,SND_FIGHT,0,SND_ASYNC
      @@:
        stdcall DrawBackGround,[hbmInitBack],1
        invoke SelectObject,[hdcMem], [hbmImage29]
        invoke GdiTransparentBlt,[hdcBack],100,50,291,650,[hdcMem],0,0,291,650,0h
        stdcall TextDraw,[hdcBack],180,30,_string,8,0FFh
        stdcall TextDraw,[hdcBack],150,750,_string3,20,0FFFFFFh
        invoke SelectObject,[hdcMem], [hbmImage30]
        mov eax, [rc.right]
        shr eax, 1
        sub eax, 175
        invoke GdiTransparentBlt,[hdcBack],eax,270,350,304,[hdcMem],0,0,346,304,0h
        invoke SelectObject,[hdcMem], [hbmImage31]
        mov eax, [rc.right]
        sub eax, 370
        invoke GdiTransparentBlt,[hdcBack],eax,50,270,650,[hdcMem],0,0,270,650,0h
        mov eax, [rc.right]
        sub eax, 270
        stdcall TextDraw,[hdcBack],eax,30,_string1,14,0FFh
        mov eax, [rc.right]
        sub eax, 270
        stdcall TextDraw,[hdcBack],eax,750,_string2,14,0FFFFFFh
        ret
endp

proc  GamePlayDraw
        mov  eax,[time]
        cmp eax,[Init_time]
        ja @f
        stdcall DrawIntroVs
        jmp  .Next
     @@:
        stdcall DrawBackGround,[hbmCurrBack],0
        mov  eax,[time]
        cmp eax,[Fight_time]
        ja  @f
        invoke SelectObject,[hdcMem], [hbmFight]
        invoke GdiTransparentBlt,[hdcBack],0,0,[rc.right],843,[hdcMem],0,0,1500,843,0h
     @@:
        mov  eax,[time]
        cmp eax,[Fight_time]
        jne  @f
        mov [Is_Keys_Enabled],1
     @@:
        cmp  [Left_Player.Health],0
        jle   .Death
        cmp  [Right_Player.Health],0
        jle   .Death
        mov [Pause_Enabled],1
        stdcall ChooseBitmap
        stdcall NewCalcUron
        stdcall ShowHealthState
        stdcall Is_Blood,Right_Player,[hbmRight_Blood],0,0,640,720
        mov eax, [rc.right]
        sub eax, 640
        stdcall Is_Blood,Left_Player,[hbmLeft_Blood],eax,0,631,719
        cmp [tolpaduration],0
        jne  @f
        invoke PlaySound,SND_TOLPA,0,SND_ASYNC or SND_NOSTOP
        mov  [tolpaduration],120
      @@:
        dec [tolpaduration]
        jmp  .Next
     .Death:
        mov [Pause_Enabled],0
        stdcall DeathDraw
     .Next:
     ret
endp

proc WelcomeWindow ButtonIm1,ButtonIm2,BackGround
        stdcall DrawBackGround,[BackGround],1
        invoke SelectObject,[hdcMem], [hbmName]
        mov eax, [rc.right]
        shr eax, 1
        sub eax, 400
        invoke GdiTransparentBlt,[hdcBack],eax,0,800,300,[hdcMem],0,0,616,324,0h
        invoke SelectObject,[hdcMem], [ButtonIm1]
        mov eax, [rc.right]
        shr eax, 1
        sub eax, 250
        invoke GdiTransparentBlt,[hdcBack],eax,400,500,100,[hdcMem],0,0,320,60,0h
        invoke SelectObject,[hdcMem], [hbmImageBeer]
        mov eax, [rc.right]
        shr eax, 1
        sub eax, 250
        invoke GdiTransparentBlt,[hdcBack],eax,500,500,100,[hdcMem],0,0,320,60,0h
        invoke SelectObject,[hdcMem], [ButtonIm2]
        mov eax, [rc.right]
        shr eax, 1
        sub eax, 250
        invoke GdiTransparentBlt,[hdcBack],eax,600,500,100,[hdcMem],0,0,320,60,0h
        ret
endp

proc  Is_Blood Player,Image,CoordX,CoordY,W,H
       mov ecx,[Player]
       cmp [ecx+PLAYER.Blood_Time],0
       jne .Draw
       cmp [ecx+PLAYER.Delta_Health],80
       jbe .Exit
       mov [ecx+PLAYER.Blood_Time],20
       mov [ecx+PLAYER.Delta_Health],0
       invoke PlaySound,SND_BLOOD,0,SND_ASYNC
       jmp .Exit
     .Draw:
       invoke SelectObject,[hdcMem], [Image]
       invoke GdiTransparentBlt,[hdcBack],[CoordX],[CoordY],[W],[H],[hdcMem],0,0,[W],[H],0FFFFFFh
       mov ecx,[Player]
       dec [ecx+PLAYER.Blood_Time]
     .Exit:
       ret
endp

proc  DeathDraw
       cmp [Death_Duration],1
       jne .FinishHim
       mov [Death_Duration],0
       mov [Is_Keys_Enabled],0
       mov eax,[time]
       add eax,20
       mov [Finish_him_time],eax
       add eax,3
       mov [Kill_anime_time],eax
       add eax,15
       mov [Pause_time],eax
       add eax,30
       mov [Death_time],eax
       invoke PlaySound,SND_FINISH,0,SND_ASYNC
       mov [Right_Player.Bitmap_begX],0
       mov [Left_Player.Bitmap_begX],0
   .FinishHim:
       mov eax,[time]
       cmp eax,[Finish_him_time]
       jae .Animation
       stdcall AnimateBitmap,222,499,[Right_Player.x],300,1,[hbmImage17],0h,Right_Player
       stdcall AnimateBitmap,237,399,[Left_Player.x],400,1,[hbmImage12],0h,Left_Player
       invoke SelectObject,[hdcMem], [hbmFinishHim]
       mov eax, [rc.right]
       shr eax, 1
       sub eax, 400
       invoke GdiTransparentBlt,[hdcBack],eax,200,799,172,[hdcMem],0,0,799,172,0h
       jmp  .Next
   .Animation:
       mov eax,[time]
       cmp eax,[Finish_him_time]
       jne @f
       mov     eax,[time]
       add     eax,20
       mov     [Right_Player.Action_Time_End],eax
       mov     [Left_Player.Action_Time_End],eax
       mov    [Right_Player.x],100
       mov eax, [rc.right]
       sub eax, 300
       mov   [Left_Player.x],eax
    @@:
       mov eax,[time]
       cmp eax,[Kill_anime_time]
       jae .Winner
       mov eax,[Left_Player.Health]
       cmp eax,[Right_Player.Health]
       jge @f
       invoke PlaySound,SND_VOVAPOB,0,SND_ASYNC
       stdcall Left_Player_Death
       jmp  .Next
     @@:
       invoke PlaySound,SND_FEDORPOB,0,SND_ASYNC
       stdcall Right_Player_Death
       jmp .Next
   .Winner:
       mov eax,[time]
       cmp eax,[Death_time]
       ja .EndDraw
       mov eax,[Left_Player.Health]
       cmp eax,[Right_Player.Health]
       jge @f
       invoke SelectObject,[hdcMem], [hbmRKills]
       invoke GdiTransparentBlt,[hdcBack],[Right_Player.x],100,233,700,[hdcMem],466,0,233,700,0h
       invoke SelectObject,[hdcMem], [hbmLDeath]
       invoke GdiTransparentBlt,[hdcBack],[Left_Player.x],400,155,349,[hdcMem],310,0,155,349,0h
       mov eax,[time]
       cmp eax,[Pause_time]
       jb  .Next
       invoke SelectObject,[hdcMem], [hbmFatality]
       mov eax, [rc.right]
       shr eax, 1
       sub eax, 320
       invoke GdiTransparentBlt,[hdcBack],eax,100,640,720,[hdcMem],0,0,640,720,0h
       jmp  .Next
      @@:
       invoke SelectObject,[hdcMem], [hbmLKills]
       invoke GdiTransparentBlt,[hdcBack],[Left_Player.x],100,250,600,[hdcMem],500,0,250,600,0h
       invoke SelectObject,[hdcMem], [hbmRDeath]
       invoke GdiTransparentBlt,[hdcBack],[Right_Player.x],250,185,500,[hdcMem],370,0,185,500,0h
       mov eax,[time]
       cmp eax,[Pause_time]
       jb  .Next
       invoke SelectObject,[hdcMem], [hbmFatality]
       mov eax, [rc.right]
       shr eax, 1
       sub eax, 320
       invoke GdiTransparentBlt,[hdcBack],eax,100,640,720,[hdcMem],0,0,640,720,0h
       jmp  .Next
    .EndDraw:
        mov [Game_State],0
        mov    [Mouse_Enabled],1
    .Next:
      ret
endp

proc   Left_Player_Death
       mov ebx,[time]
       cmp ebx,[Right_Player.Action_Time_End]
       ja .Exit
       stdcall CheckForZero,Right_Player
       stdcall AnimateBitmap,233,700,[Right_Player.x],100,1,[hbmRKills],0h,Right_Player
       stdcall AnimateBitmap,155,349,[Left_Player.x],400,1,[hbmLDeath],0h,Left_Player
    .Exit:
     ret
endp

proc   Right_Player_Death
       mov ebx,[time]
       cmp ebx,[Left_Player.Action_Time_End]
       ja .Exit
       stdcall CheckForZero,Left_Player
       stdcall AnimateBitmap,185,500,[Right_Player.x],250,1,[hbmRDeath],0h,Right_Player
       stdcall AnimateBitmap,250,600,[Left_Player.x],100,1,[hbmLKills],0h,Left_Player
    .Exit:
     ret
endp

