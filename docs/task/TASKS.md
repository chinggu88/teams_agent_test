# TASKS

팀장 Agent가 이 파일을 읽고 사용자 흐름을 분석하여 각 Agent에게 작업을 할당합니다.

---

## 현재 작업

### TASK-001: 로그인 기능

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 디자인 | [Figma](https://figma.com/...) 또는 `docs/designs/login.png` |

#### 2. 사용자 흐름 (User Flow)
```
[앱 실행] → [로그인 화면] → [이메일/비밀번호 입력] → [로그인 버튼 클릭]
                                                          ↓
                                              [성공] → [홈 화면 이동]
                                              [실패] → [에러 메시지 표시]
```

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 이메일 유효성 검사 | 이메일 형식 확인 | 입력 시 실시간 |
| 비밀번호 마스킹 | 비밀번호 숨김/표시 토글 | 아이콘 클릭 |
| 로그인 요청 | API 호출 후 토큰 저장 | 버튼 클릭 |
| 자동 로그인 | 저장된 토큰으로 자동 인증 | 앱 실행 시 |

#### 4. API 정보
**로그인 API**
- **Method**: `POST`
- **Endpoint**: `/auth/login`
- **Request**:
```json
{ "email": "string", "password": "string" }
```
- **Response**:
```json
{ "accessToken": "string", "refreshToken": "string", "user": {...} }
```

#### 5. UI 구성
```
┌─────────────────────────┐
│        [로고]           │
├─────────────────────────┤
│  📧 이메일 입력         │
│  🔒 비밀번호 입력   👁  │
│                         │
│  [    로그인 버튼    ]  │
│                         │
│  회원가입  |  비번찾기  │
└─────────────────────────┘
```
**컴포넌트**: TextField x2, ElevatedButton x1, TextButton x2

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| LoginParameter | `lib/app/data/models/login_parameter.dart` | completed |
| LoginResponse | `lib/app/data/models/login_response.dart` | completed |
| LoginUserResponse | `lib/app/data/models/login_user_response.dart` | completed |
| AuthRepository | `lib/app/data/repositories/auth_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| LoginController | `lib/app/modules/auth/controllers/login_controller.dart` | completed |
| LoginBinding | `lib/app/modules/auth/bindings/login_binding.dart` | completed |
> 의존: API Agent 완료 후

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| LoginView | `lib/app/modules/auth/views/login_view.dart` | completed |
> 의존: Controller Agent 완료 후

---

## 완료된 작업

<!-- 완료된 태스크는 여기로 이동 -->

---

## 템플릿

<!--
### TASK-XXX: 기능명

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | pending / in_progress / completed |
| 우선순위 | high / medium / low |
| 디자인 | [Figma](URL) 또는 `docs/designs/파일명.png` |

#### 2. 사용자 흐름 (User Flow)
```
[시작 화면] → [화면1] → [액션] → [결과 화면]
```

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 기능명 | 기능 설명 | 버튼 클릭 / 입력 시 / 화면 진입 시 |

#### 4. API 정보
**API명**
- **Method**: `GET / POST / PUT / DELETE`
- **Endpoint**: `/api/path`
- **Request**:
```json
{ "field": "type" }
```
- **Response**:
```json
{ "field": "type" }
```

#### 5. UI 구성
```
┌─────────────────────────┐
│      [와이어프레임]     │
└─────────────────────────┘
```
**컴포넌트**: 위젯 목록

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 모델명 | `lib/app/data/models/xxx.dart` | pending |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 컨트롤러명 | `lib/app/modules/xxx/controllers/xxx_controller.dart` | blocked |
> 의존: API Agent 완료 후

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 뷰명 | `lib/app/modules/xxx/views/xxx_view.dart` | blocked |
> 의존: Controller Agent 완료 후
-->
