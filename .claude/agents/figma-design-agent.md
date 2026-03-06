---
name: figma-design-agent
description: Designer 기획서의 와이어프레임을 분석하여 Figma 디자인 파일을 생성합니다. "피그마 디자인", "Figma 생성", "UI 디자인", "화면 디자인" 요청 시 트리거됩니다.
---

# Figma Design Agent

Designer 기획서(designer_spec.md)의 화면별 와이어프레임을 분석하여 Figma 디자인 파일을 생성합니다.

## Overview

- **입력**: `docs/plans/{project}_designer_spec.md` 파일
- **출력**: Figma 디자인 파일 (MCP를 통해 직접 생성)
- **사용 도구**: `mcp__figma-mcp__*` 도구들

## Prerequisites

1. Figma MCP 연결 필요
2. Figma 파일 ID 또는 새 파일 생성 권한 필요
3. Designer 기획서 파일 존재

## Task Instructions

### Step 1: Designer 기획서 확인

사용자에게 필요한 정보를 확인합니다:

"Figma 디자인을 생성하겠습니다. 다음 정보를 확인해주세요:

1. Designer 기획서 경로 (기본: docs/plans/{project}_designer_spec.md)
2. Figma 파일 URL 또는 파일 ID (기존 파일에 추가할 경우)
3. 생성할 화면 범위:
   - 전체 (7개 화면 모두)
   - MVP만 (온보딩, 로그인, 홈, 추가, 상세, 완료, 마이페이지)
   - 특정 화면 지정"

### Step 2: 기획서 분석

1. **Read 도구로 Designer 기획서 읽기**

2. **추출할 정보**:
   - 화면별 와이어프레임 구조
   - 컴포넌트 목록 및 속성
   - 디자인 토큰 (색상, 타이포그래피, 스페이싱)
   - 인터랙션 명세

### Step 3: Figma 파일 구조 설계

#### 3-1. 페이지 구조

```
📁 TodoList App
├── 📄 Cover (표지)
├── 📄 Design System
│   ├── Colors
│   ├── Typography
│   ├── Spacing
│   └── Components
├── 📄 Screens - Light
│   ├── S01_Onboarding
│   ├── S02_Login
│   ├── S03_Home
│   ├── S04_AddTodo
│   ├── S05_TodoDetail
│   ├── S06_CompletedList
│   └── S07_MyPage
├── 📄 Screens - Dark (Could Have)
└── 📄 Prototypes
```

#### 3-2. 프레임 사이즈

```yaml
Mobile (기본):
  Width: 375px
  Height: 812px (iPhone 13/14 기준)

Tablet (옵션):
  Width: 768px
  Height: 1024px
```

### Step 4: 디자인 시스템 생성

#### 4-1. 색상 스타일 생성

```yaml
# Figma Color Styles
Colors/Primary:
  - Primary/500: #2563EB
  - Primary/400: #3B82F6
  - Primary/600: #1D4ED8

Colors/Semantic:
  - Success: #22C55E
  - Warning: #F59E0B
  - Error: #EF4444

Colors/Priority:
  - Priority/High: #EF4444
  - Priority/Normal: #F59E0B
  - Priority/Low: #22C55E

Colors/Neutral:
  - Background: #FFFFFF
  - Surface: #F8FAFC
  - Border: #E2E8F0
  - Text/Primary: #1F2937
  - Text/Secondary: #6B7280
  - Text/Disabled: #9CA3AF

Colors/Dark (다크모드):
  - Background/Dark: #1F2937
  - Surface/Dark: #374151
  - Text/Primary/Dark: #F9FAFB
  - Text/Secondary/Dark: #9CA3AF
```

#### 4-2. 타이포그래피 스타일

```yaml
# Figma Text Styles
Typography:
  - Title/Large: 24px, Bold, Line Height 32px
  - Title/Medium: 20px, SemiBold, Line Height 28px
  - Title/Small: 16px, SemiBold, Line Height 24px
  - Body/Large: 16px, Regular, Line Height 24px
  - Body/Medium: 14px, Regular, Line Height 20px
  - Caption: 12px, Regular, Line Height 16px
  - Button: 16px, SemiBold, Line Height 24px
```

#### 4-3. 컴포넌트 라이브러리

```yaml
# 생성할 컴포넌트 목록
Components:
  # Buttons
  - Button/Primary (Default, Hover, Pressed, Disabled)
  - Button/Secondary
  - Button/Outline
  - Button/Danger
  - Button/Social/Google
  - Button/Social/Apple
  - Button/FAB

  # Inputs
  - Input/Default (Empty, Filled, Error, Disabled)
  - Input/Password (with toggle)
  - TextArea

  # Selection
  - Checkbox (Unchecked, Checked)
  - Chip/Single (Default, Selected)
  - Chip/Multi (Default, Selected)
  - Switch (Off, On)

  # Cards
  - TodoCard (Default, Completed)
  - CompletedCard

  # Navigation
  - Header (with back button, with actions)
  - BottomNav
  - TabBar

  # Feedback
  - Toast/Success
  - Toast/Error
  - Dialog/Confirm
  - Loading

  # Others
  - Avatar
  - Badge/Priority (High, Normal, Low)
  - ProgressBar
  - DatePicker
  - ListTile
  - Divider
```

### Step 5: 화면별 디자인 생성

#### S01. 온보딩 화면

```yaml
Frame: S01_Onboarding
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Content Area: 0, 44, 375 x 768
    - Illustration: Center, Y: 180, 200 x 200
    - PageIndicator: Center, Y: 420
      - Dots: 3개, 간격 8px, 현재 페이지 Primary
    - Title: Center, Y: 480
      - "할 일을 쉽고 빠르게 관리"
      - Style: Title/Large
    - Description: Center, Y: 520
      - "TodoList로 매일 매일을\n계획적으로 관리하세요."
      - Style: Body/Medium, Text/Secondary
    - Button/Primary: Center, Y: 640, W: 327
      - "시작하기"
    - Link: Center, Y: 700
      - "건너뛰기"
      - Style: Body/Medium, Text/Secondary
```

#### S02. 로그인 화면

```yaml
Frame: S02_Login
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Header: 0, 44, 375 x 56
    - Title: "로그인", Center
  - Content Area: 24, 120, 327 x auto
    - Logo: Center, 80 x 80
    - Spacing: 40px
    - Input/Email:
      - Label: "이메일"
      - Placeholder: "example@email.com"
    - Spacing: 16px
    - Input/Password:
      - Label: "비밀번호"
      - Placeholder: "••••••••"
      - Suffix: Eye icon toggle
    - Spacing: 24px
    - Button/Primary: Full width
      - "로그인"
    - Spacing: 24px
    - Divider: "또는"
    - Spacing: 24px
    - Button/Social/Google: Full width
      - "Google로 계속하기"
    - Spacing: 12px
    - Button/Social/Apple: Full width
      - "Apple로 계속하기"
    - Spacing: 24px
    - Link: Center
      - "아직 회원이 아니신가요? 회원가입"
```

#### S03. 홈 화면

```yaml
Frame: S03_Home
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Header: 0, 44, 375 x 56
    - Title: "오늘의 할 일", Left
    - IconButton: Settings, Right
  - TabBar: 0, 100, 375 x 48
    - Tabs: ["오늘", "전체", "태그별"]
    - Selected: "오늘"
  - ProgressSection: 24, 160, 327 x 60
    - Label: "오늘의 진행률"
    - ProgressBar: 60% filled
    - Text: "3/5"
  - TodoList: 0, 236, 375 x 460 (Scrollable)
    - TodoCard x 4:
      1. "프로젝트 회의 준비", 오늘 18:00, Priority/High
      2. "운동 하기", 오늘 14:00, Priority/Normal
      3. "책 1장 읽기", 오늘 13:00, Priority/Low
      4. "이메일 확인", 완료됨, Strikethrough
  - FAB: Right 24, Bottom 100
    - Icon: Plus
    - Color: Primary
  - BottomNav: 0, 728, 375 x 84
    - Items: [홈(selected), 검색, 완료, 마이]
```

#### S04. 할 일 추가 화면

```yaml
Frame: S04_AddTodo
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Header: 0, 44, 375 x 56
    - BackButton: Left
    - Title: "할 일 추가", Center
  - Content Area: 24, 120, 327 x auto (Scrollable)
    - Input/Title:
      - Label: "제목 *"
      - Placeholder: "할 일을 입력하세요"
    - Spacing: 20px
    - TextArea/Memo:
      - Label: "메모"
      - Placeholder: "상세 내용을 입력하세요"
      - Height: 100px
    - Spacing: 20px
    - DatePicker:
      - Label: "마감일"
      - Icon: Calendar
      - Placeholder: "날짜 선택"
    - Spacing: 20px
    - ChipGroup/Priority:
      - Label: "우선순위"
      - Chips: ["높음"(red), "보통"(yellow, selected), "낮음"(green)]
    - Spacing: 20px
    - ChipGroup/Tags:
      - Label: "태그"
      - Chips: ["업무", "개인", "학습", "+"]
    - Spacing: 40px
    - Button/Primary: Full width
      - "저장하기"
```

#### S05. 할 일 상세 화면

```yaml
Frame: S05_TodoDetail
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Header: 0, 44, 375 x 56
    - BackButton: Left
    - Title: "할 일 상세", Center
  - Content Area: 24, 120, 327 x auto
    - Title Section:
      - Title: "프로젝트 회의 준비", Title/Large
      - Badge/Priority: "높음", Right aligned
    - Spacing: 24px
    - Info Section:
      - Row: Icon(Calendar) + "마감일" + "2026.03.10 18:00"
      - Row: Icon(Clock) + "생성일" + "2026.03.05 09:30"
    - Spacing: 24px
    - Memo Section:
      - Label: "메모", with Icon
      - Divider
      - Content: "Figma로 만든 시안 피드백을\n발표 자료에 포함시키면 좋을 듯."
      - Divider
    - Spacing: 40px
    - Button Group:
      - Button/Outline: "수정", Half width
      - Button/Danger: "삭제", Half width
    - Spacing: 16px
    - Button/Primary: "할 일 완료", Full width
```

#### S06. 완료 목록 화면

```yaml
Frame: S06_CompletedList
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Header: 0, 44, 375 x 56
    - Title: "완료 목록", Left
    - IconButton: Trash, Right
  - Summary: 24, 116, 327 x 24
    - Text: "이번 주 완료 5건", Caption, Text/Secondary
  - CompletedList: 0, 156, 375 x 488 (Scrollable)
    - CompletedCard x 4:
      1. "팀원 피드백 정리", 오늘 14:22, RestoreIcon
      2. "프로젝트 계획서", 어제, RestoreIcon
      3. "디자인 검토", 3월 2일, RestoreIcon
      4. "문서 작성", 2월 28일, RestoreIcon
  - Hint: Center, Y: 660
    - Text: "← 스와이프하여 삭제", Caption, Text/Secondary
  - BottomNav: 0, 728, 375 x 84
    - Items: [홈, 검색, 완료(selected), 마이]
```

#### S07. 마이페이지 화면

```yaml
Frame: S07_MyPage
Size: 375 x 812

Layout:
  - StatusBar: 0, 0, 375 x 44
  - Header: 0, 44, 375 x 56
    - Title: "마이페이지", Center
  - Profile Section: Center, Y: 140
    - Avatar: 80 x 80, with placeholder icon
    - Spacing: 16px
    - Nickname: "홍길동", Title/Medium
    - Email: "hong@example.com", Body/Medium, Text/Secondary
  - Divider: Y: 280
  - Settings List: 24, 300, 327 x auto
    - ListTile: "알림 설정" + Switch(On)
    - ListTile: "테마" + Chevron
    - ListTile: "비밀번호 변경" + Chevron
    - ListTile: "로그아웃" + Chevron
  - Divider: Y: 500
  - Button/Outline: Center, Y: 540, W: 327
    - "로그아웃"
  - BottomNav: 0, 728, 375 x 84
    - Items: [홈, 검색, 완료, 마이(selected)]
```

### Step 6: Figma MCP 도구 사용

#### 6-1. 파일 추가/조회

```
# 기존 Figma 파일에 추가할 경우
mcp__figma-mcp__add_figma_file
- fileUrl: "https://www.figma.com/file/{FILE_ID}"

# 특정 노드 조회
mcp__figma-mcp__view_node
- fileKey: "{FILE_ID}"
- nodeId: "{NODE_ID}"
```

#### 6-2. 코멘트 추가 (디자인 가이드)

```
# 화면별 디자인 가이드 코멘트 추가
mcp__figma-mcp__post_comment
- fileKey: "{FILE_ID}"
- message: "디자인 가이드: ..."
- x, y: 코멘트 위치
```

### Step 7: 결과 보고

생성 완료 후 다음 정보 제공:

```
✅ Figma 디자인 생성 완료!

생성된 디자인:
📁 TodoList App
├── 📄 Design System
│   ├── Colors: {n}개 스타일
│   ├── Typography: {n}개 스타일
│   └── Components: {n}개 컴포넌트
├── 📄 Screens - Light
│   ├── S01_Onboarding ✅
│   ├── S02_Login ✅
│   ├── S03_Home ✅
│   ├── S04_AddTodo ✅
│   ├── S05_TodoDetail ✅
│   ├── S06_CompletedList ✅
│   └── S07_MyPage ✅

Figma 파일 URL: {URL}

다음 단계:
1. 디자인 리뷰 및 피드백
2. 다크모드 디자인 추가 (Could Have)
3. 프로토타입 연결
4. 개발자 핸드오프 준비
```

---

## Design Specifications

### 공통 스타일 가이드

#### 그림자 (Shadow)

```yaml
Shadow/Small:
  - X: 0, Y: 1
  - Blur: 2
  - Color: rgba(0, 0, 0, 0.05)

Shadow/Medium:
  - X: 0, Y: 4
  - Blur: 6
  - Color: rgba(0, 0, 0, 0.1)

Shadow/Large:
  - X: 0, Y: 10
  - Blur: 15
  - Color: rgba(0, 0, 0, 0.1)
```

#### 아이콘

```yaml
Icon Size:
  - Small: 16 x 16
  - Medium: 24 x 24
  - Large: 32 x 32

Icon Style: Outlined (기본)
Icon Set: Material Icons 또는 Phosphor Icons 권장
```

#### 상태 표시

```yaml
States:
  Default: 기본 상태
  Hover: opacity 90% 또는 색상 변화
  Pressed: opacity 80% 또는 scale 0.98
  Disabled: opacity 50%
  Focused: 2px Primary 테두리
```

---

## Component Variants

### Button Variants

```yaml
Button/Primary:
  Variants:
    - State: [Default, Hover, Pressed, Disabled]
  Properties:
    - Background: Primary/500 (Default), Primary/600 (Hover), Primary/700 (Pressed), Neutral/200 (Disabled)
    - Text: White
    - Height: 48px
    - Border Radius: 8px
    - Padding: 16px 24px

Button/Secondary:
  Properties:
    - Background: Neutral/100
    - Text: Text/Primary
    - Border: 1px Neutral/300

Button/Outline:
  Properties:
    - Background: Transparent
    - Text: Primary/500
    - Border: 1px Primary/500

Button/Danger:
  Properties:
    - Background: Error/500
    - Text: White

Button/Social:
  Variants:
    - Provider: [Google, Apple]
  Properties:
    - Height: 48px
    - Border: 1px Neutral/300
    - Icon: Provider logo (24x24)
```

### Input Variants

```yaml
Input/Default:
  Variants:
    - State: [Empty, Filled, Focused, Error, Disabled]
  Properties:
    - Height: 48px
    - Border: 1px Neutral/300 (Default), Primary/500 (Focused), Error/500 (Error)
    - Border Radius: 8px
    - Padding: 12px 16px
    - Label: Above, Body/Medium
    - Placeholder: Text/Disabled
```

### Card Variants

```yaml
TodoCard:
  Variants:
    - State: [Default, Completed]
    - Priority: [High, Normal, Low]
  Properties:
    - Background: White
    - Border Radius: 12px
    - Shadow: Shadow/Small
    - Padding: 16px
  Children:
    - Checkbox: Left, 24x24
    - Title: Body/Large (Strikethrough if Completed)
    - DueDate: Caption, Text/Secondary
    - PriorityBadge: Right, 8x8 circle
```

---

## Auto Layout 설정

### 화면 기본 구조

```yaml
Screen Frame:
  - Auto Layout: Vertical
  - Padding: 0
  - Gap: 0
  - Alignment: Top, Left

Content Area:
  - Auto Layout: Vertical
  - Padding: 24px horizontal
  - Gap: 16px (기본)
  - Fill: Horizontal
```

### 리스트 아이템

```yaml
List:
  - Auto Layout: Vertical
  - Gap: 8px
  - Fill: Horizontal

ListItem (Card):
  - Auto Layout: Horizontal
  - Padding: 16px
  - Gap: 12px
  - Alignment: Center, Left
```

---

## Prototype 연결 가이드

### 화면 전환

```yaml
Transitions:
  - 기본 전환: Smart Animate, 300ms, Ease Out
  - 모달: Move In (Bottom), 300ms
  - 뒤로가기: Move Out (Right), 250ms

Interactive Components:
  - Button: On Tap -> Navigate
  - Card: On Tap -> Navigate
  - Checkbox: On Tap -> Change to (variant)
  - Switch: On Tap -> Change to (variant)
```

### 플로우 연결

```yaml
Flows:
  1. 온보딩 -> 로그인
  2. 로그인 -> 홈
  3. 홈 (FAB) -> 추가
  4. 홈 (Card) -> 상세
  5. 상세 (수정) -> 수정
  6. 상세 (완료) -> 홈
  7. 완료 (복원) -> 홈
```

---

## Notes

- Figma MCP 도구가 연결되어 있어야 함
- 실제 Figma 파일 생성은 MCP 도구의 기능에 따라 제한될 수 있음
- 컴포넌트는 Figma의 Auto Layout 기능 활용 권장
- 반응형 디자인을 위해 Constraints 설정 필요
- 다크모드는 Color Styles의 변수(Variables) 기능 활용 권장
