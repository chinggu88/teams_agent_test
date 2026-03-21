# TodoList Figma 화면 매핑

> 각 화면별 와이어프레임에 대응하는 Figma URL을 관리합니다.

## 화면 목록

| 화면 코드 | 화면명 | Figma URL | 상태 |
|-----------|--------|-----------|------|
| S01 | 온보딩 화면 | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-70&t=uKoCgAAh356tOy9c-11` | - |
| S02 | 로그인 화면 | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-2&t=uKoCgAAh356tOy9c-11` | - |
| S03 | 홈 화면 (할 일 목록) | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-211&t=uKoCgAAh356tOy9c-11` | - |
| S04 | 할 일 추가 화면 | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-90&t=uKoCgAAh356tOy9c-11` | - |
| S05 | 할 일 상세 화면 | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-211&t=uKoCgAAh356tOy9c-11` | - |
| S06 | 완료 목록 화면 | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-520&t=uKoCgAAh356tOy9c-11` | - |
| S07 | 마이페이지 화면 | `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-633&t=uKoCgAAh356tOy9c-11` | - |

---

## 상세 화면 정보

### S01. 온보딩 화면

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-70&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-70`
- **설명**: 앱 최초 실행 시 표시되는 3페이지 슬라이드
- **주요 컴포넌트**:
  - 앱 아이콘/일러스트
  - PageIndicator (3개 도트)
  - 시작하기 버튼
  - 건너뛰기 링크

---

### S02. 로그인 화면

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-2&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-2`
- **설명**: 이메일/비밀번호 로그인 및 소셜 로그인
- **주요 컴포넌트**:
  - 앱 로고
  - 이메일 입력 필드
  - 비밀번호 입력 필드 (표시/숨김 토글)
  - 로그인 버튼
  - Google/Apple 소셜 로그인 버튼
  - 회원가입 링크

---

### S03. 홈 화면 (할 일 목록)

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-211&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-211`
- **설명**: 메인 할 일 목록 화면
- **주요 컴포넌트**:
  - 헤더 (오늘의 할 일 + 검색 아이콘)
  - TabBar (오늘/전체/태그별)
  - ProgressBar (진행률)
  - 할 일 카드 리스트
    - 체크박스
    - 제목
    - 마감일
    - 우선순위 뱃지
  - FAB (+) 버튼
  - BottomNavigation (홈/검색/완료/마이)

---

### S04. 할 일 추가 화면

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-90&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-90`
- **설명**: 새 할 일 추가 폼
- **주요 컴포넌트**:
  - 헤더 (뒤로가기 + 할 일 추가)
  - 제목 입력 필드 (필수)
  - 메모 입력 필드 (선택)
  - 마감일 DatePicker
  - 우선순위 ChipGroup (높음/보통/낮음)
  - 태그 ChipGroup (업무/개인/학습/+새로)
  - 추가하기 버튼

---

### S05. 할 일 상세 화면

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-211&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-211`
- **설명**: 할 일 상세 정보 및 액션
- **주요 컴포넌트**:
  - 헤더 (뒤로가기 + 할 일 상세)
  - 제목 + 우선순위 뱃지 + 태그 칩
  - 상세 정보 리스트 (마감일/생성일/태그)
  - 메모 카드
  - 삭제/수정 버튼
  - 할 일 완료하기 버튼

---

### S06. 완료 목록 화면

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-520&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-520`
- **설명**: 완료된 할 일 리스트
- **주요 컴포넌트**:
  - 헤더 (완료 목록 + 전체 삭제 아이콘)
  - 완료 통계 텍스트
  - 완료 카드 리스트
    - 체크박스 (체크됨)
    - 제목 (취소선)
    - 완료일
    - 복원 아이콘
  - 스와이프 힌트
  - BottomNavigation

---

### S07. 마이페이지 화면

- **Figma URL**: `https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-633&t=uKoCgAAh356tOy9c-11`
- **Node ID**: `26-633`
- **설명**: 사용자 프로필 및 설정
- **주요 컴포넌트**:
  - 프로필 영역 (아바타/닉네임/이메일)
  - 설정 메뉴 리스트
    - 내 정보 수정
    - 알림 설정 (토글)
    - 푸시 알림 시간 설정
    - 테마 설정
  - 로그아웃 버튼
  - BottomNavigation

---

### Figma URL 형식 예시

```
https://www.figma.com/design/[FILE_KEY]/[FILE_NAME]?node-id=[NODE_ID]
```

---

## 참고

- 기획서: [todolist_designer_spec.md](../plans/todolist_designer_spec.md)
- 디자인 토큰: 기획서 6-2. 디자인 토큰 권장 참조
