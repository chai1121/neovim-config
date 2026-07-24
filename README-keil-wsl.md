# WSL 中浏览 Keil 工程

此配置面向在 WSL 中打开 `/mnt/h/code/...` 下的 Keil C/C++ 项目。

## 必需工具

在 WSL 发行版中安装 `clangd`（不要使用 Windows 版的 clangd）：

```bash
sudo apt update
sudo apt install clangd
```

重新打开任一 `.c`、`.h`、`.cpp` 文件后，用 `:LspInfo` 确认 `clangd` 已附着。

## 打开项目与按键

```bash
cd /mnt/h/code/你的项目
nvim .
```

* `-` 或 `<Space>e`：文件浏览器
* `gd`：跳到定义；`gD`：跳到声明；`gr`：全部引用；`gi`：实现
* `K`：符号说明；`<Space>rn`：重命名
* `[d`、`]d`：上一条、下一条诊断

## 让 clangd 理解 Keil 的头文件和宏

最可靠的办法是在**项目根目录**放置 `.clangd`。下面是起点；将 include 目录和宏替换成项目实际使用的值：

```yaml
CompileFlags:
  Add:
    - -xc
    - -std=c11
    - -I./Core/Inc
    - -I./Drivers/CMSIS/Include
    - -I./Drivers/CMSIS/Device/ST/STM32F4xx/Include
    - -DSTM32F407xx
```

如果工程能导出 `compile_commands.json`，优先把它放在项目根目录；clangd 会自动使用它，跳转与诊断的准确度最高。`.clangd` 位于 Windows 的项目目录中，不在这份配置内，方便每个芯片项目各自维护。
