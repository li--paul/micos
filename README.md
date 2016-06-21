# MicOS

操作系统学习代码，从零开始构建 x86 微型操作系统

## 目标

构建一个具有交互功能的操作系统

## 工具

* [nasm](http://www.nasm.us/) x86 汇编编译器
* [make](https://www.gnu.org/software/make/) 代码构建工具
* [node](https://nodejs.org/en/) 6.0 以上版本，用于运行部分构建辅助工具
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 虚拟机

## 任务

### Hello world

第一步仍然是在屏幕上输出 "Hello, World!"，不过这次面对的是绝对的裸机，没有操作系统的那种 ...

涉及的问题：

* PC 的启动过程与主引导区
* 16位汇编与实模式
* 显示控制

#### 运行

```sh
# 检出代码
$ git clone --branch hello https://github.com/treelite/micos.git
# 构建代码
make
```

使用 VirtualBox 构建一个虚拟机，添加软盘驱动器，并将 `output/micos.img` 作为软盘载入虚拟机，然后启动

## 参考

* [Intel汇编语言程序设计](https://book.douban.com/subject/2250326/) Intel 汇编入门书籍，最推荐，没有之一
* [x86汇编语言 从实模式到保护模式](https://book.douban.com/subject/20492528/) 看标题就知道啦，内容正好涉及编写操作系统的基础
* [Intel 汇编指令参考](http://www.skywind.me/maker/intel.htm) 指令参考文档
