import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:convert';

class LinkPreviewController extends GetxController {
  RxString imageUrl = ''.obs;
  RxString description = ''.obs;

  Future<void> fetchLinkPreview(String url) async {
    // fetchLinkPreview 함수는 URL을 입력으로 받아서 해당 URL에서 링크 미리보기 데이터를 가져오는 비동기 함수입니다.
    try {
      //try 블록은 예외가 발생할 수 있는 코드를 포함하는 블록입니다.
      //코드 실행 중에 예외가 발생하면 catch 블록에서 해당 예외를 처리합니다.
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://' + url;
      }
     // URL이 "http://" 또는 "https://"로 시작하지 않는 경우, URL에 "https://"를 추가하여 보정합니다.
     // 프로토콜 보정.
      var response = await http.get(
        Uri.parse(url),
        headers: {'Accept-Charset': 'utf-8'},
      );
      // http.get 함수를 사용하여 입력된 URL에 GET 요청을 보냅니다.
      // 이때 Accept-Charset 헤더를 추가하여 UTF-8 문자 인코딩 합니다.
      if (response.statusCode == 200) {
          // HTTP 응답 코드가 200인지 확인하여 요청이 성공했는지를 검사합니다.
        var document = parse(utf8.decode(response.bodyBytes));
        // response.bodyBytes에서 바이트 데이터를 UTF-8 문자열로 디코딩한 뒤, (convert 라이브러리 활용)
        // parse 함수(파싱하기위해)를 사용하여 HTML 문서로 파싱합니다.
        var metaTags = document.getElementsByTagName('meta');
        // HTML 문서에서 모든 메타 태그를 찾아옵니다.
        String? foundImageUrl;
        String? foundDescription;
        // String? (null값허용) 변수로 foundImageUrl ( 이미지찾기)
        // String? (null값허용) 변수로 foundDescription (설명찾기)
        for (var tag in metaTags) {
        // 모든 메타태그에서 for문을 돌립니다.
          var property = tag.attributes['property'];
          var content = tag.attributes['content'];
          // 각 메타 태그에서 가져 올 property (속성) 와 content (값) 을 var 변수로 지정합니다.
          if (property == 'og:image' && foundImageUrl == null) {
            foundImageUrl = content;
          } else if (property == 'og:description' && foundDescription == null) {
            foundDescription = content;
          }
          //og:{property} => Open Graph 프로토콜을 따르는 메타데이터에서 속성입니다.
          //if 문 에선 메타 태그의 property가 'og:image'이고,이미지 URL이 아직 발견되지 않은 경우,
          //이미지 content (imgUrl 값)을 foundImageUrl 변수에 저장합니다.
          //메타 태그의 property가 'og:description'이고,설명이 아직 발견되지 않은 경우,
          //설명 content ( description 값)을 foundDescription 변수에 저장합니다.
        }
        if (foundImageUrl != null && foundDescription != null) {
          imageUrl.value = foundImageUrl;
          description.value = foundDescription;
          // 위에서 변수로 지정했던 이미지찾기 와 설명찾기가 모두 발견된 경우,
          // 각각을 imageUrl 과 description RxString 변수로 지정한 곳에 값을 할당합니다.
          // 쉽게 상태를 관리하고, 상태 변경을 추적할 수 있도록 하기 위해서 RxString변수에 담기.
          // 그렇지 않은 경우, 예외설명후 Exception 을 던집니다.
        } else {
          throw Exception('링크 미리보기 데이터를 가져오지 못했습니다. 이미지 또는 설명을 찾을 수 없습니다');
        }
      }
    } catch (e) {
      throw Exception('예외발생: $e');
      //  try 블록에서 발생한 모든 예외를 캐치하고,
      // 'Failed to fetch link preview data: $e' 메시지를 포함한 예외를 다시 던집니다.
    }
  }
}