# TodoList App - Figma Import Guide

Figma URL: https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled

## Overview

이 문서는 HTML 디자인 시안(`todolist_design_mockup.html`)을 Figma에 옮기기 위한 상세 가이드입니다.

---

## 1. Figma Page Structure

```
Page 1: Cover
Page 2: Design System
Page 3: S01_Onboarding
Page 4: S02_Login
Page 5: S03_Home
Page 6: S04_AddTodo
Page 7: S05_TodoDetail
Page 8: S06_CompletedList
Page 9: S07_MyPage
```

---

## 2. Design Tokens (Figma Variables / Styles)

### 2-1. Color Styles

| Style Name | Hex | Use |
|---|---|---|
| Primary/500 | #2563EB | Primary actions, links |
| Primary/400 | #3B82F6 | Hover state |
| Primary/600 | #1D4ED8 | Pressed state |
| Primary/700 | #1E40AF | Active state |
| Secondary | #64748B | Secondary text |
| Success | #22C55E | Success state, Priority Low |
| Warning | #F59E0B | Warning state, Priority Normal |
| Error | #EF4444 | Error state, Priority High |
| Background | #FFFFFF | Page background |
| Surface | #F8FAFC | Card/Section background |
| Border | #E2E8F0 | Borders, dividers |
| Text/Primary | #1F2937 | Main text |
| Text/Secondary | #6B7280 | Sub text |
| Text/Disabled | #9CA3AF | Placeholder, disabled |

### 2-2. Text Styles

| Style Name | Size | Weight | Line Height |
|---|---|---|---|
| Title/Large | 24px | Bold (700) | 32px |
| Title/Medium | 20px | SemiBold (600) | 28px |
| Title/Small | 16px | SemiBold (600) | 24px |
| Body/Large | 16px | Regular (400) | 24px |
| Body/Medium | 14px | Regular (400) | 20px |
| Caption | 12px | Regular (400) | 16px |
| Button | 16px | SemiBold (600) | 24px |

Font Family: Pretendard (Korean) / SF Pro Display (fallback)

### 2-3. Effect Styles

| Style Name | X | Y | Blur | Color |
|---|---|---|---|---|
| Shadow/Small | 0 | 1 | 2 | rgba(0,0,0,0.05) |
| Shadow/Medium | 0 | 4 | 6 | rgba(0,0,0,0.1) |
| Shadow/Large | 0 | 10 | 15 | rgba(0,0,0,0.1) |

---

## 3. Frame Specifications

Base Frame: **390 x 844** (iPhone 14)

### Common Layout

```
Status Bar:   H=54px  (includes dynamic island area)
Header:       H=56px  (title + actions)
Tab Bar:      H=44px  (when present)
Bottom Nav:   H=84px  (includes home indicator: 20px)
Content Area: Fill remaining
```

---

## 4. Screen-by-Screen Specifications

### S01: Onboarding (390 x 844)

```
[Frame: S01_Onboarding]
├── StatusBar (0, 0, 390x54)
└── Content (Auto Layout: Vertical, Center aligned)
    ├── Illustration Circle (200x200, center)
    │   └── Background: linear-gradient(135deg, #EFF6FF, #DBEAFE)
    │   └── Icon: Checklist SVG (80x80)
    ├── [Spacer: 32px]
    ├── PageIndicator (horizontal, gap:8)
    │   ├── Dot Active (24x8, radius:4, fill:Primary/500)
    │   ├── Dot (8x8, radius:4, fill:Border)
    │   └── Dot (8x8, radius:4, fill:Border)
    ├── [Spacer: 32px]
    ├── Title: "할 일을 쉽고 빠르게 관리"
    │   └── Style: Title/Large, center
    ├── [Spacer: 12px]
    ├── Description: "TodoList로 매일 매일을\n계획적으로 관리하세요."
    │   └── Style: Body/Large, center, color:Text/Secondary
    ├── [Spacer: 48px]
    ├── Button/Primary: "시작하기"
    │   └── W: 342 (390-24*2), H: 48, radius: 8
    ├── [Spacer: 16px]
    └── Link: "건너뛰기"
        └── Style: Body/Medium, center, color:Text/Secondary
```

### S02: Login (390 x 844)

```
[Frame: S02_Login]
├── StatusBar (0, 0, 390x54)
├── Header (0, 54, 390x56)
│   └── Title: "로그인" (center, Title/Small)
└── Content (Auto Layout: Vertical, padding: 0 24px)
    ├── App Logo (72x72, center, radius:16)
    │   └── Background: linear-gradient(135deg, #2563EB, #3B82F6)
    │   └── Icon: Checklist white SVG
    ├── [Spacer: 32px]
    ├── Input/Email
    │   ├── Label: "이메일" (Body/Medium, SemiBold)
    │   └── Field (H:48, radius:8, border:1.5px Border)
    │       └── Placeholder: "example@email.com"
    ├── [Spacer: 16px]
    ├── Input/Password
    │   ├── Label: "비밀번호" (Body/Medium, SemiBold)
    │   └── Field (H:48, radius:8, border:1.5px Border)
    │       ├── Placeholder: "........"
    │       └── Icon/Right: Eye (18px, Text/Disabled)
    ├── [Spacer: 24px]
    ├── Button/Primary: "로그인" (Full width, H:48)
    ├── [Spacer: 24px]
    ├── Divider: "또는"
    │   └── Line(1px Border) + Text(Caption, Text/Disabled) + Line
    ├── [Spacer: 24px]
    ├── Button/Social/Google: "Google로 계속하기"
    │   └── Full width, H:48, border:1.5px Border, radius:8
    │   └── Icon: Google logo (20x20)
    ├── [Spacer: 8px]
    ├── Button/Social/Apple: "Apple로 계속하기"
    │   └── Full width, H:48, border:1.5px Border, radius:8
    │   └── Icon: Apple logo (20x20)
    ├── [Spacer: 24px]
    └── SignUp Link (center)
        ├── "아직 회원이 아니신가요? " (Body/Medium, Text/Secondary)
        └── "회원가입" (Body/Medium, SemiBold, Primary/500)
```

### S03: Home (390 x 844)

```
[Frame: S03_Home]
├── StatusBar (0, 0, 390x54)
├── Header (0, 54, 390x56)
│   ├── Title: "오늘의 할 일" (left, Title/Medium, Bold)
│   └── Icon/Settings (right, 24x24, Text/Secondary)
├── TabBar (0, 110, 390x44)
│   ├── Tab: "오늘" (active: Primary/500, border-bottom:2px)
│   ├── Tab: "전체" (Text/Secondary)
│   └── Tab: "태그별" (Text/Secondary)
├── ProgressSection (padding: 16px 24px)
│   ├── Row: "오늘의 진행률" + "3/5"
│   │   └── Left: Body/Medium Text/Secondary
│   │   └── Right: Body/Medium SemiBold Primary/500
│   └── ProgressBar (H:8, radius:full, bg:Border)
│       └── Fill (60%, bg:Primary/500)
├── TodoList (padding: 0 16px, gap:8, scrollable)
│   ├── TodoCard
│   │   ├── Checkbox (22x22, radius:6, border:2px Border)
│   │   ├── TodoInfo (flex:1)
│   │   │   ├── Title: "프로젝트 회의 준비" (Body/Large, Medium)
│   │   │   └── Due: "오늘 18:00" (Caption, Text/Secondary)
│   │   └── PriorityDot (10x10, circle, fill:Error)
│   ├── TodoCard
│   │   ├── Checkbox (unchecked)
│   │   ├── TodoInfo
│   │   │   ├── Title: "운동 하기"
│   │   │   └── Due: "오늘 14:00"
│   │   └── PriorityDot (fill:Warning)
│   ├── TodoCard
│   │   ├── Checkbox (unchecked)
│   │   ├── TodoInfo
│   │   │   ├── Title: "책 1장 읽기"
│   │   │   └── Due: "오늘 13:00"
│   │   └── PriorityDot (fill:Success)
│   ├── TodoCard (opacity:0.7)
│   │   ├── Checkbox (checked: fill Primary, checkmark white)
│   │   ├── TodoInfo
│   │   │   ├── Title: "이메일 확인" (strikethrough, Text/Disabled)
│   │   │   └── Due: "오늘"
│   │   └── (no priority dot)
│   └── TodoCard (opacity:0.7)
│       ├── Checkbox (checked)
│       └── Title: "아침 회의 참석" (strikethrough)
├── FAB (absolute, right:24, bottom:100)
│   └── Circle (56x56, fill:Primary/500, shadow:Large)
│   └── Icon: "+" (28px, white)
└── BottomNav (0, 760, 390x84)
    ├── Item: Home (active, Primary/500)
    ├── Item: Search (Text/Disabled)
    ├── Item: Completed (Text/Disabled)
    └── Item: My (Text/Disabled)
```

### S04: Add Todo (390 x 844)

```
[Frame: S04_AddTodo]
├── StatusBar (0, 0, 390x54)
├── Header (0, 54, 390x56)
│   ├── BackButton (left, 40x40, "←")
│   └── Title: "할 일 추가" (center, Title/Small)
└── Content (Auto Layout: Vertical, padding: 16px 24px, gap:20)
    ├── Input/Title
    │   ├── Label: "제목" + "*"(Error color)
    │   └── Field (H:48, placeholder: "할 일을 입력하세요")
    ├── TextArea/Memo
    │   ├── Label: "메모"
    │   └── Area (H:100, placeholder: "상세 내용을 입력하세요")
    ├── DatePicker
    │   ├── Label: "마감일"
    │   └── Picker (H:48, icon:Calendar + "날짜 선택")
    ├── ChipGroup/Priority
    │   ├── Label: "우선순위"
    │   └── Chips (horizontal, gap:8)
    │       ├── Chip: "높음" (border:Error when selected)
    │       ├── Chip: "보통" (selected, border:Warning, bg:#FFFBEB)
    │       └── Chip: "낮음" (border:Success when selected)
    ├── ChipGroup/Tags
    │   ├── Label: "태그"
    │   └── Chips (horizontal, gap:8)
    │       ├── Chip: "업무" (selected, Primary)
    │       ├── Chip: "개인"
    │       ├── Chip: "학습"
    │       └── Chip: "+ 추가" (dashed border)
    ├── [Spacer: fill]
    └── Button/Primary: "저장하기" (Full width, H:48)
```

### S05: Todo Detail (390 x 844)

```
[Frame: S05_TodoDetail]
├── StatusBar (0, 0, 390x54)
├── Header (0, 54, 390x56)
│   ├── BackButton (left, "←")
│   └── Title: "할 일 상세" (center)
└── Content (Auto Layout: Vertical, padding: 24px)
    ├── Title Row (horizontal, space-between)
    │   ├── Title: "프로젝트 회의 준비" (Title/Large-22px, Bold)
    │   └── Badge: "높음" (badge-high)
    ├── Divider (1px, Border)
    ├── InfoRow: Calendar + "마감일" + "2026.03.10 18:00"
    ├── InfoRow: Clock + "생성일" + "2026.03.05 09:30"
    ├── Divider (1px, Border)
    ├── MemoSection (bg:Surface, radius:12, padding:16)
    │   ├── Label: "📝 메모" (Body/Medium, SemiBold, Text/Secondary)
    │   └── Content: "Figma로 만든 시안 피드백을\n발표 자료에 포함시키면 좋을 듯."
    ├── [Spacer: fill]
    ├── ButtonRow (horizontal, gap:12)
    │   ├── Button/Outline: "수정" (flex:1)
    │   └── Button/Danger: "삭제" (flex:1)
    ├── [Spacer: 12px]
    └── Button/Primary: "할 일 완료" (Full width)
```

### S06: Completed List (390 x 844)

```
[Frame: S06_CompletedList]
├── StatusBar (0, 0, 390x54)
├── Header (0, 54, 390x56)
│   ├── Title: "완료 목록" (left, Title/Medium)
│   └── Icon/Trash (right, 24x24, Text/Secondary)
├── Summary: "이번 주 완료 5건"
│   └── Style: Caption, Text/Secondary, padding: 4px 24px 16px
├── CompletedList (padding: 0 16px, gap:8, scrollable)
│   ├── CompletedCard
│   │   ├── Icon: ✅ (20px)
│   │   ├── Info (flex:1)
│   │   │   ├── Title: "팀원 피드백 정리" (strikethrough, Text/Secondary)
│   │   │   └── Date: "오늘 14:22" (Caption, Text/Disabled)
│   │   └── RestoreBtn (36x36, radius:8, bg:#EFF6FF)
│   │       └── Icon: "↩" (Primary/500)
│   ├── CompletedCard: "프로젝트 계획서" / "어제"
│   ├── CompletedCard: "디자인 검토" / "3월 2일"
│   ├── CompletedCard: "문서 작성" / "2월 28일"
│   └── CompletedCard: "코드 리뷰" / "2월 27일"
├── Hint: "← 스와이프하여 삭제" (center, Caption, Text/Disabled)
└── BottomNav (Completed tab active)
```

### S07: MyPage (390 x 844)

```
[Frame: S07_MyPage]
├── StatusBar (0, 0, 390x54)
├── Header (0, 54, 390x56)
│   └── Title: "마이페이지" (center, Title/Small)
└── Content (Auto Layout: Vertical)
    ├── ProfileSection (center aligned, padding: 24px 0 32px)
    │   ├── Avatar (80x80, circle, bg:Surface, border:2px Border)
    │   │   └── Icon: User placeholder (36px, Text/Disabled)
    │   ├── [Spacer: 16px]
    │   ├── Nickname: "홍길동" (Title/Medium)
    │   └── Email: "hong@example.com" (Body/Medium, Text/Secondary)
    ├── Divider (H:8, bg:Surface)
    ├── SettingsList (padding: 0 24px)
    │   ├── ListTile: "알림 설정" + Switch(on)
    │   │   └── H: 56px, border-bottom: 1px Border
    │   ├── ListTile: "테마" + Chevron ">"
    │   ├── ListTile: "비밀번호 변경" + Chevron ">"
    │   └── ListTile: "로그아웃" + Chevron ">" (no bottom border)
    ├── Divider (H:8, bg:Surface)
    ├── LogoutSection (padding: 24px)
    │   └── Button/Outline: "로그아웃"
    │       └── color: Error, border-color: Error
    └── BottomNav (My tab active)
```

---

## 5. Component Library (Figma Components to Create)

### Buttons
| Component | Height | Radius | Background | Text Color | Border |
|---|---|---|---|---|---|
| Button/Primary | 48px | 8px | #2563EB | White | none |
| Button/Outline | 48px | 8px | Transparent | #2563EB | 1.5px #2563EB |
| Button/Danger | 48px | 8px | #EF4444 | White | none |
| Button/Social | 48px | 8px | White | #1F2937 | 1.5px #E2E8F0 |

### Inputs
| Component | Height | Radius | Background | Border |
|---|---|---|---|---|
| Input/Default | 48px | 8px | White | 1.5px #E2E8F0 |
| Input/Focused | 48px | 8px | White | 1.5px #2563EB |
| Input/Error | 48px | 8px | White | 1.5px #EF4444 |
| TextArea | 100px+ | 8px | White | 1.5px #E2E8F0 |

### Chips
| Component | Height | Radius | Background | Border |
|---|---|---|---|---|
| Chip/Default | 36px | full | White | 1.5px #E2E8F0 |
| Chip/Selected | 36px | full | #EFF6FF | 1.5px #2563EB |

### Cards
| Component | Radius | Shadow | Border | Padding |
|---|---|---|---|---|
| TodoCard | 12px | Shadow/Small | 1px #E2E8F0 | 16px |
| CompletedCard | 12px | Shadow/Small | 1px #E2E8F0 | 16px |

### Navigation
| Component | Height | Background |
|---|---|---|
| Header | 56px | White |
| TabBar | 44px | White |
| BottomNav | 84px (incl. 20px safe area) | White |

---

## 6. Quick Import Method

### Method A: html.to.design (Figma Plugin)

1. Figma에서 "html.to.design" 플러그인 설치
2. `todolist_design_mockup.html` 파일을 로컬 서버로 실행
3. 플러그인에서 URL 입력하여 각 화면 import

```bash
# 로컬 서버 실행
cd docs/design
python3 -m http.server 8080
# 브라우저에서 http://localhost:8080/todolist_design_mockup.html 접속
```

### Method B: SVG Import

1. 각 화면별 SVG 파일(`docs/design/screens/` 폴더)을 Figma에 드래그 앤 드롭
2. Auto Layout으로 재구성

### Method C: Manual Recreation

1. 이 가이드 문서의 Screen-by-Screen Specifications를 참고
2. Design System 토큰을 먼저 생성
3. 컴포넌트를 먼저 만든 후 화면 조립

---

## 7. Prototype Connections

| From | Action | To | Transition |
|---|---|---|---|
| S01 "시작하기" | On Tap | S02_Login | Smart Animate, 300ms |
| S01 "건너뛰기" | On Tap | S02_Login | Smart Animate, 300ms |
| S02 "로그인" | On Tap | S03_Home | Smart Animate, 300ms |
| S03 FAB | On Tap | S04_AddTodo | Move In Bottom, 300ms |
| S03 TodoCard | On Tap | S05_Detail | Smart Animate, 300ms |
| S04 "저장하기" | On Tap | S03_Home | Move Out Bottom, 250ms |
| S04 Back | On Tap | S03_Home | Move Out Right, 250ms |
| S05 "수정" | On Tap | S04_AddTodo | Smart Animate, 300ms |
| S05 "할 일 완료" | On Tap | S03_Home | Move Out Right, 250ms |
| S03 BottomNav/완료 | On Tap | S06_Completed | Smart Animate, 200ms |
| S03 BottomNav/마이 | On Tap | S07_MyPage | Smart Animate, 200ms |
| S06 RestoreBtn | On Tap | S03_Home | Smart Animate, 300ms |
