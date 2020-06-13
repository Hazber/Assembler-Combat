; OpenGL programming example

format PE GUI 4.0
entry start
ImageBase = $ - rva $
include 'Resource\win32a.inc'
include 'riched32.inc'
include 'DemoTrainBitmaps.ASM'
SND_ASYNC            equ $0001
SND_NOSTOP          equ $0010;
SND_FIGHT       du            'Resource\FIGHT.wav',0
SND_GONG                du    'Resource\GONG.wav',0
SND_POEBALUVOLODIA      du    'Resource\2579c9cef2c3e35.wav',0
SND_LEGF                du    'Resource\NGJA.wav',0
SND_START               du    'Resource\SOSED.wav',0
;SND_START               du     'FEDOEEBALO.wav', 0
;SND_VAFINA              du     'muzyki-iz-igry-mafiya-2-menyu-pauzy (online-audio-converter.com).wav',0
SND_BLOOD               du     'Resource\SND_BLOOD1.wav',0
SND_TOLPA               du     'Resource\TOLPA.wav',0
SND_FINISH              du     'Resource\SND_FINISH.wav',0
SND_HUK                 du     'Resource\SND_HUK.wav',0
SND_HUK1                du     'Resource\SND_HUK1.wav',0
SND_HUK2                 du     'Resource\SND_HUK2.wav',0
SND_HUK3                 du     'Resource\SND_HUK3.wav',0
SND_HUK4                 du     'Resource\SND_HUK4.wav',0
SND_HUK5                 du     'Resource\SND_HUK5.wav',0
SND_HUK6                 du     'Resource\SND_HUK6.wav',0
SND_HUK7                 du     'Resource\SND_HUK7.wav',0
SND_HUK8                 du     'Resource\SND_HUK8.wav',0
SND_FATALITY             du     'Resource\SND_FATALITY.wav',0
SND_VOVAPOB              du     'Resource\SND_VOVAPOB.wav',0
SND_FEDORPOB             du     'Resource\SND_VOVAPOB1.wav',0
SND_NODEFAULT           equ  2h
flag db 0
 WM_SOCK = WM_USER + 100
  PF_INET=2
  SOCK_IDLE   = 0
  SOCK_LISTEN = 1
  SOCK_SERVER = 2
  SOCK_CLIENT = 3
;  // don't stop any currently playing sound
SND_LOOP            equ  $0008;  // loop the sound until next sndPlaySound
  sHost       db '127.0.0.1',0
  port dd 0
  txt  dw  ?
  ttx db 45h
  V_D db 44h
  V_E db 45h
  V_A db 41h
  V_F db 46h
  V_W db 53h
  V_S db 57h

  F_H1 db 0x26
  F_H2 db 0x28
  F_H3 db 0x25
  F_H4 db 0x27
  F_H5 db 0x28
  F_H6 db 0x28
  F_H7 db 0BFh
  F_H8 db 0BEh

  Stp  db 11h


;section '.text' code readable executable

  start:

        xor ebx, ebx
        mov     [initcomctl.dwSize],sizeof.INITCOMMONCONTROLSEX
        mov     [initcomctl.dwICC],ICC_INTERNET_CLASSES
        invoke  InitCommonControlsEx,initcomctl
        invoke  LoadLibrary,_riched
        or      eax,eax
        jz      exit
        invoke  WSAStartup,0101h,wsadata
        or      eax,eax
        jnz     exit
        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,IDR_DIALOG,HWND_DESKTOP,DialogProc,0

exit:
        cmp [flag],1
        je end_loop
        invoke          GetModuleHandle,0                               ; Получим дескриптор приложения.
        mov             [wc.hInstance],eax                              ; Сохраним дескриптор приложения в поле структуры окна (wc)
       ; invoke          LoadIcon,[wc.hInstance],2                       ; Загружаем иконку из секции ресурсов
      ;  mov             [wc.hIcon],eax
        ;invoke  GetModuleHandle,0
      ;mov     [wc.hInstance],ImageBase
       ;invoke LoadImageW,ebx,I_CURSOR, IMAGE_CURSOR, 0, 0, LR_LOADFROMFILE+LR_LOADTRANSPARENT
        invoke  LoadCursor,ebx,IDC_ARROW
        mov     [wc.hCursor],eax
        invoke  RegisterClass,wc

        invoke  CreateWindowEx,0,_class,0,WS_VISIBLE+WS_POPUP,0,0,1920,1080,NULL,NULL,[wc.hInstance],NULL
        mov     [hwnd],eax

  msg_loop:
        invoke  GetMessage,msg,NULL,0,0
        or      eax,eax
        jz      end_loop
        invoke  TranslateMessage,msg
        invoke  DispatchMessage,msg
        jmp     msg_loop

  end_loop:
        invoke  closesocket,[sock]
        invoke  WSACleanup
        invoke  ExitProcess,[msg.wParam]

 proc  DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
        cmp     [msg],WM_INITDIALOG
        je      wminitdialog
        cmp     [msg],WM_COMMAND
        je      wmcommand
        cmp     [msg],WM_SOCK
        je      wmsock
        xor     eax,eax
        jmp     finish
  wminitdialog:
        mov     [status],SOCK_IDLE

        jmp     processed
  wmcommand:
        mov     eax,[wparam]
        cmp     eax,IDCANCEL
        je      wmclose
        cmp     eax,IDOK
        je      .ok
        cmp     eax,ID_LISTEN
        je      .listen
        cmp     eax,ID_GETHOSTBYNAME
        je      .gethostbyname
        cmp     eax,ID_CONNECT
        je      .connect
        cmp     eax,ID_SEND
        je      .send
        cmp     eax,ID_START
        je      wmstart
        shr     eax,16
        cmp     eax,EN_SETFOCUS
        je      .setfocus
        cmp     eax,EN_KILLFOCUS
        je      .killfocus
        cmp     eax,CBN_SETFOCUS
        je      .setfocus
        cmp     eax,CBN_KILLFOCUS
        je      .killfocus
        jmp     processed
  .ok:
        cmp     [focus],ID_HOSTNAME
        je      .gethostbyname
        cmp     [focus],ID_PORT
        je      .connect
        cmp     [focus],ID_SERVPORT
        je      .listen
        cmp     [focus],ID_COMMAND
        je      .send
        jmp     processed
  .setfocus:
        movzx   eax,word [wparam]
        mov     [focus],eax
        jmp     processed
  .killfocus:
        movzx   eax,word [wparam]
        cmp     [focus],eax
        jne     processed
        mov     [focus],0
        jmp     processed
  .listen:
        cmp     [status],SOCK_CLIENT
        je      processed
        cmp     [status],SOCK_IDLE
        jne     .stop
        invoke  socket,AF_INET,SOCK_STREAM,0
        cmp     eax,-1
        je      processed
        mov     [sock],eax
        mov     [saddr.sin_addr],0
        mov     [saddr.sin_family],AF_INET
        invoke  GetDlgItemInt,[hwnddlg],ID_SERVPORT,temp,FALSE
        cmp     [temp],0
        je      processed
        cmp     eax,0FFFFh
        ja      processed
        xchg    ah,al
        mov     [saddr.sin_port],ax
       invoke  bind,[sock],saddr,2048
        or      eax,eax
        jnz     .bind_failed
        invoke  listen,[sock],1
        invoke  WSAAsyncSelect,[sock],[hwnddlg],WM_SOCK,FD_ACCEPT
        mov     [status],SOCK_LISTEN
        invoke  GetDlgItem,[hwnddlg],ID_CONNECT
        invoke  EnableWindow,eax,FALSE
        invoke  SetDlgItemText,[hwnddlg],ID_LISTEN,_stop
        invoke  GetDlgItem,[hwnddlg],ID_LISTEN
        invoke  SendMessage,[hwnddlg],WM_NEXTDLGCTL,eax,TRUE
        jmp     processed
      .bind_failed:
        invoke  closesocket,[sock]
        jmp     processed
      .stop:
       ; invoke  closesocket,[sock]
        cmp     [status],SOCK_SERVER
        je      wmsock.disconnected
        mov     [status],SOCK_IDLE
        invoke  GetDlgItem,[hwnddlg],ID_CONNECT
        invoke  EnableWindow,eax,TRUE
        invoke  SetDlgItemText,[hwnddlg],ID_LISTEN,_listen
        jmp     processed
  .gethostbyname:
        invoke  GetDlgItemText,[hwnddlg],ID_HOSTNAME,buffer,8000h
        invoke  gethostbyname,buffer
        or      eax,eax
        jz      .bad_name
        virtual at eax
        .host   hostent
        end     virtual
        mov     eax,[.host.h_addr_list]
        mov     eax,[eax]
        mov     eax,[eax]
        bswap   eax
        invoke  SendDlgItemMessage,[hwnddlg],ID_IPADDR,IPM_SETADDRESS,0,eax
        invoke  SendDlgItemMessage,[hwnddlg],ID_HOSTNAME,CB_ADDSTRING,0,buffer
        invoke  GetDlgItem,[hwnddlg],ID_PORT
        invoke  SendMessage,[hwnddlg],WM_NEXTDLGCTL,eax,TRUE
        jmp     processed
      .bad_name:
        invoke  SendDlgItemMessage,[hwnddlg],ID_IPADDR,IPM_CLEARADDRESS,0,0
        invoke  GetDlgItem,[hwnddlg],ID_HOSTNAME
        invoke  SendMessage,[hwnddlg],WM_NEXTDLGCTL,eax,TRUE
        jmp     processed
  .connect:
        cmp     [status],SOCK_CLIENT
        je      .disconnect
        cmp     [status],SOCK_IDLE
        jne     processed
        invoke  SendDlgItemMessage,[hwnddlg],ID_IPADDR,IPM_GETADDRESS,0,temp
        mov     eax,[temp]
        bswap   eax
        mov     [saddr.sin_addr],eax
        mov     [saddr.sin_family],PF_INET
        invoke  GetDlgItemInt,[hwnddlg],ID_PORT,temp,FALSE
        cmp     [temp],0
        je      processed
        cmp     eax,0FFFFh
        ja      processed
        xchg    ah,al
        mov     [saddr.sin_port],ax
        invoke  closesocket,[sock]
        invoke  socket,AF_INET,SOCK_STREAM,0
        cmp     eax,-1
        je      processed
        mov     [sock],eax
        invoke  connect,[sock],saddr,2048
        or      eax,eax
        jnz     .refused
        mov     esi,_connected
        mov     eax,0x9F00
        call    write_status
        mov     [status],SOCK_CLIENT
        invoke  WSAAsyncSelect,[sock],[hwnddlg],WM_SOCK,FD_READ or FD_CLOSE
        invoke  SetDlgItemText,[hwnddlg],ID_CONNECT,_disconnect
        invoke  GetDlgItem,[hwnddlg],ID_SEND

        invoke  EnableWindow,eax,TRUE
        invoke  GetDlgItem,[hwnddlg],ID_LISTEN
        invoke  EnableWindow,eax,FALSE
        invoke  GetDlgItem,[hwnddlg],ID_COMMAND
        invoke  SendMessage,[hwnddlg],WM_NEXTDLGCTL,eax,TRUE
        jmp     processed
      .refused:
        mov     esi,_refused
        mov     eax,0xFF
        call    write_status
        jmp     processed
  .send:
        cmp     [status],SOCK_LISTEN
        jbe     processed
        invoke  GetDlgItemText,[hwnddlg],ID_COMMAND,buffer,8000h
        push    eax
        invoke  SendDlgItemMessage,[hwnddlg],ID_COMMAND,CB_ADDSTRING,0,buffer
        pop     eax
        mov     [buffer+eax],13
        inc     eax
        mov     [buffer+eax],10
        inc     eax
        mov     [buffer+eax],0
        invoke  send,[sock],buffer,eax,0
        mov     esi,buffer
        xor     eax,eax
        call    write_status
        mov     [buffer],0
        invoke  SetDlgItemText,[hwnddlg],ID_COMMAND,buffer
        jmp     processed



  .disconnect:
      ;  invoke  closesocket,[sock]
        jmp     wmsock.disconnected
  write_status:
        mov     [charformat.cbSize],sizeof.CHARFORMAT
        mov     [charformat.dwMask],CFM_COLOR
        mov     [charformat.dwEffects],0
        mov     [charformat.crTextColor],eax
        invoke  GetDlgItem,[hwnddlg],ID_STATUS
        mov     ebx,eax
        invoke  SendMessage,ebx,EM_SETSEL,-1,-1
        invoke  SendMessage,ebx,EM_SCROLLCARET,0,0
        invoke  SendMessage,ebx,EM_SETCHARFORMAT,SCF_SELECTION,charformat
        invoke  SendMessage,ebx,EM_REPLACESEL,FALSE,esi
        retn
  wmsock:
        cmp     [status],SOCK_LISTEN
        je      .accept
        invoke  recv,[sock],buffer,8000h,0
        or      eax,eax
        jz      .disconnected
        cmp     eax,-1
        je      .no_response
        mov     [buffer+eax],0
        mov     esi,buffer
        mov     eax,0xFF0000
        call    write_status
      .no_response:
        jmp     processed
      .disconnected:
        mov     [status],SOCK_IDLE
        mov     esi,_disconnected
        mov     eax,0xFF
        call    write_status
        invoke  SetDlgItemText,[hwnddlg],ID_LISTEN,_listen
        invoke  SetDlgItemText,[hwnddlg],ID_CONNECT,_connect
        invoke  GetDlgItem,[hwnddlg],ID_SEND

        invoke  EnableWindow,eax,FALSE
        invoke  GetDlgItem,[hwnddlg],ID_LISTEN
        invoke  EnableWindow,eax,TRUE
        invoke  GetDlgItem,[hwnddlg],ID_CONNECT
        invoke  EnableWindow,eax,TRUE
        invoke  GetDlgItem,[hwnddlg],ID_HOSTNAME
        invoke  SendMessage,[hwnddlg],WM_NEXTDLGCTL,eax,TRUE
        jmp     processed
      .accept:
        invoke  accept,[sock],0,0
        cmp     eax,-1
        je      processed
        xchg    eax,[sock]
        invoke  closesocket,eax
        mov     esi,_accepted
        mov     eax,0x9F00
        call    write_status
        mov     [status],SOCK_SERVER
        invoke  WSAAsyncSelect,[sock],[hwnddlg],WM_SOCK,FD_READ or FD_CLOSE
        invoke  GetDlgItem,[hwnddlg],ID_SEND

        invoke  EnableWindow,eax,TRUE
        invoke  GetDlgItem,[hwnddlg],ID_CONNECT
        invoke  EnableWindow,eax,FALSE
        invoke  GetDlgItem,[hwnddlg],ID_COMMAND
        invoke  SendMessage,[hwnddlg],WM_NEXTDLGCTL,eax,TRUE
        jmp     processed
  wmstart:
         mov [flag],0
         invoke  EndDialog,[hwnddlg],0
         jmp     processed
  wmclose:
      ;  invoke  closesocket,[sock]
        mov [flag],1
        invoke  EndDialog,[hwnddlg],0
  processed:
        mov     eax,1
  finish:
        pop     edi esi ebx
        ret
  endp



proc WindowProc hwnd,wmsg,wparam,lparam
        push    ebx esi edi
        cmp     [wmsg],WM_CREATE
        je      .wmcreate
        cmp     [wmsg],WM_PAINT
        je      .wmpaint
        cmp     [wmsg],WM_SOCK
        je       .wmsock
        cmp     [wmsg],WM_KEYDOWN
        je      .wmkeydown
        cmp     [wmsg],WM_KEYUP
        je      .wmkeyup
        cmp     [wmsg],WM_DESTROY
        je      .wmdestroy
        cmp     [wmsg],WM_ERASEBKGND
        je      .wmerasebackground
        cmp     [wmsg],WM_LBUTTONDOWN
        je      .wmlbuttondown
        cmp     [wmsg],WM_TIMER
        je      .wmtimer
  .defwndproc:
        invoke  DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
        jmp     .finish
  .wmcreate:

          include 'DemoTrainInit1.ASM'
          jmp .finish
  .wmtimer:
        ; cmp
         invoke  WSAAsyncSelect,[sock],[hwnd],WM_SOCK,FD_READ

        ; invoke  WSAAsyncSelect,[sock],[hwnd],WM_SOCK,FD_READ or FD_CLOSE
         inc [time]

          invoke InvalidateRect,[hwnd],NULL,FALSE
          jmp     .finish
   .wmerasebackground:
          mov eax,1
          jmp     .finish
  .wmpaint:
        ;inc [time]
        invoke CreateCompatibleDC,eax
        mov [hdcMem],eax
        invoke BeginPaint,[hwnd],ps
        mov [hdc],eax
        stdcall DrawScene
        invoke BitBlt,[hdc], 0, 0, [rc.right], [rc.bottom] , [hdcBack], 0, 0, SRCCOPY
        invoke  DeleteDC,[hdc]
        invoke  EndPaint,[hwnd],ps
        invoke DeleteDC,[hdcMem]
        ;invoke InvalidateRect,[hwnd],NULL,FALSE
        jmp    .finish

  .wmlbuttondown:
       stdcall  DetectCursor

  .wmkeydown:

       ;  mov esi,[wparam]
       ;  mov [txt],si
       ;  invoke  send,[sock],ttx,2048,0
        ;  invoke WSAGetLastError
       ;  pop eax

       ;  invoke  send,[sock],[wparam],eax,0
         cmp     [wparam],VK_ESCAPE
         jne     @f
         cmp   [Pause_Enabled],1
         jne    .finish
         mov   [Game_State],2
         mov   [Mouse_Enabled],1
         mov   [Is_Keys_Enabled],0
       @@:
         cmp [Is_Keys_Enabled],0
         je  .finish



      .KeyLeft:
        cmp     [wparam],VK_DOWN
        jne     @f
        invoke  send,[sock],F_H2,2048,0
        invoke PlaySound,SND_LEGF,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,2,3,Left_Player
        @@:
        cmp     [wparam],VK_UP
        jne     @f
        invoke  send,[sock],F_H1,2048,0
        invoke PlaySound,SND_HUK2,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,4,3,Left_Player
        ;sub     [Left_Player.x],20
        @@:
        cmp     [wparam],0BFh ;?/
        jne     @f
        invoke  send,[sock],F_H7,2048,0
        invoke PlaySound,SND_HUK4,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,8,3,Left_Player
         @@:
        cmp     [wparam],0BEh ;.
        jne     @f
        invoke  send,[sock],F_H8,2048,0
        invoke PlaySound,SND_HUK5,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,1,3,Left_Player
        @@:
        cmp     [wparam],VK_LEFT
        jne     @f
        invoke  send,[sock],F_H3,2048,0
        stdcall DetectMoveKey,5,15,Left_Player
        @@:
        cmp     [wparam],VK_RIGHT
        jne     @f
        invoke  send,[sock],F_H4,2048,0
        stdcall DetectMoveKey,6,15,Left_Player
        @@:

     .KeyRight:
        cmp     [wparam],44h ;D
        jne     @f
        stdcall DetectMoveKey,6,3,Right_Player
        invoke  send,[sock],V_D,2048,0
       ; invoke   PlaySound, SND_START, NULL,1
        @@:
        cmp     [wparam],41h  ;A
        jne     @f
        stdcall DetectMoveKey,5,15,Right_Player
        invoke  send,[sock],V_A,2048,0
        @@:
        cmp     [wparam],46h ;F
        jne     @f
        invoke  send,[sock],V_F,2048,0
        invoke PlaySound,SND_HUK,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,8,3,Right_Player
        @@:
        cmp     [wparam],45h ;E
        jne     @f
        invoke  send,[sock],V_E,2048,0
        invoke PlaySound,SND_HUK4,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,1,3,Right_Player
        @@:
        cmp     [wparam],53h ;W
        jne     @f
        invoke  send,[sock],V_W,2048,0
        invoke PlaySound,SND_HUK2,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,4,3,Right_Player
        @@:
        cmp     [wparam],57h  ;S
        jne     .defwndproc
        invoke  send,[sock],V_S,2048,0
        invoke PlaySound,SND_HUK3,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,2,3,Right_Player

        jmp     .finish

   .wmsock:
       invoke  recv,[sock],buffer,8000h,0
       movzx   esi,byte[buffer]
       invoke  recv,[sock],buffer,8000h,0
       movzx   ebx,byte[buffer]
       cmp ebx,11h
       je .wmkeyups

   .wmkeydowns:
     ;   invoke  recv,[sock],[wparam],eax,0
       ;  invoke  recv,[sock],buffer,8000h,0
       ;  invoke  recv,[sock],buffer,8000h,0
       ;  movzx    esi,byte[buffer]

         cmp     esi,VK_ESCAPE
         jne     @f
         cmp   [Pause_Enabled],1
         jne    .finish
         mov   [Game_State],2
         mov   [Mouse_Enabled],1
         mov   [Is_Keys_Enabled],0
       @@:
         cmp [Is_Keys_Enabled],0
         je  .finish

      .KeyLefts:

        cmp     esi,VK_DOWN
        jne     @f
        invoke PlaySound,SND_LEGF,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,2,3,Left_Player
        @@:
        cmp     esi,VK_UP
        jne     @f
        invoke PlaySound,SND_HUK2,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,4,3,Left_Player
        ;sub     [Left_Player.x],20
        @@:
        cmp     esi,0BFh ;?/
        jne     @f
        invoke PlaySound,SND_HUK4,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,8,3,Left_Player
         @@:
        cmp     esi,0BEh ;.
        jne     @f
        invoke PlaySound,SND_HUK5,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,1,3,Left_Player
        @@:
        cmp     esi,VK_LEFT
        jne     @f
        stdcall DetectMoveKey,5,15,Left_Player
        @@:
        cmp     esi,VK_RIGHT
        jne     @f
        stdcall DetectMoveKey,6,15,Left_Player
        @@:

     .KeyRights:
        cmp     esi,44h ;D
        jne     @f
        stdcall DetectMoveKey,6,15,Right_Player
        invoke PlaySound,SND_HUK2,0,SND_ASYNC or SND_NOSTOP

       ; invoke   PlaySound, SND_START, NULL,1
        @@:
        cmp     esi,41h  ;A
        jne     @f
        stdcall DetectMoveKey,5,15,Right_Player
        @@:
        cmp     esi,46h ;F
        jne     @f
        invoke PlaySound,SND_HUK,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,8,3,Right_Player
        @@:
        cmp     esi,45h ;E
        jne     @f
         invoke PlaySound,SND_HUK4,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,1,3,Right_Player
        @@:
        cmp     esi,53h ;W
        jne     @f
        invoke PlaySound,SND_HUK2,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,4,3,Right_Player
        @@:
        cmp     esi,57h  ;S
        jne     .defwndproc
        invoke PlaySound,SND_HUK3,0,SND_ASYNC or SND_NOSTOP
        stdcall DetectHitKey,2,3,Right_Player

        jmp     .finish

     .wmkeyups:
         cmp [Is_Keys_Enabled],0
         je  .finish
     .KeyUpLefts:
        cmp     esi,41h
        jne     @f
        stdcall StopWalking,Right_Player
      @@:
        cmp     esi,44h
        jne     @f
        stdcall StopWalking,Right_Player

      @@:
     .KeyUpRights:
        cmp     esi,VK_LEFT
        jne     @f
        stdcall StopWalking,Left_Player
      @@:
        cmp     esi,VK_RIGHT
        jne     .defwndproc
        stdcall StopWalking,Left_Player
        jmp     .finish


 .wmkeyup:
         invoke  send,[sock],Stp,2048,0
         invoke WSAGetLastError
         cmp [Is_Keys_Enabled],0
         je  .finish
     .KeyUpLeft:
        cmp     [wparam],41h
        jne     @f
        stdcall StopWalking,Right_Player
      @@:
        cmp     [wparam],44h
        jne     @f
        stdcall StopWalking,Right_Player

      @@:
     .KeyUpRight:
        cmp     [wparam],VK_LEFT
        jne     @f
        stdcall StopWalking,Left_Player
      @@:
        cmp     [wparam],VK_RIGHT
        jne     .defwndproc
        stdcall StopWalking,Left_Player
        jmp     .finish

.wmdestroy:
       ; invoke  closesocket,[sock]
        invoke  ReleaseDC,[hwnd],[hdc]
        invoke  PostQuitMessage,0

        xor     eax,eax
.finish:
        pop     edi esi ebx
        ret
endp


 include 'DemoTrainFuncs3.ASM'
 include 'DemoTrainScenes.ASM'
 include 'DemoTrainCalculations.asm'

section '.data' data readable writeable
 _riched db 'RICHED32.DLL',0

  _connect db '&Connect',0
  _disconnect db 'Dis&connect',0
  _listen db '&Listen',0
  _stop db '&Stop',0

  _refused db 'Connection refused.',13,10,0
  _connected db 'Connected.',13,10,0
  _disconnected db 'Disconnected.',13,10,0
  _accepted db 'Accepted incoming connection.',13,10,0

  sock dd ?
  temp dd ?
  focus dd ?

  initcomctl INITCOMMONCONTROLSEX
  charformat CHARFORMAT
  wsadata WSADATA
  saddr sockaddr_in

  buffer rb 8000h

  status db ?
  include 'DemoTrainText.ASM'
  include 'DemoTrainH3.ASM'

section '.idata' import data readable writeable

;data import
  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL',\
          gdi,'GDI32.DLL',\
          winmm,'WINMM.DLL',\
          comctl,'COMCTL32.DLL',\
          winsock,'WSOCK32.DLL'

  import winmm,\
         PlaySound,'PlaySoundW',\
          mciSendString,"mciSendStringA"


  import kernel,\
         GetModuleHandle,'GetModuleHandleA',\
         GetTickCount,'GetTickCount',\
         Beep,'Beep',\
         Sleep,'Sleep',\
         LoadLibrary,'LoadLibraryA',\
         lstrlen,'lstrlen',\
         ExitProcess,'ExitProcess'

  import user,\
         RegisterClass,'RegisterClassA',\
         CreateWindowEx,'CreateWindowExA',\
         DefWindowProc,'DefWindowProcA',\
         GetMessage,'GetMessageA',\
         TranslateMessage,'TranslateMessage',\
         DispatchMessage,'DispatchMessageA',\
         LoadCursor,'LoadCursorA',\
         LoadIcon,'LoadIconA',\
         GetClientRect,'GetClientRect',\
         GetDC,'GetDC',\
         ReleaseDC,'ReleaseDC',\
         PostQuitMessage,'PostQuitMessage',\
          BeginPaint,'BeginPaint',\
         EndPaint,'EndPaint',\
         GetCursorPos,'GetCursorPos',\
         PtInRect,'PtInRect',\
         SetTimer,'SetTimer',\
         MessageBox,'MessageBoxA',\
          FillRect,'FillRect',\
            InvalidateRect,'InvalidateRect',\
         LoadImageW,'LoadImageW',\
         GetSystemMetrics, 'GetSystemMetrics',\
         DialogBoxParam,'DialogBoxParamA',\
         SendMessage,'SendMessageA',\
         GetDlgItem,'GetDlgItem',\
         GetDlgItemInt,'GetDlgItemInt',\
         GetDlgItemText,'GetDlgItemTextA',\
         SetDlgItemText,'SetDlgItemTextA',\
         SendDlgItemMessage,'SendDlgItemMessageA',\
         GetFocus,'GetFocus',\
         EnableWindow,'EnableWindow',\
         wsprintf,'wsprintfA',\
         EndDialog,'EndDialog'

   import comctl,\
         InitCommonControlsEx,'InitCommonControlsEx'


   import winsock,\
         WSAStartup,'WSAStartup',\
         WSACleanup,'WSACleanup',\
         WSAAsyncSelect,'WSAAsyncSelect',\
         gethostbyname,'gethostbyname',\
         socket,'socket',\
         bind,'bind',\
         listen,'listen',\
         accept,'accept',\
         connect,'connect',\
         recv,'recv',\
         send,'send',\
         recvfrom,'recvfrom',\
         inet_addr,'inet_addr',\
         htons,'htons',\
          WSAGetLastError,'WSAGetLastError',\
         closesocket,'closesocket'

  import gdi,\
         ChoosePixelFormat,'ChoosePixelFormat',\
         SetPixelFormat,'SetPixelFormat',\
         SwapBuffers,'SwapBuffers',\
         Ellipse,'Ellipse',\
         Rectangle,'Rectangle',\
         SaveDC,'SaveDC',\
         SetBkColor,'SetBkColor',\
         CreatePatternBrush,'CreatePatternBrush',\
         CreateSolidBrush,'CreateSolidBrush',\
         CreateBitmap,'CreateBitmap',\
         CreateCompatibleDC,'CreateCompatibleDC',\
         CreateCompatibleBitmap,'CreateCompatibleBitmap',\
         SelectObject,'SelectObject',\
         GetPixel,'GetPixel',\
         GetObjectA,'GetObjectA',\
         BitBlt,'BitBlt',\
         DeleteObject,'DeleteObject',\
         SetTextColor,'SetTextColor',\
         CreateFontA,'CreateFontA',\
         CreateFontIndirectA,'CreateFontIndirectA',\
         GdiTransparentBlt,'GdiTransparentBlt',\
         TextOut,'TextOutA',\
         DeleteDC,'DeleteDC'

section         '.rsrc' resource data readable

 IDR_DIALOG = 37
  IDR_LOGO   = 7

  ID_SERVPORT      = 0x101
  ID_LISTEN        = 0x102
  ID_HOSTNAME      = 0x103
  ID_GETHOSTBYNAME = 0x104
  ID_IPADDR        = 0x105
  ID_PORT          = 0x106
  ID_CONNECT       = 0x107
  ID_STATUS        = 0x108
  ID_COMMAND       = 0x109
  ID_SEND          = 0x10A
  ID_START         = 0x10B

  directory RT_DIALOG,dialogs,\
            RT_BITMAP,bitmaps

  resource dialogs,\
           IDR_DIALOG,LANG_ENGLISH+SUBLANG_DEFAULT,main

  resource bitmaps,\
           IDR_LOGO,LANG_ENGLISH+SUBLANG_DEFAULT,logo

  dialog main,'Launcher for ASSebler Combat Online',70,70,332,176,WS_CAPTION+WS_POPUP+WS_SYSMENU+WS_MINIMIZEBOX+DS_MODALFRAME
    dialogitem 'STATIC',IDR_LOGO,-1,4,4,248,20,WS_VISIBLE+SS_BITMAP
    dialogitem 'BUTTON','',IDOK,0,0,0,0,BS_DEFPUSHBUTTON
    dialogitem 'STATIC','&Host name:',-1,4,26,148,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_HOSTNAME,4,36,148,12,WS_VISIBLE+WS_BORDER+ES_AUTOHSCROLL+WS_TABSTOP
    dialogitem 'BUTTON','>',ID_GETHOSTBYNAME,156,36,20,12,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
    dialogitem 'STATIC','&IP address:',-1,180,26,72,8,WS_VISIBLE
    dialogitem 'SysIPAddress32','',ID_IPADDR,180,36,72,12,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
    dialogitem 'STATIC','&Port:',-1,256,26,20,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_PORT,256,36,24,12,WS_VISIBLE+WS_BORDER+ES_NUMBER+WS_TABSTOP
    dialogitem 'BUTTON','&Connect',ID_CONNECT,284,36,44,12,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
    ; dialogitem 'BUTTON','&Connect',ID_CONNECT,240,36,44,12,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
    dialogitem 'STATIC','&Port:',-1,256,2,20,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_SERVPORT,256,12,24,12,WS_VISIBLE+WS_BORDER+ES_NUMBER+WS_TABSTOP
    dialogitem 'BUTTON','&Listen',ID_LISTEN,284,12,44,12,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
    dialogitem 'RichEdit','',ID_STATUS,4,52,324,104,WS_VISIBLE+WS_BORDER+WS_VSCROLL+ES_AUTOHSCROLL+ES_AUTOVSCROLL+ES_MULTILINE+ES_READONLY+WS_TABSTOP
    dialogitem 'EDIT','',ID_COMMAND,4,160,178,12,WS_VISIBLE+WS_BORDER+ES_AUTOHSCROLL+WS_TABSTOP

    dialogitem 'BUTTON','&Send',ID_SEND, 185,160,44,12 ,WS_VISIBLE+WS_DISABLED+BS_PUSHBUTTON+WS_TABSTOP
    dialogitem 'BUTTON','&Start Game!',ID_START,236,157,44,18,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
;    dialogitem 'SELECTION','lol',150,157,44,18,MFS_CHECKED,MFT_RADIOCHECK
    dialogitem 'BUTTON','E&xit',IDCANCEL,284,160,44,12,WS_VISIBLE+BS_PUSHBUTTON+WS_TABSTOP
  enddialog

  bitmap logo,'logo1.bmp'
 


;end data
;section '.rsrc' resource from 'GDI01.res' data readable