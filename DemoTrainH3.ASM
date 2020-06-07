  0h equ BK_BLACK
  0FFFFFFh equ BK_WHITE
   struct PLAYER
         Action_Time_End dd 0
         Action_State dd 3
         Walk_Stopped dd 1
         Cadr_Change dd 0
         x dd 0
         y dd 0
         Bitmap_begX dd 0
         Bitmap_begY dd 0
         Health   dd   400
         Blood_Time    dd   0
         Kicks_for_Fall dd 0
         Delta_Health  dd  0
  ends
  pt            POINT
  Right_Player PLAYER
  Left_Player  PLAYER
  rcbtBeer RECT

  X_Screen_Resolution dd ?
  Y_Screen_Resolution dd ?

  wc WNDCLASS 0,WindowProc,0,0,NULL,NULL,NULL,NULL,NULL,_class
  font LOGFONT 35, 25, 1900, 0, 700, 3, 4, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,DEFAULT_PITCH
  bm BITMAP
  msg MSG
  rc RECT
  rcbtStart RECT
  rcbtExit  RECT
  lpcs CREATESTRUCT
  pfd PIXELFORMATDESCRIPTOR
  ps PAINTSTRUCT

  Game_State dd 0
  Init_time  dd ?
  Fight_time dd ?
  Mouse_Enabled db 1
  Pause_Enabled db 0
  time  dd  ?
  hwnd dd ?
  hbmT dd ?
  hdc    dd ?
  hbr    dd ?
  newFont dd ?
  oldFont dd ?
  hdcMem  dd ?
   hbm   dd ?
  hbmBack  dd ?
  oldHdc dd ?
  hdcBack dd ?
  time_blood dd 0
  Is_Keys_Enabled db ?
  hbrRed  dd   ?
  hbrBlue  dd   ?
  Death_Duration dd 1
  Death_time     dd 0
  Finish_him_time dd 0
  Pause_time dd 0
  Kill_anime_time  dd 0
  tolpaduration  dd 35
  hbmbtStart     dd ?
  hbmbtExit      dd ?
  hbmName      dd ?
  hbmRight_Blood dd ?
  hbmLeft_Blood dd ?
  hbmCurrBack dd ?
  hbmFight    dd ?
  hbmInitBack dd ?
  hbmRKills dd ?
  hbmLDeath dd ?
  hbmLKills dd ?
  hbmRDeath dd ?
  hbmFatality dd ?
  hbmFinishHim dd ?
  hbmImage17 dd ?
  hbmImage12 dd ?
  hbmImage13 dd ?
  hbmImage10 dd ?
  hbmImage9 dd ?
  hbmImage4 dd ?
  hbmImage14 dd ?
  hbmImage15 dd ?
  hbmImage16 dd ?
  hbmImage18 dd ?
  hbmImage19 dd ?
  hbmImage20 dd ?
  hbmImage21 dd ?
  hbmImage1 dd ?
  hbmImage2 dd ?
  hbmImage26 dd ?
  hbmImage27 dd ?
  hbmImage28 dd ?
  hbmImage29 dd ?
  hbmImage30 dd ?
  hbmImage31 dd ?
  hbmImageBeer dd ?
