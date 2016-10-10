# MicOS

操作系统学习代码，从零开始构建 x86 微型操作系统

## 目标

构建一个具有交互功能、硬件访问能力的微型操作系统

## 工具

* [nasm](http://www.nasm.us/) x86 汇编编译器
* [make](https://www.gnu.org/software/make/) 代码构建工具
* [gcc](https://www.gnu.org/software/gcc/) C 编译器
* [ld](https://www.gnu.org/software/binutils/) C 连接器
* [ar](https://www.gnu.org/software/binutils/) 链接库工具
* [node](https://nodejs.org/en/) 6.0 以上版本，用于运行部分构建辅助工具
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 虚拟机

## 运行

```sh
# 检出代码
$ git clone https://github.com/treelite/micos.git
# 构建代码
make
```

使用 VirtualBox 构建一个虚拟机，添加软盘驱动器并作为第一启动设备，将 `output/micos.img` 作为软盘载入虚拟机

or

按照实现的过程检出每一步的 Tag 来慢慢玩儿～

## 任务

### Hello world

第一步仍然是在屏幕上输出 "Hello, World!"，不过这次面对的是绝对的裸机，没有操作系统的那种 ...

**Tag**: `hello`

涉及的问题：

* PC 的启动过程与主引导区
* 16位汇编与实模式
* 显示控制

### 加载内核

512 字节的引导区毕竟空间有限不可能容纳整个操作系统，因此需要将引导程序与系统内核分开，由引导程序来完成系统内核的载入与启动。这次内核除了能显示字符串外，还要能实时显示时间了，总算有点点实际价值了 ...

**Tag**: `loadKernel`

涉及的问题：

* 调用 BIOS 中断服务操作硬件
* 实模式的地址分段
* 自定义中断处理程序

### 保护模式

欢迎来到 32 位的世界。引导程序在执行内核代码前，会先让 CPU 进入保护模式，以使内核摆脱 16 位的限制。同时内核也改为 C 语言书写，终于要进入操作系统的逻辑实现了 ...

**Tag** `bit32`

涉及的问题：

* 开启保护模式
* 保护模式的地址分段
* ELF 文件格式（内核使用此格式封装）

## 参考

* [Intel汇编语言程序设计](https://book.douban.com/subject/2250326/) Intel 汇编入门书籍，最推荐，没有之一
* [x86汇编语言 从实模式到保护模式](https://book.douban.com/subject/20492528/) 看标题就知道啦，内容正好涉及编写操作系统的基础
* [Intel 汇编指令参考](http://www.skywind.me/maker/intel.htm) 指令参考文档
