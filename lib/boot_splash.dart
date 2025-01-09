import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart';
import 'dart:html' as html;

var hint_boot_splash = """
Android 设备启动画面（Boot Splash）
将设备重启至引导加载程序（Bootloader）模式：
adb reboot bootloader
使用 fastboot 刷写 splash.img：
fastboot flash splash splash.img
注意事项
如果刷写后启动画面未生效，请检查设备分区是否支持 splash 分区，
或查看串口日志是否有相关报错。
如果需要禁用 Android 设备的 dm-verity 文件完整性验证，
可以使用以下命令：
adb disable-verity
adb reboot
""";

Future<void> saveImageAsSplash() async {
  final XTypeGroup typeGroup =
      XTypeGroup(label: 'images', extensions: <String>['png']);
  XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
  if (file == null) return;
  final List<int> imageBytes = await file.readAsBytes();
  final Image image = decodeImage(imageBytes)!;
  // 将图像数据转换为RGB格式的字节流
  final Uint8List bodyData = image.getBytes(format: Format.rgb);

  const String magicNumber = 'SPLASH!!';
  const int headerSize = 512;
  const int blockSize = 512;
  // 计算图像数据占用的实际块数（每个块512字节）
  final int realSize = (bodyData.length + blockSize - 1) ~/ blockSize;

  // 创建头部数据并填充信息
  final Uint8List header = Uint8List(headerSize);
  header.setRange(0, magicNumber.length, magicNumber.codeUnits);
  header.buffer.asByteData() //
    ..setUint32(8, image.width, Endian.little) //
    ..setUint32(12, image.height, Endian.little) //
    ..setUint32(16, 0, Endian.little) // 压缩标志
    ..setUint32(20, realSize, Endian.little); //

  // 创建Blob对象并生成下载链接
  final html.Blob blob = html.Blob([Uint8List(4096), header, bodyData]);
  final String url = html.Url.createObjectUrlFromBlob(blob);

  // 创建并触发下载
  final html.AnchorElement anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'splash.img')
    ..click();

  // 释放URL对象
  html.Url.revokeObjectUrl(url);
}
