HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [x] **If you volunteer to give the presentation next week, check this.**

--------------------

HW02 
===
## 1. 實驗題目 (範例)
撰寫簡易組語觀察 push, pop 兩指令用法。
## 2. 實驗步驟
1. 先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

2. 設計測試程式 main.s ，從 _start 開始後依序執行 movs、push 以及 pop 並且觀察其指令差異，



main.s:

```assembly
_start:
	movs r0,#1
	movs r1,#2
    	movs r2,#3

    	push {r0,r1,r2}

    	pop {r3,r4,r5}

    	movs r3,#0
    	movs r4,#0
    	movs r5,#0
    
    	push {r2,r0,r1}

 	pop {r1,r2,r0}

	//
	//branch w/o link
	//
	b	label01

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
```

3. 將 main.s 編譯並以 qemu 模擬， `$ make clean`, `$ make`, `$ make qemu`
開啟另一 Terminal 連線 `$ arm-none-eabi-gdb` ，再輸入 `target remote localhost:1234` 連接，輸入兩次的 `ctrl + x` 再輸入 `2`, 開啟 Register 以及指令，並且輸入 `si` 單步執行觀察。
當執行到 `0xe` 的 `push {r0,r1,r2} ` 時， `pc` 跳轉至 `0x10` ，`sp` 位置從 `0x20000100` 指到 `0x200000f4`，一共向下堆疊3個暫存器  

`0x200000fc` 存 `r2`暫存器的資料
`0x200000f8` 存 `r1`暫存器的資料
`0x200000f4` 存 `r0`暫存器的資料
儲存的順序為 `r2` `r1` `r0`

![](https://github.com/EasonDowYo/ESEmbedded_HW02/blob/master/img/push_r0_r2.png)
      
當執行到 `0x10` 的 `pop {r3,r4,r5} ` 時， `pc` 跳轉至 `0x12` ，`sp` 位置從 `0x200000f4` 指到 `0x20000100`

`0x200000fc` 位址中的資料存到 `r5`
`0x200000f8` 位址中的資料存到 `r4`
`0x200000f4` 位址中的資料存到 `r3`
取出順序為 `r5` `r4` `r3`

![](https://github.com/EasonDowYo/ESEmbedded_HW02/blob/master/img/pop_r3_r5.png)

當執行到 `0x18` 的 `push {r1,r2,r0} ` 時，反組意時就會將暫存器的順序擺正，改為 `push {r0,r1,r2} `

![](https://github.com/EasonDowYo/ESEmbedded_HW02/blob/master/img/push_r1_r2_r0.png)

## 3. 結果與討論
記憶體存與讀會採用後進先出、先進後出的原則
