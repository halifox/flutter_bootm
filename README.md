# bootm

bootm 是一个基于 Flutter Web 的工具，旨在帮助用户轻松创建和自定义 Android 启动闪屏（Boot Splash）以及启动动画（Boot Animation）。该工具完全在前端运行，无需任何后端支持，简化了制作流程。


## 使用方法

1. 打开 [bootm](https://bootm.pages.dev/) 网站
2. 在工具页面中上传自定义的图片
3. 下载生成的 splash.img 或者 bootanimation.zip
4. 刷写或烧录

## 技术栈

- **Flutter Web**：用于构建响应式的前端界面。

## 安装与部署

### 本地开发

1. 克隆该项目到本地：
   ```bash
   git clone https://github.com/halifox/flutter_bootm
   cd flutter_bootm
   ```

2. 安装 Flutter：
   - [Flutter 安装教程](https://flutter.dev/docs/get-started/install)

3. 运行项目：
   ```bash
   flutter run -d chrome
   ```

### 部署到生产环境

1. 打包项目：
   ```bash
   flutter build web
   ```

2. 将 `build/web` 目录中的内容部署到你的静态文件服务器。


## 贡献

欢迎提交 PR 和 Issues 来改进该项目！请在提交之前查看 [贡献指南](CONTRIBUTING.md)。

## 许可

本项目使用 [LGPL-3.0 License](LICENSE) 进行许可。


# Android 设备启动画面与开机动画修改指南

## 1. 修改 Android 设备启动画面（Boot Splash）

### 1.1 准备工作
1. 准备一张与设备屏幕分辨率相同的图片。
    - **注意**：图片可能需要为竖屏模式，并且必须是 PNG 格式。

### 1.2 生成 `splash.img`

### 1.3 刷写启动画面
1. 将设备重启至引导加载程序（Bootloader）模式：
   ```bash
   adb reboot bootloader
   ```
2. 使用 `fastboot` 刷写 `splash.img`：
   ```bash
   fastboot flash splash splash.img
   ```

### 1.4 注意事项
- 如果刷写后启动画面未生效，请检查设备分区是否支持 `splash` 分区，或查看串口日志是否有相关报错。
- 如果需要禁用 Android 设备的 dm-verity 文件完整性验证，可以使用以下命令：
   ```bash
   adb disable-verity
   adb reboot
   ```

---

## 2. 修改 Android 设备开机动画（Boot Animation）

### 2.1 准备工作
1. 准备一张与设备屏幕分辨率相同的图片。

### 2.2 生成 `bootanimation.zip`

### 2.3 刷写开机动画
1. 将设备挂载为读写模式：
   ```bash
   adb remount
   ```
2. 将 `bootanimation.zip` 推送到设备的 `/system/media/` 目录：
   ```bash
   adb push bootanimation.zip /system/media/bootanimation.zip
   ```

### 2.4 注意事项
- 如果设备无法挂载为读写模式，可能需要禁用 dm-verity（见上文）。
- 确保 `bootanimation.zip` 的压缩模式为“存储模式”，否则可能导致动画无法正常播放。

---
