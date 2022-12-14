# SSAC-Memo
서브웨이 이탈리안 비엠티에 .. 에그마요 추가 .. (메 .. 모 .... )

</br>
</br>

> 🌱 SeSAC </br>
> 2차 평가 과제 (22081 ~ 220904) </br>
> 그 이후로 코드 개선을 진행하고 있습니다. :)

</br>
</br>

## 과제 요구 사항
1. 화면 3개 (메모 리스트 - 메모 작성/수정하기)
2. Realm DB 사용 
3. 메모 추가, 삭제, 업데이트 모두 가능 

</br>
</br>

## 과제 주요 포인트
(개인적으로 생각하는 해당 과제의 주요 포인트는 아래와 같습니다.) </br>

- 클라이언트로서의 사용성을 생각한 분기처리 </br>
예) 키보드가 뷰를 가리지는 않는가? 삭제하려고 할 때, Alert을 띄울 것인가?, 키보드가 보여지면 스크롤이 되어야 하지 않는가? 등 ..
- 최대한 리소스를 적게 사용하기
예) 메모 작성하기 화면과 수정하기 화면을 따로 만드는 것이 아니라 같은 화면을 바탕으로 (= 같은 ViewController) 분기처리하여 관리 

</br>
</br>

## 과제 구현 및 코드 개선 진행 과정 

| 구현 단계 | 구현 기간 | 진행 과정 | 관련 이슈 및 블로그 정리 |
|---------|---------|---------|---------|
| 1차 구현 | 22.08.31 ~ 22.09.04 | 1. UIKit, AutoLayout </br> 2. CodeBase (-> `Snapkit`, `Then` 사용) </br> 3. DB (-> `Realm Database` 사용 ) </br> 4. 평가 과제 요구사항 구현 (메모 고정-미고정, 메모 작성/수정, 메모 삭제 등) | [발단](https://so-kyte.tistory.com/103) </br> [전개](https://so-kyte.tistory.com/109) </br> [위기](https://so-kyte.tistory.com/110) </br> [절정](https://so-kyte.tistory.com/111) |
| 2차 코드 개선 | 22.10 | Realm Migration | [Issue 26](https://github.com/pcsoyeon/SSAC-Memo/issues/26) |
| 3차 코드 개선 | 22.10 | New Collection API 적용 | [Issue 27](https://github.com/pcsoyeon/SSAC-Memo/issues/27) |
| 4차 코드 개선 | 22.10 | MVVM 패턴 적용 (메모 리스트, 메모 작성) | [Issue 33](https://github.com/pcsoyeon/SSAC-Memo/issues/33) </br> [Issue 35](https://github.com/pcsoyeon/SSAC-Memo/issues/35) |
| 5차 코드 개선 | 22.10 ~ 22.11 | RxSwift, RxCocoa 적용 | [Issue 37](https://github.com/pcsoyeon/SSAC-Memo/issues/37) </br> |
| 6차 코드 개선 | 22.11 | Input, Output 적용 | [Issue 38](https://github.com/pcsoyeon/SSAC-Memo/issues/38) | 
| 7차 코드 개선 | 22.11 (적용중) | RxSwift, RxCocoa Operator 및 Traits 적용 | - |




</br>
</br>

## 1차 코드 구현 후 피드백 정리 
(2차 과제인 메모 과제 진행 후 받은 피드백 내용은 아래와 같습니다.) </br>

### 괜찮은 부분 🤓 </br>
1. 일관성있는 구조도
2. 배운 내용 적절하게 활용
3. Extension으로 기능 분리
4. View의 액션을 ViewController에서 선언하지 않고, Delegate 패턴 적용
5. final 키워드
6. 접근제어자 

</br>
</br>

### 아쉬운 부분 😩 </br>
1. Cell 내부에서 처리할 수 있는 작업을 ViewController에서 작업한 부분 (-> ViewController에서 하는 일이 많아지므로 좋은 구조라고 할 수 없다.)
2. 처리되지 않은 경우 요구 사항
| 요구 사항 (이슈)) | 어떻게 해결? |
| 제목이 없는 경우 저장할 때 앱 크래시 발생 | - |
| 메모를 작성하고 스와이프 동작 시, 완료되지 **않아도** 메모 저장 | - |
| 메모를 작성할 때 컨텐츠가 길어지면 키보드에 의해 가려지는 이슈 | - |
| 검색 뷰에서 메모를 5개보다 많이 고정 가능 | 검색 뷰에서의 분기처리 수정 |
| 검색 뷰에서 메모를 고정하면 필터링 해제 | 검색 로직 수정 |
| 검색 시 메모를 삭제하면 인덱싱 오류 발생 | 하나의 데이터 배열 안에서 관리하는 것으로 수정 |

3. MemoRepository.swift
- Realm 인스턴스 생성 시 do-catch 구문 활용 -> try는 런타임 중에 fetal error로 이어질 수 있으므로 위험
- error handling : 단순 출력보다는 유저에게 실패를 알릴 수 있도록 하는 방법 등의 핸들링 
- 작성/수정 모드의 경우, Bool 형보다는 enum을 사용해서 관리하는 것이 더 편리, 유지 보수를 할 때에도 목적을 알 수 있기 때문에 더 좋다. 
- 불필요한 타입 명시 지양 


</br>
</br>

### 궁금한 부분 🧐 </br>
- 질문 : </br>
Realm 데이터를 필요로 할 때마다 Realm에서 가져오는 것과 앱 시작 시 메모리에 캐싱하고 캐싱된 메모를 사용하는 것 .. 의 비교 </br>

- 답변 : </br>
Realm의 경우 필요할 때마다 가져오기 쉽도록, 쿼리 문법이나 그를 받쳐주는 성능이 있다고는 하지만 데이터 베이스라는 최고 수준의 정책은 자주 접근할수록 그만큼 위험도가 커진다. </br>
이번 메모 프로젝트처럼 코드 전반에서 Realm 접근 코드를 많이 사용하는 경우(= DB에 접근해서 메모를 남기거나 삭제, 수정하는 경우) 그만큼 위험도가 커지기 때문에 앱 크래시가 흔하게 발생한다. </br>
그러나, 잘 사용하면 계층을 많이 감소시키고 빠른 속도를 보장한다. </br>
Realm을 따로 캐싱해서 가져오는 경우를 생각해보면, 데이터베이스에 수시로 접근하지 않기 때문에 안전하고 코드 내부에서 따로 램과 관련된 코드를 작성하지 않아도 된다. 그러므로 알고리즘을 잘만 적용하면 Realm 못지 않게 빠른 속도를 낼 수 있다. </br>
대신, 관리해야 하는 계층이 늘고 빠른 개발 속도를 필요로 할 때, 이 계층을 구성하는 비용이 될 수 있다. 

