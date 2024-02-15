import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';

class CoreUtils {
  const CoreUtils._();

  // static void showSnackBar(BuildContext context, String message,
  //     {Color? foregroundColor, Color? backgroundColor}) {
  //   ScaffoldMessenger.of(context)
  //     ..removeCurrentSnackBar()
  //     ..showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           message,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: foregroundColor ?? Colours.secondaryColour,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: backgroundColor ?? Colours.primaryColour,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         margin: const EdgeInsets.all(10),
  //       ),
  //     );
  // }

  static void showSnackBar(BuildContext context, String message,
      {InfoBarSeverity? severity,
      Color? foregroundColor,
      Color? backgroundColor}) async {
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: severity ?? InfoBarSeverity.warning,
      );
    });
  }

  static String? fileToUriBase64(File? file) {
    if (file == null) {
      return null;
    }
    final filePath = file.path;
    final base64File = base64Encode(file.readAsBytesSync());
    String uriBase64;
    if (filePath.split('/').last.split('.').last == "pdf") {
      uriBase64 = "data:application/pdf;base64,$base64File";
    } else if (filePath.split('/').last.split('.').last == "docx" ||
        filePath.split('/').last.split('.').last == "doc") {
      uriBase64 = "data:application/msword;base64,$base64File";
    } else {
      uriBase64 =
          "data:image/${filePath.split('/').last.split('.').last};base64,$base64File";
    }
    return uriBase64;
  }

  static File? uriBase64ToFile(String? uriBase64, String? fileName,
      {String? extension}) {
    if (uriBase64 == null) {
      return null;
    }
    final base64File = uriBase64.split(',').last;
    final decodedBytes = base64Decode(base64File);
    final file = File('${Directory.systemTemp.path}/$fileName.$extension');
    file.writeAsBytesSync(decodedBytes);
    return file;
  }

  // change string(hex) to string(int)
  static String hexToDec(String hex) {
    var value = hex;
    if (hex.contains('#')) {
      value = hex.replaceAll('#', '');
    }
    return int.parse(value, radix: 16).toString();
  }

  static String hexToDouble(String hex) {
    var value = hex;
    return int.parse(value, radix: 16).toStringAsFixed(0);
  }

  static bool checkSizeFile(double maxSize, File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > maxSize) {
      return false;
    }
    return true;
  }

  static dynamic intOrDouble(double value) {
    return (value % 1 == 0) ? value.toInt() : value.toStringAsFixed(2);
  }

  static List<double> generateRandomNumbers(int count) {
    double last = 0;
    return List.generate(count, (index) {
      if (index % 2 == 0) {
        last += Random().nextDouble();
      } else {
        last -= Random().nextDouble();
      }
      while (last > 9) {
        last -= Random().nextDouble();
      }
      while (last < 0) {
        last += Random().nextDouble();
      }
      return last;
    });
  }

  static List<double> bytesToDouble(Uint8List value) {
    String hexString =
        value.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(',');

    List<String> listString = hexString.split(",");
    List<String> transformedList = [];

    for (int i = 0; i < listString.length; i += 2) {
      if (i + 1 < listString.length) {
        String combinedValue = listString[i + 1] + listString[i];
        transformedList.add(combinedValue);
      }
    }

//     flutter: result: [42, 33, 242, 16]
// flutter: portsValue: [8490.0, 4338.0]
// flutter: event: [8490.0, 4338.0]
// flutter: result: [126, 132, 176, 40]
// flutter: portsValue: [33918.0, 10416.0]
// flutter: event: [33918.0, 10416.0]

    List<int> intList = [];

    for (String hexValue in transformedList) {
      int intValue = int.parse(hexValue, radix: 16);
      intList.add(intValue);
    }

    List<double> doubleList = [];

    for (int intValue in intList) {
      doubleList.add(intValue.toDouble());
    }

    return doubleList;
  }

  static Uint8List hexaToBytes(String value) {
    List<int> codeUnits = value.codeUnits;
    Uint8List uint8List = Uint8List.fromList(codeUnits);
    return uint8List;
  }

  static String listDoubleToHexadecimal(List<double> value) {
    List<int> intList = [];

    for (double doubleValue in value) {
      int intValue = doubleValue.toInt();
      intList.add(intValue);
    }

    List<String> hexList = [];

    for (int intValue in intList) {
      String hexValue = intValue.toRadixString(16).toUpperCase();
      hexList.add(hexValue.padLeft(4, "0"));
    }

    String hexString = hexList.join("");

    return hexString;
  }
}
