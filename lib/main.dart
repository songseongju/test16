import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test15/view/LinkPreviewPage.dart';

void main() {
  //MyApp 클래스 실행합니다.
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // 메인 이기에 고정된 형태로 한번 그려지고 나면 변화가 없는 위젯인 StatelessWidget 상속 받습니다.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // GetMaterialApp 를 써서 Getx 상태 관리 및 라우팅 기능을 제공 합니다.
      title: 'Link Preview',
      home: LinkPreviewPage(),
      // LinkPreviewPage.dart 를 불러서 View 보여줍니다.
    );
  }
}