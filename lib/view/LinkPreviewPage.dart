import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test15/contoller/LinkPreviewController.dart';

class LinkPreviewPage extends StatelessWidget {
  final LinkPreviewController linkPreviewController = Get.put(LinkPreviewController());
  // LinkPreviewController을 가져와서 linkPreviewController 변수에 할당합니다.
  // GetX의 put 메서드를 사용하여 컨트롤러를 전역으로 사용할 수 있도록 등록합니다.
  final TextEditingController textController = TextEditingController();
  // TextField에서 사용할 textController를 생성합니다. (입력한 값 을 가져옵니다)
  // static RegExp basicReg = RegExp(r"^[ㄱ-ㅎ가-힣0-9a-zA-Z\s+]*$");
  // Widget Build 순서 : Scaffold (뼈대)-> body (내용) -> child(추가내용 ex) column or row )
  // -> children(추가내용 ex) obx() or TextField() 역순으로 올라갑니다.)
  @override
  Widget build(BuildContext context) {
    // 메인화면에 보여 줄 widget build를 생성 합니다.
    return Scaffold(
      //Scaffold = > 구성된 앱에서 디자인적인 부분에서의 뼈대
      // 리턴은 Scaffold 로 합니다.
      appBar: AppBar(
        title: Text('Link Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        // const EdgeInsets.all(20) -> 	모든 방향으로 20픽셀 만큼의 여백.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //CrossAxisAlignment.stretch 을 사용하여 좌우를 꽉 차게 배치합니다.
          children: [
            TextField(
              controller: textController,
              // controller : java -> sc.next();
              decoration: InputDecoration(
                hintText: 'URL 을 입력 해 주세요.',
              ),
            ),
            SizedBox(height: 20),
            // 1.URL을 입력하는 TextField를 생성합니다.
            // 2.textController를 사용하여 TextField의 값을 가져옵니다.

        //---------------------------------------------------------------------------------------//
            ElevatedButton(
              //기존의 RaisedButton() 사용자가 누를 수 있는 버튼을 나타냅니다. 
              // 이 버튼을 누르면 링크 미리보기를 가져오는 기능이 실행됩니다.
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  // textControoler.text 값이 비어 있지 않으면
                  linkPreviewController.fetchLinkPreview(textController.text);
                  // textController.text 값을 담아서 controller 단에 있는 fetchLinkPreview 비동기 메서드 실행
                } else {
                  //그게 아닐 경우 (값이 비어있다면)
                  Get.snackbar(
                    //Getx 라이브러리 활용 Get.snackbar (알림형식)
                    'Error',
                    '다시 입력 해주세요.',
                    snackPosition: SnackPosition.BOTTOM,
                    // 아래 알림 띄우기
                  );
                }
              },
              child: Text('URL 미리보기'),
            ),
            SizedBox(height: 20),

            // 1. ElevatedButton을 생성하고,
            // 2. 버튼을 누르면 입력된 URL을 사용하여 linkPreviewController의 fetchLinkPreview 메서드를 호출합니다.
            // 3. 만약 입력된 URL이 비어있다면, GetX의 snackbar를 사용하여 에러 메시지를 표시합니다.

  //-----------------------------------------------------------------------------------------------------//
            Obx(() {
              //결과 값 .
              final imageUrl = linkPreviewController.imageUrl.value;
              // imageUrl 의존성 주입 -> controller단에 있는 imageUrl .value (값)
              final description = linkPreviewController.description.value;
              // description 의존성 주입 -> controller단에 있는 description .value (값)
              if (imageUrl.isEmpty || description.isEmpty) {
                //imageUrl / description 이 빈객체 일경우
                return SizedBox.shrink();
                // return SizedBox.shrink() (빈 위젯 반환)
              }
              // 그렇지 않은 경우 return column (결과값) 화면에 출력합니다.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // cloumn 일 경우 세로축 기준 왼쪽 정렬합니다.
                // row 일 경우 가로축 기준 위쪽 정렬.
                children: [
                  Image.network(
                    //Image.network() => 네트워크상에 존재하는 이미지를 출력하는 메서드.
                    imageUrl,
                    //(controller단에서 받은 imageUrl값)
                    width: MediaQuery.of(context).size.height * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                    // width,height : MediaQuery 을 이용해서 화면 크기에 따라 동적으로 조절 합니다.
                    fit: BoxFit.fill,
                    // BoxFit 종류 fill(설정한크기 맞게 비율이 변경 합니다.),
                    // contain,(설정한 크기 이내 비율이 변경되지 않고 크게나옵니다.)
                    // cover(비율이 변경되지 않고 설정한크기 덮고 일부 이미지 잘립니다.),
                    // fitWidth(설정한 너비만 맞게 비율이 변경 됩니다.) ,
                    // fitHeight(설정한 높이만 맞게 비율 변경 됩니다.) ,
                    // none (원본 이미지의 크기조절 안되며 설정한 크기보다 크면 일부 이미지 잘립니다.)
                  ),
                  SizedBox(height: 10),
                  // UrlImage
                  Text(
                    // 설명 Text
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}