          invoke PlaySound,SND_START,0,SND_ASYNC
          invoke  SetTimer,[hwnd],100,100,NULL

          invoke GetSystemMetrics, SM_CXSCREEN
          mov [rc.right], eax
          invoke GetSystemMetrics, SM_CYSCREEN
          mov [rc.bottom], eax

          invoke  GetDC,[hwnd]
          mov [oldHdc],eax
          invoke CreateCompatibleDC,[oldHdc]
          mov [hdcBack],eax
          invoke  CreateCompatibleBitmap,[oldHdc], [rc.right], [rc.bottom]
          mov [hbmBack],eax
          invoke ReleaseDC,[hwnd],[oldHdc]
          invoke SaveDC,[hdcBack]
          invoke SelectObject,[hdcBack],[hbmBack]
         ; invoke CreateFontIndirectA,font
         ; mov [newFont],eax
          invoke LoadImageW,[wc.hInstance],I_BITMAP17, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage17],eax
          invoke LoadImageW,[wc.hInstance],I_BITMAP4, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage4],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP_FIGHT, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmFight],eax
           invoke LoadImageW,[wc.hInstance],I_BT_R_KILLS, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmRKills],eax
           invoke LoadImageW,[wc.hInstance],I_BT_L_DEATH, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmLDeath],eax
          invoke LoadImageW,[wc.hInstance],I_BT_L_KILLS, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmLKills],eax
           invoke LoadImageW,[wc.hInstance],I_BT_R_DEATH, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmRDeath],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP19, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage10],eax
            invoke LoadImageW,[wc.hInstance],I_BITMAP18, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage18],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP20, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage20],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP21, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage21],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP12, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage12],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP13, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage13],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP9, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage9],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP3, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmCurrBack],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP14, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage14],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP1, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage1],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP15, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage15],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP25, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage2],eax
            invoke LoadImageW,[wc.hInstance],I_BITMAP26, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage26],eax
            invoke LoadImageW,[wc.hInstance],I_BITMAP27, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage27],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP28, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage28],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP29, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage29],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP30, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage30],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP31, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage31],eax
           invoke LoadImageW,[wc.hInstance],I_BT_R_BLOOD, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmRight_Blood],eax
           invoke LoadImageW,[wc.hInstance],I_BT_L_BLOOD, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmLeft_Blood],eax
           invoke LoadImageW,[wc.hInstance],I_BTSTART, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmbtStart],eax
           invoke LoadImageW,[wc.hInstance],I_BT_FATALITY, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmFatality],eax
           invoke LoadImageW,[wc.hInstance],I_BT_FINISH_HIM, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmFinishHim],eax
           invoke LoadImageW,[wc.hInstance],I_BTEXIT, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmbtExit],eax
           invoke LoadImageW,[wc.hInstance],I_NAME, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmName],eax
           invoke LoadImageW,[wc.hInstance],I_BITMAP16, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImage16],eax
            invoke LoadImageW,[wc.hInstance],I_BEER, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
          mov [hbmImageBeer],eax

          mov [rcbtBeer.right],1000
          mov [rcbtBeer.top],500
          mov [rcbtBeer.left],500
          mov [rcbtBeer.bottom],600


          mov [rcbtStart.right],1000
          mov [rcbtStart.top],400
          mov [rcbtStart.left],500
          mov [rcbtStart.bottom],500

          mov [rcbtExit.right],1000
          mov [rcbtExit.top],600
          mov [rcbtExit.left],500
          mov [rcbtExit.bottom],700

          invoke CreateSolidBrush,0FFh
           mov [hbrRed],eax
          invoke CreateSolidBrush,0FFFFh
           mov [hbrBlue],eax