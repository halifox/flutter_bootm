import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart';
import 'dart:html' as html;



var hint_boot_animation = """
Android 设备开机动画（Boot Animation）
刷写开机动画
将设备挂载为读写模式：
adb remount
将 bootanimation.zip 推送到设备的 /system/media/ 目录：
adb push bootanimation.zip /system/media/bootanimation.zip
""";

Future<void> createAndDownloadZip() async {
  final XTypeGroup typeGroup = XTypeGroup(label: 'images', extensions: <String>['png']);
  XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
  if (file == null) return;
  int imageLength = await file.length();
  Uint8List imageBytes = await file.readAsBytes();
  final Image image = decodeImage(imageBytes)!;

  final archive = Archive();

  archive.addFile(ArchiveFile('part0/00001.png', imageLength, imageBytes, ArchiveFile.STORE));

  final desc = Uint8List.fromList("${image.width} ${image.height} 30\np 0 0 part0".codeUnits);
  archive.addFile(ArchiveFile('desc.txt', desc.length, desc, ArchiveFile.STORE));

  // 将 ZIP 文件编码为字节
  final zipData = ZipEncoder().encode(archive);

  if (zipData != null) {
    // 在 Web 环境中，使用 Blob 和 URL.createObjectURL 来触发下载
    final blob = html.Blob([zipData], 'application/zip');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'bootanimation.zip')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
