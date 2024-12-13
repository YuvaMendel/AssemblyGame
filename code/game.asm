.486
IDEAL
MODEL small
STACK 100h

;Game Name: Zombie Apocalypse

;This game uses binary 4 digits to represent fractions (Fixed decimal point)

;Screen size: X: 0 - 320; Y: 0 - 200 (With Fixed Decimal: X: 0 - 5120; Y: 0 - 3200)


;CONSTS
;
;
;Player Atributes
PLAYERLENGTH = 80h;Player Size X
PLAYERHIGHT = 0d0h;Player Size Y
PLAYERSTARTINGXPOS = 0A00h;Player starting Point X With FixedDecimal Point
PLAYERSTARTINGYPOS = 0640h;Player starting Point Y With FixedDecimal Point
KnightDefultFName equ "KnightDe.bmp";Name for file with defult frame
KnightWalk1FName equ "KWalk1.bmp";Name for file with walk frame num 1
KnightWalk2FName equ "KWalk2.bmp";Name for file with walk frame num 2
KRoll1FName equ "KRoll1.bmp";Name for file with roll frame num 1
KRoll2FName equ "KRoll2.bmp";Name for file with roll frame num 2
KRoll3FName equ "KRoll3.bmp";Name for file with roll frame num 3
;EraseKnightFName equ "EraseK.bmp";Name for file to erase other frames
KNIGHTLENGTHTRAVEL = 20h;With fixed Decimal point
KShootCycleCoolDown = 3;Const that holds the number of cycels the player has cooldown on shooting
KnightFrameChangeRate = 3;Const to represent the amount of cycles for each Knight frame change
PlayerHP = 100;Defult Hp

RollDuration = 8;Const to represent the amount of cycels the roll has
PlayerRollSpeed = 50h;Speed of roll
RollCoolDown = 15;Const to represent the cycle cooldown on rolling
;

KeyboardInterruptPosition = 9 * 4

;
;Bullet Class attributes
BULLETLENGTH = 50h;Fixed decimal point
BULLETHEIGHT = 50h;shot is a cube
BulletSpeed = 03ah; speed of bullet vector
BulletArrayLength = 16
BulletDamage = 30


;Zombi class Const
ZombiHeight = 0c0h;Zombi Height
ZombiLength = 0a0h;Zombi Length

ZombieWalkRight1FName equ "ZMBWR1.bmp"
ZombieWalkRight2FName equ "ZMBWR2.bmp"

ZombieWalkLeft1FName equ "ZMBWL1.bmp"
ZombieWalkLeft2FName equ "ZMBWL2.bmp"

;EraseZombieFName equ "EraseZMB.bmp"

ZombieAnimationSpeed = 6;the speed the frames switch

NumberOfZombies = 8

ZombieHP = 60;Zombie HP

ZMBSpeedInc = 06h;Speed increased after a number of zombie kills
AmountOfZombiesKilledForSpeedInc = 15;

ZombieMeleeAttackDamage = 20 ;The amount of damage zombies melee attack does

ZMBBehaviorRefreshRate =  40; the are the zombie refreshes its behavior

ZMBMeleeAttackCoolDown = 30;Const to represent the amount of cycles the melee attack is on cooldown

ZombieSpawnRate = 50;the rate of a new Zombie to spawn

;Board Sizes
MaxBoardLength = 1400h ;With fixed decimal point
MaxBoardHeight = 0b90h ;With fixed decimal point

BackgroundBMPLength = 320
BackgroundBMPHeight = 200

BackgroundBMPFName equ "BackGRND.bmp"

;
MainMenuFName equ "Menu.bmp"

GameOverFName equ "GameOver.bmp"

VideoSegment = 0a000h


DATASEG
; --------------------------
;Variable For Random
	RndCurrentPos dw start
	
;Variable For putMatrixInScreen
	matrix dw ?
	
;Variables For BMP
	OneBmpLine 	db 200 dup (?)  ; One Color line read buffer
    ScrLine 	db 320 dup (?)  ; One Color line read buffer
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	ErrorFile db 0
	
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?
	
	PutBMPSegement dw VideoSegment
	
;Variables For My Bmp
	MyFileHandle dw ?
	MyErrorFile db 0
	MyHeader db 54 dup(0)
	MyPalette db 400h dup (0)
	MyScrLine 	db 320 dup (?)  ; One Color line read buffer

	
;-------------
;-------------
;-------------
;-------------

;My Variabls
;main menu
	MainMenuBMP db MainMenuFName, 0
	
	GameOverBMP db GameOverFName, 0
	
;Baackground
	BackGroundBMPFileName db BackgroundBMPFName, 0
	
;Display Hp
	EraseScoreText db '    $'
	FinalScoreText db 'Your final score is: $'
	

;Knight Variables
	XPlayer dw PLAYERSTARTINGXPOS;Variable to represent the X position of the Knight (with fixed decimal point)
	YPlayer dw PLAYERSTARTINGYPOS;Variable to represent the Y position of the Knight (with fixed decimal point)
	
	LastXPlayer dw ? ;save last X position to undraw later
	LastYPlayer dw ? ;save last Y position to undraw later
	
	KNeedDraw db 1; bool to represent if the last position was saved and if Knight needs draw

	;bool for condition of knight
	KAbleToBeHit db 0 ;bool to represent if the knight can be hit
	
	KRolling db 1;bool to represent if the Knight is rolling
	
	KRollStage db ?;Variable to count the stageof rolling the knight is in 


	KCanShoot db 0 ;bool to represent if the knight can use a shot
	KShootCoolDown db 0 ;counter to make shooting go on "cooldown"
	KCanMove db 0 ;bool to represent if the knight can move
	KCanRoll db 0
	
	KnightHP dw PlayerHP
	
	
	KnightDefultFileName db KnightDefultFName, 0;File name of the defult Knight picture file
	KnightDefultMatrix db 104 dup (0)
	
	KnightWalk1FileName db KnightWalk1FName, 0
	KnightWalk1Matrix db 104 dup (0)
	
	KnightWalk2FileName db KnightWalk2FName, 0
	KnightWalk2Matrix db 104 dup (0)
	
	KnightRoll1FileName db KRoll1FName, 0
	KnightRoll1Matrix db 104 dup (0)
	
	KnightRoll2FileName db KRoll2FName, 0
	KnightRoll2Matrix db 104 dup (0)
	
	KnightRoll3FileName db KRoll3FName, 0
	KnightRoll3Matrix db 104 dup (0)
	
	KnightWalkFrameChangeCounter db 0
	FrameNumber db 0;Variable to represent what frame of aaaaaasthe walk the knight is in
	;KnightEraseFileName db EraseKnightFName, 0
	
	
	PlayerScore dw 0
	
	KXToAddWhileRolling dw ?
	KYTOAddWhileRolling dw ?
	
	RollCoolDownCounter dw ?
	


;Async Keyboard Variables
	oldintruptoffset dw ?
	oldintruptsegment dw ?
	key db ?
	
;bools to represent is each key was pressed
	WPressed db 1;0 when pressed 1 when released
	SPressed db 1;0 when pressed 1 when released
	APressed db 1;0 when pressed 1 when released
	DPressed db 1;0 when pressed 1 when released
	
	SpacePressed db 1;0 when pressed 1 when not pressing
	
	GameOn db 0
	
;variables for high score
	HighScoreFileName db "HS.txt", 0
	HSFileHandle dw ?
	HighScore dw ?
	NewHighScoreText db "You Broke the high score$"
	HighScoreBeginingText db "The current high score is $"
	

;Bullet Class
;Some of the procedures work on a group of variables that come in a certain order dependant on the offset (Like a class)
;The class structure is consistent and **can't be changed** If more variables are needed they can be added in the end of all the variabls.

	
	
	BulletDrawArray db 1,6fh,4,6fh,1
					db 6fh,4,4,4,6fh
					db 6fh,4,4,4,6fh
					db 6fh,4,4,4,6fh
					db 1,6fh,4,6fh,1
	;BulletEraseArray db 25 dup (0)
	ActiveBulletCounter db 0
;Bullet Array
	BulletOffsetArray dw Bullet1Active, Bullet2, Bullet3, Bullet4, Bullet5, Bullet6, Bullet7, Bullet8, Bullet9, Bullet10, Bullet11, Bullet12, Bullet13, Bullet14, Bullet15, Bullet16

;Bullet1
	Bullet1Active db 1;bool to represent if the bullet is "shot"(active); offset + 0
	Bullet1X dw ? ;Variable to represent the X posotion of the bullet; offset + 1
	Bullet1Y dw ? ;Variable to represent the Y posotion of the bullet; offset + 3
	Bullet1XToAdd dw ?;Variable to represent the X added each time for the direction; offset + 5
	Bullet1YToAdd dw ?;Variable to represent the Y added each time for the direction; offset + 7
	
;Bullet2
	Bullet2 db 1, 8 dup(?)

;Bullet3
	Bullet3 db 1, 8 dup(?)
	
;Bullet4
	Bullet4 db 1, 8 dup(?)
	
;Bullet5
	Bullet5 db 1, 8 dup(?)
	
;Bullet6
	Bullet6 db 1, 8 dup(?)
	
;Bullet7
	Bullet7 db 1, 8 dup(?)
	
;Bullet8
	Bullet8 db 1, 8 dup(?)

;Bullet9
	Bullet9 db 1, 8 dup(?)
	
;Bullet10
	Bullet10 db 1, 8 dup(?)

;Bullet11
	Bullet11 db 1, 8 dup(?)
	
;Bullet12
	Bullet12 db 1, 8 dup(?)
	
;Bullet13
	Bullet13 db 1, 8 dup(?)
	
;Bullet14
	Bullet14 db 1, 8 dup(?)
	
;Bullet15
	Bullet15 db 1, 8 dup(?)
	
;Bullet16
	Bullet16 db 1, 8 dup(?)

	





;Zombie Class
;Some of the procedures work on a group of variables that come in a certain order dependant on the offset (Like a class)
;The class structure is consistent and **can't be changed** If more variables are needed they can be added in the end of all the variabls.
	
;Zombi Offset Array
	ZombieOffsetArray dw Zombie1Active, Zombie2, Zombie3, Zombie4, Zombie5, Zombie6, Zombie7, Zombie8
	ZMBWL1FileName db ZombieWalkLeft1FName, 0
	ZMBWL1Matrix db 120 dup (0)
	
	ZMBWL2FileName db ZombieWalkLeft2FName, 0
	ZMBWL2Matrix db 120 dup (0)
	
	ZMBWR1FileName db ZombieWalkRight1FName, 0
	ZMBWR1Matrix db 120 dup (0)
	
	ZMBWR2FileName db ZombieWalkRight2FName, 0
	ZMBWR2Matrix db 120 dup (0)
	
	ActiveZombieCounter db 0
	ZMBSPEED dw 22h
	
;Zombi1
	Zombie1Active db 1;bool to represent if the zombie is alive/active; offset + 0
	Zombie1X dw ?;Variable to represent the X posotion of the Zombi; offset + 1
	Zombie1Y dw ?;Variable to represent the Y posotion of the Zombi; offset + 3
	Zombie1XToAdd dw ?;Variable to represent the X that will be added each time; offset + 5
	Zombie1YToAdd dw ?;Variable to represent the Y that will be added each time; offset + 7
	Zombie1HPVar db ZombieHP;Variable to representthe amount of hp the zombie has; offset + 9
	Zombie1WalkFrameNumber db 0;Variable to represent what frame the zombi is in in the walking; offset + 10
	ZMB1Direction db 0;Variable to represent which side the Zombie is going to 0 -> right 1 -> left ;offset + 11
	ZMB1CountToBehaviorChange dw 0;Variable to control how often the behavior change; offset + 12
	ZMB1CanMelleAtack db 0;bool to represent id the zombie can melle attack "hug" the player; offset + 14
	ZMB1AttackCoolDownCounter dw 0;Variable to count the cooldown for zombie attack; offset + 15

;Zombi2
	Zombie2 db 1, 16 dup (0)
	
;Zombi3
	Zombie3 db 1, 16 dup (0)

;Zombi4
	Zombie4 db 1, 16 dup (0)
	
;Zombie5
	Zombie5 db 1, 16 dup (0)
	
;Zombie6
	Zombie6 db 1, 16 dup (0)
	
;Zombie7
	Zombie7 db 1, 16 dup (0)
	
;Zombie6
	Zombie8 db 1, 16 dup (0)
	
;;;
;;;
;;;
; Will and screen with first matrix and xor afterwards. 
	MouseMask dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  
			  
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b

; --------------------------

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
	call SetGraphic
	call DisplayMainMenu
	call GetHighScore
	call DisplayHighScore
	call WaitForEnter
	call ClearScreen
	call PrintBackground
	call ConvertAllBMPToMatrix
	call SetAsyncKeyboard
	call DrawKnight
	call SetAsyncMouse
	call SetMouseShape
	call ShowCurser
	
	
	call DisplayKHP
	Call ShowScore
GameLoop:
	cmp [word KnightHP], 0
	jnz @@NotDead
	mov [byte GameOn], 1
@@NotDead:
	cmp [byte GameOn], 0
	jnz endOfMainLoop
	call UpdateShootCoolDown
	
	;save x and y for draw
	mov ax, [word XPlayer]
	mov [word LastXPlayer], ax
	
	mov ax, [word YPlayer]
	mov [word LastYPlayer], ax
	;save x and y for draw
	call HideCurser
	
	call CheckandUpdateallZombies
	call Update_activated_Bullets
	call UpdateRoll
	call CheckKeys;check keys flags and moves knight, draws knight aswell
	
	call ShowCurser
	
	
	call ActivateZombiesRandomly
	call DelayTheSameAmountEachCycle;delay the smae amount each cycle
	call LoopDelay;delay
	jmp GameLoop
endOfMainLoop:
	call RestoreKeyboardInt
	call HideCurser
	
	call DisplayGameOver
	call CheckHighScore
	call DisplayFinalScore
	call WaitForEnter
	call ClearScreen
; --------------------------

exit:
	mov ax, 4c00h
	int 21h
	
;----------------
;----------------
;----------------
;----------------
;---Procedures---
;----------------
;----------------
;----------------
;My Procedures

;Description: Makes Delay be the same all the time
;Input: ActiveZombieCounter, ActiveBulletCounter
proc DelayTheSameAmountEachCycle
	pusha
	
	mov cx, NumberOfZombies
	sub cl, [ActiveZombieCounter]
	cmp cx, 0
	jz @@NoDelay1
@@Delay1:
	push 0A00h
	push 0ba0h
	push ZombiLength
	push ZombiHeight
	call PutBackgroundInSpot
	loop @@Delay1
@@NoDelay1:

	mov cx, BulletArrayLength
	sub cl, [ActiveBulletCounter]
	cmp cx, 0
	jle @@NoDelay2
@@Delay2:
	push 0A00h
	push 0ba0h
	push BULLETLENGTH
	push BULLETHEIGHT
	call PutBackgroundInSpot
	loop @@Delay2
@@NoDelay2:

	popa
	ret
endp DelayTheSameAmountEachCycle

;Description: Displays the high score in the bottom of the screen
;Input: HighScore
;Output: On screen
proc DisplayHighScore
	pusha
	
	mov ah, 2
	mov bh, 0
	mov dh, 19 ; line number
	mov dl, 7; column number
	int 10h
	
	
	mov dx, offset HighScoreBeginingText
	mov ah, 9
	int 21h
	
	mov ax, [HighScore]
	call printAxDec
	
	popa
	ret
endp DisplayHighScore

;input: File HS.txt
;Output: HighScore
proc GetHighScore
	pusha
	mov al, 0
	mov ah, 3dh
	mov dx, offset HighScoreFileName
	int 21h
	mov [word HSFileHandle], ax
	
	mov cx, 2
	mov dx, offset HighScore
	mov bx, [word HSFileHandle]
	mov ah, 3fh
	int 21h
	
	mov ah, 3eh
	mov bx, [HSFileHandle]
	int 21h
	popa
	ret
endp GetHighScore

;Description: check if the current score is higher then high score and updates the high score file
;input:PlayerScore, HighScore
;Output: HS.txt
proc CheckHighScore
	pusha
	
	
	mov ax, [PlayerScore]
	cmp ax, [HighScore]
	jna @@NoNewHScore
	;New High Score
	mov al, 1
	mov ah, 3dh
	mov dx, offset HighScoreFileName
	int 21h
	
	mov [word HSFileHandle], ax
	
	
	
	
	mov ah, 40h
	mov bx, [word HSFileHandle]
	mov cx, 2
	mov dx, offset PlayerScore
	int 21h
	
	mov ah, 3eh
	mov bx, [HSFileHandle]
	int 21h
	
	mov ah, 2
	mov bh, 0
	mov dh, 18 ; line number
	mov dl, 7; column number
	int 10h
	
	mov dx, offset NewHighScoreText
	mov ah, 9
	int 21h
	
@@NoNewHScore:
	popa
	ret
endp CheckHighScore

;Description: Takes a part of the background and puts it on the matching spot in the screen
;Input: Through Stack: 1.X(With Decimal Point) 2.Y(With Decimal Point) 3.Length(With Decimal Point) 4. Height(With Decimal Point)
;Output: On srceen
proc PutBackgroundInSpot
	push bp
	mov bp, sp
	sub sp, 2
	;make room for padding variable
	;[bp - 2] -> Padding
	pusha
	
	
	
	sub sp, 2
	push [word bp + 8]
	call RemoveFixedDecimalPoint
	pop [word bp + 8]
	
	sub sp, 2
	push [word bp + 10]
	call RemoveFixedDecimalPoint
	pop [word bp + 10]
	
	
	
	sub sp, 2
	push [word bp + 4]
	call RemoveFixedDecimalPoint
	pop [word bp + 4]
	
	sub sp, 2
	push [word bp + 6]
	call RemoveFixedDecimalPoint
	pop [word bp + 6]
	
	
	
	mov dx, offset BackGroundBMPFileName
	call OpenMyBmpFile
	
	mov dx, offset BackGroundBMPFileName
	call ReadMyBmpHeader
	
	mov dx, offset BackGroundBMPFileName
	call ReadMyBmpPalette
	
	mov ax, VideoSegment
	mov es, ax
	
	
	
	mov ax,BackgroundBMPLength ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov [word bp-2], 0
	jz @@row_ok
	mov [word bp - 2],4
	sub [word bp - 2],dx

@@row_ok:
	mov cx, BackgroundBMPHeight
	sub cx, [bp + 8]
	sub cx, [bp + 4]

	
	
;get to relevent row in file
	mov ax, BackgroundBMPLength
	add ax,[bp - 2]  ; extra  bytes to each row must be divided by 4
	mul cx
	
	mov cx, dx
	mov dx, ax
	
	mov ah,42h
	mov al, 1
	
	
	mov bx, [MyFileHandle]
	
	int 21h
	
	
@@RowNumberOK:
	
	mov cx, [bp + 4]
	mov dx, [bp + 10]
	
@@NextLine:
	push cx
	push dx
	
	mov di, cx
	add di, [bp + 8]
	
	mov cx, di
	shl cx, 6
	shl di, 8
	add di, cx
	add di, dx
	
	sub di, 320
	
	mov ah,3fh
	mov cx,	BackgroundBMPLength  
	add cx, [bp - 2]  ; extra  bytes to each row must be divided by 4
	mov dx,offset MyScrLine
	int 21h
	
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx, [bp + 6]  
	mov si,offset MyScrLine
	add si, [bp + 10]
	
	rep movsb ; Copy line to the screen
	
	pop dx
	pop cx
	
	loop @@NextLine
	
	call CloseMyBmpFile
	
	popa
	add sp, 2
	pop bp
	ret 8
endp PutBackgroundInSpot

;Description:Prints the background bmp to the screen
proc PrintBackground
	pusha
	;DX = offset FileName, BmpLeft = X position on screen(0 - 319), BmpTop = Y position on screen(0 - 200), BmpColSize = Length ,BmpRowSize = Hight
	mov dx, offset BackGroundBMPFileName
	
	mov [word BmpLeft], 0
	mov [word BmpTop], 0
	mov [word BmpColSize], BackgroundBMPLength
	mov [word BmpRowSize], BackgroundBMPHeight
	
	call OpenShowBmp
	
	
	popa
	ret
endp PrintBackground

;Description: Changes mouse shape
proc SetMouseShape
	pusha
	
	push ds
	pop es
	
	mov dx, offset MouseMask
	mov bx, 8
	mov cx, 8
	mov ax, 9
	int 33h
	
	popa
	ret
endp SetMouseShape

;Description:Updates roll stage or roll cooldown
proc UpdateRoll
	pusha
	cmp [byte KRolling], 0
	jnz @@notRoll;not rolling
	
	mov [byte KNeedDraw], 0
	

	
	call AddXYPlayerRoll
	
	inc [byte KRollStage]
	
	cmp [byte KRollStage], RollDuration
	jnz @@RollNotOver
	;Roll is over
	mov [byte KRolling], 1
	mov [byte KAbleToBeHit], 0
	mov [byte KCanMove], 0
	mov [word RollCoolDownCounter], 0
	mov [byte KCanRoll], 1
@@RollNotOver:
	jmp @@endproc
@@notRoll:
;Here I UpdateMy Roll CoolDown
	cmp [byte KCanRoll], 0
	jz @@endproc; roll not on cooldown
	inc [word RollCoolDownCounter]
	cmp [word RollCoolDownCounter], RollCoolDown
	jnz @@endproc
	;Roll finished cooldown
	mov [byte KCanRoll], 0
@@endproc:
	popa
	ret
endp UpdateRoll

;Description: add player x and y for roll
proc AddXYPlayerRoll
	pusha
	
	
	mov ax, [XPlayer]
	mov bx, [KXToAddWhileRolling]
	
	add ax, bx
	
	cmp ax, 0
	jnle @@XOK1
	mov ax, 0
@@XOK1:

	add ax, PLAYERLENGTH
	cmp ax, MaxBoardLength
	jnge @@XOK2
	mov ax, MaxBoardLength
@@XOK2:
	
	sub ax, PLAYERLENGTH
	
	mov [word XPlayer], ax
	
	mov ax, [YPlayer]
	mov bx, [KYToAddWhileRolling]
	
	add ax, bx
	
	cmp ax, 0
	jnle @@YOK1
	mov ax, 0
@@YOK1:

	add ax, PLAYERHIGHT
	cmp ax, MaxBoardHeight
	jnge @@YOK2
	mov ax, MaxBoardHeight
@@YOK2:
	sub ax, PLAYERHIGHT
	
	mov [word YPlayer], ax
	
	
	popa
	ret
endp AddXYPlayerRoll


;Description: Player starts Rolling
proc StartRoll
	pusha 
	
	cmp [byte KRolling], 0
	jz @@endproc;Already rolling
	cmp [byte KCanRoll], 0
	jnz @@endproc;Roll on cooldown
	
	mov [byte KRollStage], 0;Rolling stage -> 0
	
	mov [byte KAbleToBeHit], 1;Knight Can't be hit
	
	mov [byte KCanMove], 1;Knight Can't Move
	
	mov [byte KRolling], 0
	



	
	
	mov cx, [XPlayer]
	mov dx, [YPlayer]
	
	mov si, 1;bool to represent if there are keys pressed
	mov di, 1

	cmp [byte WPressed], 0
	jnz @@KnightNotGoingUp
	sub dx, 10h
	jnc @@InTheScreen1
	xor dx, dx
@@InTheScreen1:
	xor di, 1
@@KnightNotGoingUp:

	cmp [byte SPressed], 0
	jnz @@KnightNotGoingDown
	add dx, 10h
	xor di, 1
@@KnightNotGoingDown:

	cmp [byte APressed], 0
	jnz @@KnightNotGoingLeft
	sub cx, 10h
	jnc @@InTheScreen2
	xor cx, cx
@@InTheScreen2:
	xor si, 1
@@KnightNotGoingLeft:

	cmp [byte DPressed], 0
	jnz @@KnightNotGoingRight
	add cx, 10h
	xor si, 1
@@KnightNotGoingRight:

	test si, di;if no key was pressed the dash won't move player
	jz @@KeyWasPressed
	
	mov [word KXToAddWhileRolling], 0
	mov [word KYToAddWhileRolling], 0
	jmp @@EndProc
@@KeyWasPressed:
	
	sub sp, 4
	push [word XPlayer]
	push [word YPlayer]
	push cx
	push dx
	push PlayerRollSpeed
	call XYtoAdd2DotsWithNeg
	
	pop [word KXToAddWhileRolling]
	pop [word KYTOAddWhileRolling]
	
	
@@endproc:
	popa
	ret
endp StartRoll

;Description: This procedure spawns Zombies Randomly
proc ActivateZombiesRandomly
	pusha
	mov bx, 1
	mov dx, ZombieSpawnRate
	call RandomByCsWord
	cmp ax, 1
	jnz @@DoNotActivate
	call FindAndActivate
@@DoNotActivate:
	
	
	popa
	ret
endp ActivateZombiesRandomly

;Description: this procedure shows the player's score in the bottom right corner of the screen
proc ShowScore
	pusha
	mov ah, 2
	mov bh, 0
	mov dh, 24 ; line number
	mov dl, 34; column number
	int 10h
	
	mov ah, 9
	mov dx, offset EraseScoreText
	int 21h
	
	mov ah, 2
	mov bh, 0
	mov dh, 24 ; line number
	mov dl, 34; column number
	int 10h
	
	mov ax, [word PlayerScore]
	call printAxDec
	
	popa
	
	ret
endp ShowScore


;Description: This procedure displys the score in the middle of the screen
proc DisplayFinalScore

	pusha
	mov ah, 2
	mov bh, 0
	mov dh, 17 ; line number
	mov dl, 7; column number
	int 10h
	
	mov ah, 9
	mov dx, offset FinalScoreText
	int 21h
	

	
	mov ax, [word PlayerScore]
	call printAxDec
	popa
	ret
endp DisplayFinalScore

;Description: This procedure finds a free zombie and activates it
proc FindAndActivate
	pusha
	
	mov cx, NumberOfZombies
	xor di, di
@@FindNext:
	mov bx, [ZombieOffsetArray + di]
	cmp [byte bx], 0
	jz @@AlreadyActive
	push bx
	call ActivateZmbRnd
	jmp @@Found
@@AlreadyActive:
	add di, 2
	loop @@FindNext
@@Found:
	
	popa
	ret
endp FindAndActivate

;Description: Displays Main Menu Bmp on screen
proc DisplayMainMenu
	pusha
	;DX = offset FileName, BmpLeft = X position on screen(0 - 319), BmpTop = Y position on screen(0 - 200), BmpColSize = Length ,BmpRowSize = Hight
	mov [word BmpTop], 0
	mov [word BmpLeft], 0
	mov [word BmpColSize], 320
	mov [word BmpRowSize], 200
	mov dx, offset MainMenuBMP
	call OpenShowBmp
	popa
	ret
endp DisplayMainMenu

;Description: Displays The game Over Screen
proc DisplayGameOver
	pusha
	
	mov [word BmpTop], 0
	mov [word BmpLeft], 0
	mov [word BmpColSize], 320
	mov [word BmpRowSize], 200
	mov dx, offset GameOverBMP
	call OpenShowBmp
	
	popa
	ret
endp DisplayGameOver

;Description: This procedure waits for enter key (works with defult interupt
proc WaitForEnter
	pusha
	
@@WaitForEnter:
	mov ah, 0
	int 16h
	
	cmp ah, 01ch
	jz @@EnterWasEntered
	jmp @@WaitForEnter
	
@@EnterWasEntered:
	
	
	popa
	ret
endp WaitForEnter

;Description: Clears Screen
proc ClearScreen
	pusha
	
	mov ax, 3h
	int 10h
	
	call SetGraphic
	
	popa
	ret
endp ClearScreen

;Description: Displays Knight HP in the bottom left of the screen
proc DisplayKHP
	pusha
	mov ah, 2
	mov bh, 0
	mov dh, 24 ; line number
	mov dl, 0; column number
	int 10h
	
	mov ah, 9
	mov dx, offset EraseScoreText
	int 21h
	
	mov ah, 2
	mov bh, 0
	mov dh, 24 ; line number
	mov dl, 0; column number
	int 10h
	
	
	
	mov ax, [word KnightHP]
	call printAxDec
	
	
	
	popa
	ret
endp DisplayKHP

;Description: Draws Zombie
;Input: through stack 1.offset zombie
proc DrawZombie
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	cmp [byte bx], 0
	jnz @@endproc
	
	cmp [byte bx + 10], ZombieAnimationSpeed
	ja @@NotFirstFrame
	cmp [byte bx + 11], 0
	jnz @@LeftFrame1
	;RightFrame1
	mov [word matrix], offset ZMBWR1Matrix
	jmp @@PictureSelected
@@LeftFrame1:
	mov [word matrix], offset ZMBWL1Matrix
	jmp @@PictureSelected
@@NotFirstFrame:
	cmp [byte bx + 11], 0
	jnz @@LeftFrame2
	;RightFrame2
	mov [word matrix], offset ZMBWR2Matrix
	jmp @@PictureSelected
@@LeftFrame2:
	mov [word matrix], offset ZMBWL2Matrix
	jmp @@PictureSelected
	
	
@@PictureSelected:

	inc [byte bx + 10];inc for next time this zombie is drawn
	
	cmp [byte bx + 10], ZombieAnimationSpeed * 2;if the counter is above 1(there are 2 pictures)
	jna @@FrameNumberOk
	
	mov [byte bx + 10], 0
	
@@FrameNumberOk:

	sub sp, 2
	push [word bx + 1];push x
	push [word bx + 3];push y
	call XYToMemory
	pop di
	
	
	sub sp, 2
	push ZombiLength
	call RemoveFixedDecimalPoint
	pop dx
	
	sub sp, 2
	push ZombiHeight
	call RemoveFixedDecimalPoint
	pop cx
	
	call HideCurser
	call putMatrixInScreen
	call ShowCurser
	
@@endproc:
	popa
	pop bp
	ret 2
endp DrawZombie

;Description: This procedure sets zombie x to add and y to add
;Input: Through stack: 1. Offset Zombie
proc SetZombieBehavior
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	sub sp, 4
	
	push [word bx + 1]
	push [word bx + 3]
	
	
	push [word XPlayer]
	push [word YPlayer]
	
	push [word ZMBSPEED]
	
	call XYtoAdd2DotsWithNeg
	
	pop [word bx + 5]
	pop [word bx + 7]
	
	popa
	pop bp
	ret 2
endp SetZombieBehavior

;Description: Erase A Zombie from screen
;Input: Through Stack 1.Zombie Offset
proc UndrawZombie
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	push [word bx + 1]

	push [word bx + 3]

	push ZombiLength

	push ZombiHeight
	
	call PutBackgroundInSpot

	
	popa
	pop bp
	ret 2
endp UndrawZombie

;Description: Go over zombie array and update them
proc CheckandUpdateallZombies
	pusha
	mov cx, NumberOfZombies
	
	xor di, di
	
@@loopUpdate:
	push [word ZombieOffsetArray + di]
	call UpdateZombie
	add di, 2
	loop @@loopUpdate
	
	popa
	ret
endp CheckandUpdateallZombies

;Description: Update a Specific Zombie
proc UpdateZombie
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	cmp [byte bx], 1
	jz @@endproc
	
	cmp [byte bx + 9], 0;if Zombie Has HP
	jnz @@Alive;You have to make sure that the hp is 0 when enemy is killed not lower (signed)
	mov [byte bx], 1;Update to "dead"
	dec [ActiveZombieCounter]
	push bx
	call UndrawZombie
	inc [word PlayerScore]
	pusha
	mov ax, [PlayerScore]
	xor dx, dx
	mov bx, AmountOfZombiesKilledForSpeedInc
	div bx
	cmp dx, 0
	jnz @@NoIncrease
	add [ZMBSPEED], ZMBSpeedInc
@@NoIncrease:
	popa
	Call ShowScore
	jmp @@endproc
@@Alive:

	push bx
	call UndrawZombie
	
	inc [word bx + 12]
	cmp [word bx + 12], ZMBBehaviorRefreshRate
	jb @@BehaviorOK
	mov [word bx + 12], 0
	push bx
	call SetZombieBehavior
	
@@BehaviorOK:
	
	

	push bx
	call MoveZombie
	
;Update Melee Attack CoolDown
	cmp [byte bx + 14], 0
	jz @@NotOnCoolDown
	
	inc [word bx + 15]
	
	cmp [word bx + 15], ZMBMeleeAttackCoolDown
	jnz @@StillOnCoolDown
	mov [byte bx + 14], 0
	mov [word bx + 15], 0
@@StillOnCoolDown:
	
@@NotOnCoolDown:

	sub sp, 2;Check Colision
	push [word bx + 1]
	push [word bx + 3]
	push ZombiLength
	push ZombiHeight
	push [XPlayer]
	push [YPlayer]
	push PLAYERLENGTH
	push PLAYERHIGHT
	call CheckCollision
	
	
	

	pop dx
	cmp dx, 1
	jz @@NoCollision;No Colision
	cmp [byte bx + 14], 1
	jz @@NoDealDamage;Zombie can't attack
	cmp [byte KAbleToBeHit], 1
	jz @@NoDealDamage
	
	
	
;Zombi attack Knight
	sub [word KnightHP], ZombieMeleeAttackDamage
	jnc @@NotDead
	mov [word KnightHP], 0
@@NotDead:
	
	call DisplayKHP
	mov [byte bx + 14], 1
	mov [word bx + 15], 0
	
@@NoDealDamage:
	push bx
	call ZMBMoveBack
@@NoCollision:
	
	
	cmp [byte bx + 5], 0;Choosing what picture
	jg @@ZombieGoingRight
	;Zombie going left
	mov [byte bx + 11], 1;left picture
	jmp @@SideChosen
@@ZombieGoingRight:
	mov [byte bx + 11], 0;right picture
	jmp @@SideChosen
@@SideChosen:
	push bx
	call DrawZombie
	
@@endproc:
	popa
	pop bp
	ret 2
endp UpdateZombie

;Description: Makes Zombie go one step back
;Input: Through stack: 1. offset Zombie
proc ZMBMoveBack
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	neg [word bx + 5]
	neg [word bx + 7]
	push bx
	call MoveZombie
	
	neg [word bx + 5]
	neg [word bx + 7]
	
	popa
	pop bp
	ret 2
endp ZMBMoveBack

;Description: Moves a Zombie
;Input: Through stack: 1.offset Zombie
proc MoveZombie
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	mov cx, [bx+ 5]
	
	add [word bx + 1], cx
	cmp [word bx + 1], 0
	jnle @@NotHitLeftWall
	mov [word bx + 1], 0
@@NotHitLeftWall:

	mov cx, [bx + 1]
	add cx, ZombiLength
	cmp cx, MaxBoardLength
	jnge @@NotHitRightWall
	mov [word bx + 1], MaxBoardLength - ZombiLength
@@NotHitRightWall:

	mov cx, [bx + 7]
	
	add [word bx + 3], cx
	cmp [word bx + 3], 0
	jnle @@NotHitUpperWall
	mov [word bx + 3], 0
@@NotHitUpperWall:
	
	mov cx, [bx + 3]
	
	add cx, ZombiHeight
	
	cmp cx, MaxBoardHeight
	jnge @@NotHitLowerWall
	mov [word bx + 3], MaxBoardHeight - ZombiHeight
@@NotHitLowerWall:
	
	popa
	pop bp
	ret 2
endp MoveZombie

;Description: Activates a Zombi to a random place
;Input: through stack 1. offset zombi
proc ActivateZmbRnd
	push bp
	mov bp, sp
	pusha
	
	
	mov bx, [bp + 4]
	
	mov [byte bx], 0
	
	mov cx, MaxBoardLength / 2; cx - > Half of the length of the map
	mov dx, MaxBoardHeight / 2; dx - > Half of the Height of the map
	
	mov bl, 1
	mov bh, 4
	call RandomByCs
	
	mov bx, [bp + 4]
	
	cmp al, 1
	jz @@zmbStartRight
	cmp al, 2
	jz @@zmbStartLeft
	cmp al, 3
	jz @@zmbStartUp
	cmp al, 4
	jz @@zmbStartDown
	jmp @@XYAreSet
	
	
@@zmbStartDown:;Zombi starts down
	mov [word bx + 1], cx
	
	mov [word bx + 3], MaxBoardHeight - ZombiHeight
	
	jmp @@XYAreSet
@@zmbStartUp:;Zombi starts up
	mov [word bx + 1], cx
	
	mov [word bx + 3], 0
	
	
	
	jmp @@XYAreSet
@@zmbStartLeft:;Zombi starts Left
	
	mov [word bx + 1], 0
	
	mov [word bx + 3], dx
	
	
	jmp @@XYAreSet
@@zmbStartRight:;Zombi starts Right
	
	mov [word bx + 3], dx
	
	mov [word bx + 1], MaxBoardLength - ZombiLength
	
	jmp @@XYAreSet
	
@@XYAreSet:

	mov [byte bx + 9], ZombieHP;Restore hp
	
	push bx
	call SetZombieBehavior
	
	inc [byte ActiveZombieCounter]
	
	
	popa
	pop bp
	ret 2
endp ActivateZmbRnd



;Description: Updates bool (KCanShoot) after a constant number of cycles (KShootCycleCoolDown) by comparing KShootCoolDown Variable
proc UpdateShootCoolDown
	cmp [byte KCanShoot], 0
	jz @@endproc
	inc [byte KShootCoolDown]
	cmp [byte KShootCoolDown], KShootCycleCoolDown
	jnz @@endproc
	mov [byte KCanShoot], 0
	mov [byte KShootCoolDown], 0
@@endproc:
	ret
endp UpdateShootCoolDown



proc ShowCurser
	pusha
	mov ax, 1
	int 33h
	popa
	ret
endp ShowCurser

proc HideCurser
	pusha
	mov ax, 2
	int 33h
	popa
	ret
endp HideCurser

proc SetAsyncMouse
	pusha
	mov ax, seg MouseHandle 
	mov es, ax
	mov dx, offset MouseHandle   ; ES:DX ->Far routine
    mov ax,0Ch             ; interrupt number
    mov cx,02h
    int 33h
	popa
	ret
endp SetAsyncMouse

proc MouseHandle far
	pusha
	cmp [byte KCanShoot], 0;Check if shot is on cooldown
	jnz @@endproc
	cmp [byte KRolling], 1;Check if knight is rolling
	jnz @@endproc
	mov cx, BulletArrayLength
	xor di, di
@@FindAndActivate:
	mov bx, [BulletOffsetArray + di]
	add di, 2
	cmp [byte bx], 1
	
	jnz @@ActivatedAlready
	mov si, bx
	mov ax, 3
	
	int 33h
	
	shl cx, 3;fixed decimal
	shl dx, 4;fixed decimal
	
	
	mov ax, [XPlayer]
	add ax, PLAYERLENGTH / 2
	sub ax, 20h
	push ax
	
	mov ax, [YPlayer]
	add ax, PLAYERHIGHT / 2
	sub ax, 20h
	push ax
	
	push cx
	
	push dx
	
	push si
	
	call ActivateBullet
	jmp @@FoundUnactiveBullet
@@ActivatedAlready:
	loop @@FindAndActivate
	jmp @@NotFoundUnactiveBullet
@@FoundUnactiveBullet:
	mov [KCanShoot], 1;put on cooldown
	jmp @@endproc
@@NotFoundUnactiveBullet:
	
	
	
@@endproc:
	
	popa
	retf
endp MouseHandle

;Input:1.Offset Bullet
proc DrawBullet
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	cmp [byte bx], 0
	jnz @@endproc
	
	sub sp, 2
	push [Word bx + 1]
	push [Word bx + 3]
	call XYToMemory
	
	pop di
	
	mov [word matrix], offset BulletDrawArray
	mov dx, BULLETLENGTH
	shr dx, 4
	mov cx, BULLETHEIGHT
	shr cx, 4
	
	call putMatrixInScreen
	
	;1. DX = Line Length, CX = Amount of Lines, Variable matrix = Offset of the matrix you want to print, DI = Location to Print on screen(0 - 64,000)
@@endproc:
	popa
	pop bp
	ret 2
endp DrawBullet

;input stack 1. offset bullet
proc UndrawBullet
	push bp
	mov bp, sp
	pusha
	
	
	
	mov bx, [bp + 4]
	push [word bx + 1]
	push [word bx + 3]
	push BULLETLENGTH
	push BULLETHEIGHT
	call PutBackgroundInSpot
	
	
	popa
	pop bp
	ret 2
endp UndrawBullet

;Procedures for bullet "class"
proc Update_activated_Bullets
	push bx
	push cx
	push si
	
	mov cx, BulletArrayLength
	xor si, si
@@UpdateIfActivated:
	mov bx, [BulletOffsetArray + si]
	cmp [byte bx], 0
	jnz @@NotActive
	push bx
	call UndrawBullet
	push bx
	call MoveBullet
	
	push bx 
	call CheckBulletHitZombies;Bullets and Zombie;********************************
	
	push bx
	call DrawBullet
@@NotActive:
	add si, 2
	loop @@UpdateIfActivated
	
	pop si
	pop cx
	pop bx
	ret
endp Update_activated_Bullets

;Input: 1.offset bullet
proc MoveBullet
	push bp
	mov bp, sp
	push bx
	push cx
	
	
	mov bx, [word bp + 4]
	
	
	mov cx, [word bx + 5]
	add [word bx + 1], cx;add x
	cmp [word bx + 1], 0h
	jnle @@NotHitLeftWall
	mov [byte bx], 1;bullet hit left wall
	
	mov [word bx + 1], 0
	
	push bx
	call UndrawBullet
	
	dec [ActiveBulletCounter]
	
	mov [KNeedDraw], 0
	
	jmp @@EndProc
@@NotHitLeftWall:

	mov cx, [word bx + 1]
	add cx, BULLETHEIGHT
	
	cmp cx, MaxBoardLength
	jnae @@NotHitRightWall
	
	mov [byte bx], 1;bullet hit right wall
	mov [word bx + 1], MaxBoardLength - BULLETLENGTH
	
	push bx
	call UndrawBullet
	
	dec [ActiveBulletCounter]
	
	mov [KNeedDraw], 0
	
	jmp @@EndProc
@@NotHitRightWall:

	
	
	mov cx, [word bx + 7]
	add [bx + 3], cx;add y
	
	cmp [word bx + 3], 0
	jnle @@NotHitUpperWall
	mov [byte bx], 1;bullet hit upper wall
	mov [word bx + 3], 0
	push bx
	call UndrawBullet
	dec [ActiveBulletCounter]
	mov [KNeedDraw], 0
	jmp @@EndProc
@@NotHitUpperWall:
	
	mov cx, [word bx + 3]
	add cx, BULLETHEIGHT
	cmp cx, MaxBoardHeight
	jnae @@NotHitLowerWall
	
	mov [byte bx], 1;bullet hit lower wall
	mov [word bx + 3], MaxBoardHeight - BULLETHEIGHT
	
	push bx
	call UndrawBullet
	
	dec [ActiveBulletCounter]
	
	mov [KNeedDraw], 0
	jmp @@EndProc
@@NotHitLowerWall:


@@EndProc:
	
	pop cx
	pop bx
	pop bp
	ret 2
endp MoveBullet

;Description: Checks of a bullet hit any Zombies
;Input: Through stack: 1. offset Bullet
proc CheckBulletHitZombies
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	xor di, di
	
	mov cx, NumberOfZombies
@@NextZombie:
	
	mov si, [word ZombieOffsetArray + di]
	
	cmp [byte si], 0
	jnz @@ZombieDead
	
	sub sp, 2
	push [word si + 1]
	push [word si + 3]
	push ZombiLength
	push ZombiHeight
	push [word bx + 1]
	push [word bx + 3]
	push BULLETLENGTH
	push BULLETHEIGHT
	call CheckCollision
	pop ax
	;Right Now ax has a bool that tells if the bullet hit the zombies
	cmp ax, 0
	jnz @@NoCollision
	push bx
	push si
	call KnightShotZombie
	
@@NoCollision:
	
@@ZombieDead:
	
	add di, 2
	loop @@NextZombie
	
	popa
	pop bp
	ret 2
endp CheckBulletHitZombies

;Description: Knight shot a Zombie, this procedure makes the nececary changes to the bullets and the Zombies properties
;Input:Through stack 1.Bullet offset(bp + 6) 2.Zombie offset(bp + 4)
proc KnightShotZombie
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	
	mov di, [bp + 6]
	
	sub [byte bx + 9], BulletDamage
	jnc @@NotKill
	mov [byte bx + 9], 0
	
@@NotKill:
	mov [byte di], 1
	dec [ActiveBulletCounter]
	push di
	call UndrawBullet
	
	popa
	pop bp
	ret 4
endp KnightShotZombie


;Description: checks if 2 rectangles are in collision
;Input: Through stack: 1.sub sp, 2 (make room for returning value)(bp + 20) 2.X1 (bp + 18) 3.Y1(bp + 16) 4. 1Length (bp + 14) 5.1Height (bp + 12) 6.X2 (bp + 10) 7.Y2 (bp + 8) 8.2Length (bp + 6) 9.2Height (bp + 4]
;Output: Through stack 1.bool - are coliding
;Requirements: Make room in stack sub sp, 2
proc CheckCollision
	push bp
	mov bp, sp
	pusha
	
	mov cx, [bp+ 18]; cx -> x1
	
	mov si, [bp + 16]; si -> y1 
	
	mov dx, [bp + 10]; dx -> x2
	
	mov di, [bp + 8]; di -> y2
	
	
	add cx, [bp + 14]; cx -> x1end
	
	cmp cx, dx
	jb @@NotColide
	
	sub cx, [bp + 14]; cx -> x1
	
	add dx, [bp + 6]; dx -> x2end
	
	cmp cx, dx
	ja @@NotColide
	
	add si, [bp + 12] ; si -> y1end
	
	cmp si, di
	
	jb @@NotColide
	
	sub si, [bp + 12] ; si -> y1
	
	add di, [bp + 4] ; di -> y2end
	
	cmp si, di
	ja @@NotColide
	
;The rectangels colide
	
	mov [word bp + 20], 0
	
	jmp @@endproc
	
@@NotColide:
	
	mov [word bp + 20], 1
	
	jmp @@endproc

@@endproc:
	popa
	pop bp
	ret 16
endp CheckCollision

;Description: Activates an unactivated bullet
;Input: 1.XStart[bp + 12] 2.YStart[bp + 10] 3.XTarget[bp + 8] 4.YTarget[bp + 6] 5.Bullet offset[bp + 4]
;Output: Changes Bullets attributes
proc ActivateBullet
	push bp
	mov bp, sp
	
	push bx
	push cx
	push dx
	push di
	push si
	
	mov bx, [bp + 4];Bx -> offset Bullet
	
	mov [byte bx], 0
	
	mov cx, [bp + 12]
	mov [word bx + 1], cx
	
	mov si, [bp + 10]
	mov [word bx + 3], si
	
	sub sp, 4
	push [word bx + 1]
	push [word bx + 3]
	push [word bp + 8]
	push [word bp + 6]
	push BulletSpeed
	call XYtoAdd2DotsWithNeg
	
	pop [word bx + 5]
	pop [word bx + 7]
	
	
	inc [ActiveBulletCounter]
	
	push bx
	call MoveBullet
	
	cmp [byte bx], 1
	jz @@BulletDead
	
	push bx
	call MoveBullet
	
	cmp [byte bx], 1
	jz @@BulletDead
	
	push bx
	call MoveBullet
	
	cmp [byte bx], 1
	jz @@BulletDead
	
	push bx
	call MoveBullet

@@BulletDead:	
	

	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop bp
	ret 10
endp ActivateBullet




;Description: Delays game
proc LoopDelay
	pusha
	
	mov cx ,90
	
@@Self1:
	push cx
	mov cx, 3000
	sub cx, dx
@@Self2:
	loop @@Self2
	pop cx
	loop @@Self1
	popa
	ret
endp LoopDelay






proc printAxDec  
	   
       push bx
	   push dx
	   push cx
	           	   
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_next_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_next_to_stack

	   cmp ax,0
	   jz pop_next_from_stack  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next_from_stack: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next_from_stack

	   pop cx
	   pop dx
	   pop bx
	   
       ret
endp printAxDec







;Description:Makes Keyboard Async
;Input: none
;Output: none
proc SetAsyncKeyboard
	push es
	push cx
	push dx
	push ax
	push si
	
	xor ax, ax
	mov es, ax
	
	mov si, KeyboardInterruptPosition
	
	mov dx, [es:si]
	mov cx, [es:si+2]
	
	mov [oldintruptoffset], dx
	mov [oldintruptsegment], cx
	
	cli
	mov ax, offset Keyboard_handler
	mov [word es:si], ax
	mov ax, cs
	mov [word es:si + 2], ax
	sti
	
	pop si
	pop ax
	pop dx
	pop cx
	pop es
	ret
endp SetAsyncKeyboard

;Description: Makes Keyboard interrupt (int 9h) back to defult
;******************DID NOT CHECK***********************************
proc RestoreKeyboardInt
	push es
	push cx
	push dx
	push ax
	push si
	
	xor ax, ax
	mov es, ax
	
	mov si, KeyboardInterruptPosition
	
	mov dx, [oldintruptoffset]
	mov cx, [oldintruptsegment]
	
	cli
	mov [word es:si], dx
	mov [word es:si + 2], cx
	sti
	
	pop si
	pop ax
	pop dx
	pop cx
	pop es
	ret
endp RestoreKeyboardInt


;Description: This procedure is the procedure that happens when key is pressed (int 9h)
;Input: a key from the port
;Output: calls the relevant procedure based on key
proc Keyboard_handler near
    push ax
    push bx
    push cx
    push dx                                          
    push sp
    push bp
    push si
    push di


    ; Gets the pressed key and stores it in [key]
    in al, 60h         
    mov [byte key], al

    mov al, 20h
    out 20h, al
	
	cmp [byte key], 11h
	jnz @@NotW
	mov [WPressed], 0
	jmp @@endproc
@@NotW:

	cmp [byte key], 91h
	jnz @@NotWR
	mov [WPressed], 1
	jmp @@endproc
@@NotWR:

	cmp [byte key], 01fh
	jnz @@NotS
	mov [SPressed], 0
	jmp @@endproc
@@NotS:
	
	cmp [byte key], 09fh
	jnz @@NotSR
	mov [SPressed], 1
	jmp @@endproc
@@NotSR:
	
	cmp [byte key], 1eh
	jnz @@NotA
	mov [APressed], 0
	jmp @@endproc
@@NotA:

	cmp [byte key], 9eh
	jnz @@NotAR
	mov [APressed], 1
	jmp @@endproc
@@NotAR:

	cmp [byte key], 20h
	jnz @@NotD
	mov [DPressed], 0
	jmp @@endproc
@@NotD:

	cmp [byte key], 0a0h
	jnz @@NotDR
	mov [DPressed], 1
	jmp @@endproc
@@NotDR:
	
	cmp [byte key], 1
	jnz @@NotESC
	mov [GameOn], 1
@@NotESC:
	
	cmp [byte key], 39h
	jnz @@NotSpace
	mov [byte SpacePressed], 0
@@NotSpace:

	cmp [byte key], 0b9h
	jnz @@SpaceNotReleased
	
	mov [byte SpacePressed], 1
@@SpaceNotReleased:
	
@@endproc:
    pop di
    pop si
    pop bp
    pop sp
    pop dx
    pop cx
    pop bx
    pop ax    
    IRET
endp Keyboard_handler


;Description: Moves Knight Up
proc KMoveUp
	push bx
	mov bx, [YPlayer]
	sub bx, KNIGHTLENGTHTRAVEL
	jnc @@Moved
	mov bx, 0
@@Moved:
	mov [YPlayer], bx
@@endproc:
	pop bx
	ret
endp KMoveUp

proc KMoveDown
	push bx
	mov bx, [YPlayer]
	add bx, PLAYERHIGHT
	add bx, KNIGHTLENGTHTRAVEL
	cmp bx, MaxBoardHeight
	jna @@Moved
	mov bx, MaxBoardHeight
@@Moved:
	sub bx, PLAYERHIGHT
	mov [YPlayer], bx
@@endproc:
	pop bx
	ret
endp KMoveDown

proc KMoveRight
	push bx
	
	mov bx, [XPlayer]
	add bx, PLAYERLENGTH
	add bx, KNIGHTLENGTHTRAVEL
	cmp bx, MaxBoardLength
	jna @@Moved
	mov bx, MaxBoardLength
@@Moved:
	sub bx, PLAYERLENGTH
	mov [XPlayer], bx
@@endproc:
	pop bx
	ret
endp KMoveRight

proc KMoveLeft
	push bx
	mov bx, [XPlayer]
	sub bx, KNIGHTLENGTHTRAVEL
	jnc @@Moved
	mov bx, 0
@@Moved:
	mov [XPlayer], bx
@@endproc:
	pop bx
	ret
endp KMoveLeft

proc CheckKeys
	push ax
	push dx
	push cx
	push di
	
	cmp [KCanMove], 0;Check knight able to move
	jnz @@CantMove
	
	
	cmp [byte SpacePressed], 0
	jnz @@SpaceNotPressed
	
	call StartRoll
	
@@SpaceNotPressed:
	
	cmp [APressed], 0
	jnz @@ANotpressed
	
	
	mov [KNeedDraw], 0
	
	call KMoveLeft
@@ANotpressed:
	
	
	cmp [DPressed], 0
	jnz @@DNotpressed
	
	mov [KNeedDraw], 0

	call KMoveRight
@@DNotpressed:


	cmp [SPressed], 0
	jnz @@SNotpressed
	
	mov [KNeedDraw], 0
	
	call KMoveDown
@@SNotpressed:

	cmp [WPressed], 0
	jnz @@WNotpressed
	
	
	
	mov [KNeedDraw], 0

	
	call KMoveUp
@@WNotpressed:
@@CantMove:
	cmp [KNeedDraw], 0
	jnz @@NoDraw
	call UndrawKnight
	call DrawKnight
	
@@NoDraw:
	mov [KNeedDraw], 1
	

	
	
	pop di
	pop cx
	pop dx
	pop ax
	ret
endp CheckKeys

;Description: Draws Knight
;Input: Input in the Knight variables
;Output: On screen
proc DrawKnight
	pusha
	
	
	cmp [FrameNumber], 0
	jnz @@NotFrame1
	
	cmp [byte KRolling], 0
	jnz @@NotRolling1
	mov [word matrix], offset KnightRoll2Matrix
	jmp @@PrintKnight
@@NotRolling1:	
	
	
	
	mov [word matrix], offset KnightDefultMatrix
	
	jmp @@FrameNumberOk
	
@@NotFrame1:
	
	cmp [FrameNumber], 1
	jnz @@NotFrame2
	
	
	cmp [byte KRolling], 0
	jnz @@NotRolling2
	mov [word matrix], offset KnightRoll2Matrix
	jmp @@PrintKnight
@@NotRolling2:


	mov [word matrix], offset KnightWalk1Matrix
	jmp @@FrameNumberOk
@@NotFrame2:

	cmp [FrameNumber], 2
	jnz @@NotFrame3
	
	
	cmp [byte KRolling], 0
	jnz @@NotRolling3
	mov [word matrix], offset KnightRoll3Matrix
	jmp @@PrintKnight
@@NotRolling3:
	
	
	mov [word matrix], offset KnightWalk2Matrix
	jmp @@FrameNumberOk
@@NotFrame3:

@@FrameNumberOk:
	inc [byte KnightWalkFrameChangeCounter]
	cmp [byte KnightWalkFrameChangeCounter], KnightFrameChangeRate
	jnz @@PrintKnight
	mov [byte KnightWalkFrameChangeCounter], 0
	inc [FrameNumber];inc for next time this draws
	
	cmp [FrameNumber], 2;if the counter is above 2(there are 3 pictures)
	jna @@PrintKnight
	
	mov [FrameNumber], 0
@@PrintKnight:


	sub sp, 2
	push PLAYERLENGTH
	call RemoveFixedDecimalPoint
	pop dx
	
	sub sp, 2
	push PLAYERHIGHT
	call RemoveFixedDecimalPoint
	pop cx
	
	sub sp, 2
	push [word XPlayer]
	push [word YPlayer]
	call XYToMemory
	pop di
	
	
	call HideCurser
	call putMatrixInScreen
	call ShowCurser
	
@@EndProc:
	
	popa
	ret
endp DrawKnight



;Description: Undraw Knight From His last position (LastXPlayer, LastYPlayer)
;Input: Input in the Knight variables
;Output: On screem
proc UndrawKnight
	
	
	push [LastXPlayer]
	push [LastYPlayer]
	push PLAYERLENGTH
	push PLAYERHIGHT
	call PutBackgroundInSpot
	
	
	
	ret
endp UndrawKnight



;Description:Gets a number with a fixed decimal point and returns the number rounded without the fixed decimal point
;Input: Through stack 1.number
;output: Through stack 1.number
;Requirements: make room in stack for output (sub sp, 2)
proc RemoveFixedDecimalPoint
	push bp
	mov bp, sp
	push bx
	
	mov bx, [word bp + 4]
	add bx, 1000b
	shr bx, 4
	mov [word bp + 6], bx
	
	pop bx
	pop bp
	ret 2
endp RemoveFixedDecimalPoint


;Description: Turns X(0- 5119) and Y(0-3199) to the place in the memory (0- 63,999)
;Input: 2 parameters from stack in this order 1.X 2.Y
;Output: in stack
;Requirements: make room in stack before calling and pushing parameters(sub sp, 4).
proc XYToMemory
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	

	add [word bp + 4], 1000b

	add [word bp + 6], 1000b

	
	SHR [word bp + 4], 4
	
	SHR [word bp + 6], 4

	xor dx, dx
	mov bx, 320
	mov ax, [bp + 4]
	mul bx
	add ax, [bp + 6]
	mov [bp + 8], ax
	pop dx
	pop bx
	pop ax
	pop bp
	ret 4
endp XYToMemory



;Description: Calculates the square root of a 32 - bit number
;Input: through Stack in this order: 1.High Order word 2.Low Order word
;Output: 16 bit through Stack
;Requirements: Make room for returning value in stack (sub sp, 2)
proc Sqrt
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push di
	push si
	push dx
	
	cmp [word bp + 4], 1
	ja @@Not1
	cmp [word bp + 6], 0
	jnz @@Not1
	mov ax, [bp + 4]
	mov [bp + 8], ax
	jmp @@EndOfProc
@@Not1:
	mov bx, [bp + 4]
	mov si, [bp + 6]
	shr bx, 1
	shr si, 1
	jnc @@NoCarry1
	or bx, 1000000000000000b
@@NoCarry1:
	mov ax, [bp + 4]
	mov dx, [bp + 6]
	div bx
	mov di, si
	add ax, bx
	jnc @@NoCarry2
	inc di
@@NoCarry2:
	shr ax, 1
	shr di, 1
	jnc @@NoCarry3
	or ax, 1000000000000000b
@@NoCarry3:
	mov cx, ax
	
	
	@@WhileLoop:
	cmp di, si
	ja @@EndOfLoop
	jb @@NoEndOfLoop
	cmp cx, bx
	jae @@EndOfLoop
@@NoEndOfLoop:
	mov bx, cx
	mov si, di
	mov ax, [bp + 4]
	mov dx, [bp + 6]
	div bx
	mov di, si
	add ax, bx
	jnc @@NoCarry4
	inc di
@@NoCarry4:
	shr ax, 1
	shr di, 1
	jnc @@NoCarry5
	or ax, 1000000000000000b
@@NoCarry5:
	mov cx, ax
	jmp @@WhileLoop

@@EndOfLoop:
	mov [bp + 8], bx
@@EndOfProc:
	pop dx
	pop si
	pop di
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp Sqrt


;Description: Finds the x and y need to add to get to a target point
;Input: Through Stack: 1.XStart [bp + 12]  2. YStart [bp + 10] 3. XTagrget[bp + 8] 4. YTarget[bp + 6] 5. speed[bp + 4]
;Output: Through Stack: 1.X 2.Y
;Requirements: 1.Make room in stack before (sub sp, 4)
proc XYtoAdd2Dots
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	push cx
	push di
	push si
	
	mov bx, [bp + 8]
	sub bx, [bp + 12]
	;bx -> XTarget - XStart
	
	
	mov di, [bp + 6]
	sub di, [bp + 10]
	;di -> YTarget - YStart
	
	mov ax, bx
	mul ax
;Fixed Decimal point Correction
	mov cx, 4
@@loopToShiftRight1:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX1
	or ax, 1000000000000000b
@@NoCarryInDX1:
	loop @@loopToShiftRight1
	push dx;save answer
	push ax;save answer
	
	mov ax, di
	mul ax
;Fixed Decimal point Correction
	mov cx, 4
@@loopToShiftRight2:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX2
	or ax, 1000000000000000b
@@NoCarryInDX2:
	loop @@loopToShiftRight2
	
	pop si
	add ax, si
	jnc @@NoCarry1
	inc dx
@@NoCarry1:
	pop cx
	add dx, cx
	
	sub sp, 2
	push dx
	push ax
	call Sqrt
	pop cx
	shl cx, 2
	
	cmp cx, 0
	jnz @@DenominatorIsNotZero;If the Denominator is zero i just make a recursive call to a target with and x bigger by 1
	;1.XStart [bp + 12]  2. YStart [bp + 10] 3. XTagrget[bp + 8] 4. YTarget[bp + 6] 5. speed[bp + 4]
	sub sp, 4
	push [word bp + 12]
	push [word bp + 10]
	mov ax, [bp + 8]
	inc ax
	push ax
	push [word bp + 6]
	push [word bp + 4]
	call XYtoAdd2Dots
	pop [word bp + 14]
	pop [word bp + 16]
	jmp @@EndProc
	
@@DenominatorIsNotZero:
	
	mov ax, [bp + 4]
	mul bx
	push cx
	mov cx, 4
	@@loopToShiftRight3:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX3
	or ax, 1000000000000000b
@@NoCarryInDX3:
	loop @@loopToShiftRight3
	pop cx
	div cx
	
	shl ax, 4;Fixed Decimal Point
	push ax;save
	
	Shl dx, 4;Sheerit
	mov ax, dx
	xor dx, dx
	div cx
	pop dx
	add ax, dx
	mov [bp + 14], ax
	
	mov ax, [bp + 4]
	mul di
	push cx
	mov cx, 4
	@@loopToShiftRight4:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX4
	or ax, 1000000000000000b
@@NoCarryInDX4:
	loop @@loopToShiftRight4
	pop cx
	div cx
	
	shl ax, 4;Fixed Decimal Point
	push ax;save
	
	Shl dx, 4;Sheerit
	mov ax, dx
	xor dx, dx
	div cx
	pop dx
	add ax, dx
	mov [bp + 16], ax
@@EndProc:
	
	pop si
	pop di
	pop cx
	pop dx
	pop bx
	pop ax
	pop bp
	ret 10
endp XYtoAdd2Dots
;Description; this procedure activates XYtoAdd2Dots and includes the case that the X or Y target are smaller
;Input: Through stack: 1. Make room in stack for Output (sub sp, 4)(x- bp + 14 y - bp + 16) 2.XStart(bp + 12) 3.YStart(bp + 10) 4.XTarget(bp + 8) 5.YTarget(bp + 6) 6.Speed (bp + 4)
;Output: Through stack: 1. XToAdd 2.YToAdd
;Requirements; make room in stack before (sub sp, 4)
proc XYtoAdd2DotsWithNeg
	push bp
	mov bp, sp
	pusha
	
	mov dx, [bp + 12];dx -> X start
	
	mov di, [bp + 10];di -> Y start
	
	mov cx, [bp + 8];cx -> X Target
	
	mov si, [bp + 6];si -> Y Target
	
	cmp di, si
	ja @@TargetIsAbove
;TargetIsBleow
	cmp cx, dx
	ja @@TargetIsRight1
;Target Is Left Below
	sub sp, 4
	push cx
	push di
	push dx
	push si
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	neg dx
	pop di
	
	jmp @@XYAreSet
	
@@TargetIsRight1:
;Target Is Right Below
	sub sp, 4
	push dx
	push di
	push cx
	push si
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	pop di

	jmp @@XYAreSet
@@TargetIsAbove:
	cmp cx, dx
	ja @@TargetIsRight2
;Target Is Left Above
	sub sp, 4
	push cx
	push si
	push dx
	push di
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	neg dx
	pop di
	neg di
	
	jmp @@XYAreSet
@@TargetIsRight2:
;Target Is Right Above
	sub sp, 4
	push dx
	push si
	push cx
	push di
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	pop di
	neg di
	
	
	jmp @@XYAreSet
@@XYAreSet:

	mov [bp + 14], dx
	
	mov [bp + 16], di
	
	popa
	pop bp
	ret 10
endp XYtoAdd2DotsWithNeg

;Description: Copies A bmp into a Matrix
;Input: 1. BMP Name offset 2. BMP Length 3. BMP Height 4. Matrix offset
proc ConvertBMPtoMatrix
	push bp
	mov bp, sp
	sub sp, 2
	pusha
	
	
	
	
	mov dx, [bp + 10]
	call OpenMyBmpFile
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	sub sp, 2
	push [word bp + 8]
	call RemoveFixedDecimalPoint
	pop [word bp + 8]
	
	sub sp, 2
	push [word bp + 6]
	call RemoveFixedDecimalPoint
	pop [word bp + 6]
	
	mov ax, ds
	mov es, ax
	
	mov ax, [word bp + 8];padding
	xor dx, dx
	mov si, 4
	div si
	cmp dx, 0
	mov [word bp - 2], 0
	jz @@row_ok
	mov [word bp - 2], 4
	sub [word bp - 2], dx
	
@@row_ok:
	
	mov cx, [bp + 6]
	
@@NextRow:
	push cx
	
	
	mov ah, 3fh
	mov cx, [bp + 8]
	add cx, [bp - 2]
	mov dx, offset MyScrLine
	int 21h
	
	
	
	
	mov di, [bp + 4]
	
	mov ax, [bp + 6]
	
	mul [word bp + 8]
	
	sub ax, [bp + 8]
	
	add di, ax; di -> start of row
	
	mov si, offset MyScrLine
	
	mov cx, [bp + 8]
	rep movsb
	
	dec [word bp + 6]
	pop cx
	loop @@NextRow
	
	
	
	call CloseMyBmpFile
	
	add sp, 2
	popa
	pop bp
	ret 8
endp ConvertBMPtoMatrix

;Description: Converts all bmp to matrix
proc ConvertAllBMPToMatrix
	push offset KnightDefultFileName
	push PLAYERLENGTH
	push PLAYERHIGHT
	push offset KnightDefultMatrix
	call ConvertBMPtoMatrix
	
	push offset KnightWalk1FileName
	push PLAYERLENGTH
	push PLAYERHIGHT
	push offset KnightWalk1Matrix
	call ConvertBMPtoMatrix
	
	push offset KnightWalk2FileName
	push PLAYERLENGTH
	push PLAYERHIGHT
	push offset KnightWalk2Matrix
	call ConvertBMPtoMatrix
	
	push offset KnightRoll1FileName
	push PLAYERLENGTH
	push PLAYERHIGHT
	push offset KnightRoll1Matrix
	call ConvertBMPtoMatrix
	
	push offset KnightRoll2FileName
	push PLAYERLENGTH
	push PLAYERHIGHT
	push offset KnightRoll2Matrix
	call ConvertBMPtoMatrix
	
	push offset KnightRoll3FileName
	push PLAYERLENGTH
	push PLAYERHIGHT
	push offset KnightRoll3Matrix
	call ConvertBMPtoMatrix
	
	push offset ZMBWL1FileName
	push ZombiLength
	push ZombiHeight
	push offset ZMBWL1Matrix
	call ConvertBMPtoMatrix
	
	push offset ZMBWL2FileName
	push ZombiLength
	push ZombiHeight
	push offset ZMBWL2Matrix
	call ConvertBMPtoMatrix
	
	push offset ZMBWR1FileName
	push ZombiLength
	push ZombiHeight
	push offset ZMBWR1Matrix
	call ConvertBMPtoMatrix
	
	push offset ZMBWR2FileName
	push ZombiLength
	push ZombiHeight
	push offset ZMBWR2Matrix
	call ConvertBMPtoMatrix
	
	ret
endp ConvertAllBMPToMatrix



;----------------
;----------------
;----------------
;----------------
;----------------
;Procedures Given










; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
	
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	
	ret
endp RandomByCs

; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask

Proc MakeMaskWord    
    push dx
	
	mov si,1
    
@@again:
	shr dx,1
	cmp dx,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop dx
	ret
endp  MakeMaskWord

; Description  : get RND between any bl and bh includs (max 0 - 65535)
; Input        : 1. BX = min (from 0) , DX, Max (till 64k -1)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        AX - rnd num from bx to dx  (example 50 - 1550)
; More Info:
; 	BX  must be less than DX 
; 	in order to get good random value again and again the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCsWord
    push es
	push si
	push di
 
	
	mov ax, 40h
	mov	es, ax
	
	sub dx,bx  ; we will make rnd number between 0 to the delta between bx and dx
			   ; Now dx holds only the delta
	cmp dx,0
	jz @@ExitP
	
	push bx
	
	mov di, [word RndCurrentPos]
	call MakeMaskWord ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
@@RandLoop: ;  generate random number 
	mov bx, [es:06ch] ; read timer counter
	
	mov ax, [word cs:di] ; read one word from memory (from semi random bytes at cs)
	xor ax, bx ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	inc di
	cmp di,(EndOfCsLbl - start - 2)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	
	cmp ax,dx    ;do again if  above the delta
	ja @@RandLoop
	pop bx
	add ax,bx  ; add the lower limit to the rnd num
		 
@@ExitP:
	
	pop di
	pop si
	pop es
	ret
endp RandomByCsWord





; Description  : Print a bmp file.
; Input        : 1. DX = offset FileName, BmpLeft = X position on screen(0 - 319), BmpTop = Y position on screen(0 - 200), BmpColSize = Length ,BmpRowSize = Hight
; 			     2. Requirements: Variables: OneBmpLine, ScrLine, FileHandle, Header, Palette, ErrorFile
; Output:        On screen
proc OpenShowBmp near
	
	mov [byte ErrorFile], 0
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	 
	call CloseBmpFile
	
@@ExitProc:

	
	ret
endp OpenShowBmp


; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile

proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader

proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette

proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette

proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, [PutBMPSegement]
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	
	;;
	sub di, 320
	;;
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	
	; Copy one line into video memory
	;cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
	push ax
@@Next_Pixel:; Copy line to the screen
	
	mov al, [ds:si]
	cmp al, 06fh
	jz @@PixelDone
	
	mov [es:di], al
@@PixelDone:
	inc di
	inc si
	loop @@Next_Pixel
	pop ax
	
	pop dx
	pop cx
	 
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP

proc  SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic

; Description  : Print a Matrix from memory into Screen.
; Input        : 1. DX = Line Length, CX = Amount of Lines, Variable matrix = Offset of the matrix you want to print, DI = Location to Print on screen(0 - 64,000)
; Output:        On screen
proc putMatrixInScreen
	push es
	push ax
	push si
	
	mov ax, 0A000h
	mov es, ax
	cld ; for movsb direction si --> di
	
	
	mov si,[matrix]
	
@@NextRow:	
	push cx
	mov cx, dx
	push ax
@@Next_Pixel:; Copy line to the screen
	
	mov al, [ds:si]
	cmp al, 06fh
	jz @@PixelDone
	
	mov [es:di], al
@@PixelDone:
	inc di
	inc si
	loop @@Next_Pixel
	pop ax
	sub di,dx ; returns back to the begining of the line 
	add di, 320 ; go down one line by adding 320
	
	
	pop cx
	loop @@NextRow
	
		
	pop si
	pop ax
	pop es
    ret
endp putMatrixInScreen


;input: dx = offset file name
;output: [MyFileHandle] = fiel handle
proc OpenMyBmpFile	near
	pusha						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [MyFileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [MyErrorFile],1
@@ExitProc:	
	popa
	ret
endp OpenMyBmpFile

;input: [MyFileHandle] = fiel handle
proc CloseMyBmpFile near
	pusha
	mov ah,3Eh
	mov bx, [MyFileHandle]
	int 21h
	popa
	ret
endp CloseMyBmpFile

;input: [MyFileHandle] = fiel handle
proc ReadMyBmpHeader	near					
	pusha
	
	mov ah,3fh
	mov bx, [MyFileHandle]
	mov cx,54
	mov dx,offset MyHeader
	int 21h
	
	popa
	ret
endp ReadMyBmpHeader

;input: [MyFileHandle] = fiel handle
;output: [MyPalette]
proc ReadMyBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	pusha
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset MyPalette
	mov bx, [MyFileHandle]
	int 21h
	
	popa
	
	ret
endp ReadMyBmpPalette

proc CopyMyBmpPalette		near					
										
	pusha
	
	mov si,offset MyPalette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
@@CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop @@CopyNextColor
	
	popa
	
	ret
endp CopyMyBmpPalette


EndOfCsLbl:
END start
