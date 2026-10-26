# cat-theme-hook

Claude Code 플러그인 마켓플레이스. 세션을 시작할 때마다 고양이 테마를 하나 골라 시작 배너를 띄우고, Claude 답변 말투를 `~냥` 반말로 바꾸는 SessionStart 훅이다.

## 설치

Claude Code에서 아래 명령을 한 줄씩 따로 실행한다.

1. 마켓플레이스 추가

   ```
   /plugin marketplace add Jbs1214/cat-theme-hook
   ```

2. 플러그인 설치

   ```
   /plugin install cat-theme@cat-theme-hook
   ```

설치 후 새 세션을 열면 적용된다.

### 요구 사항

- Windows PowerShell (`powershell` 명령). macOS·Linux는 지원하지 않는다.

### 끄기 / 지우기

```
/plugin disable cat-theme@cat-theme-hook
/plugin uninstall cat-theme@cat-theme-hook
```

## 동작

새 세션(`startup`)이 시작될 때 한 번 실행된다. `/clear`, 재개(`resume`)에서는 실행되지 않는다.

1. 테마 7종 중 하나를 무작위로 고른다. 직전 세션 테마는 제외한다.

   | id | 이름 | 얼굴 |
   |---|---|---|
   | cheese | 🧀 치즈냥 | `ฅ^•ﻌ•^ฅ` |
   | mackerel | 🐟 고등어냥 | `(=^･ω･^=)` |
   | sakura | 🌸 삼색냥 | `ฅ^•ﻌ•^ฅ` |
   | tuxedo | 🎩 턱시도냥 | `(=^-ω-^=)` |
   | black | 🌙 까망냥 | `ᓚᘏᗢ` |
   | blue | 💎 러블냥 | `(^･ω･^)` |
   | kitten | 🍼 아기냥 | `(=^･ｪ･^=)` |

2. 시작 배너(`systemMessage`)로 테마와 응원 한마디를 사용자에게 보여준다.
3. `additionalContext`로 Claude에게 말투 규칙을 전달한다: 모든 답변을 반말 + 문장 끝 `~냥`으로 쓰고, 코드·명령어·로그·커밋 메시지·파일 내용에는 적용하지 않는다.
4. 현재 테마를 `~/.claude/cat-theme.json`에 저장한다 (예: `{"id":"mackerel","name":"고등어냥","face":"(=^･ω･^=)","color":110}`). 상태줄 스크립트가 이 파일을 읽으면 상태줄 고양이도 같은 테마로 맞출 수 있다. `color`는 256색 코드다.

## 사용 예시

### 시작 배너

세션을 열면 이렇게 뜬다.

```
SessionStart:startup says: 🐟 오늘의 고양이: 고등어냥  (=^･ω･^=)
 /\_/\
( o.o )  에러 메시지는 힌트다냥, 겁먹지 말자냥
 > ^ <
```

### 답변 말투

```
> 이 함수 왜 None 돌려줘?

`parse()`가 빈 문자열일 때 return 없이 끝나서 None이 나온다냥.
빈 입력이면 빈 리스트를 돌려주게 고칠까냥?
```

코드 블록, 명령어, 커밋 메시지에는 `~냥`이 붙지 않는다.

### 상태줄에서 테마 읽기 (선택)

상태줄 스크립트에서 `~/.claude/cat-theme.json`을 읽어 쓰면 된다. PowerShell 예:

```powershell
$cat = Get-Content "$HOME/.claude/cat-theme.json" -Raw -Encoding UTF8 | ConvertFrom-Json
"$([char]27)[38;5;$($cat.color)m$($cat.face) $($cat.name)$([char]27)[0m"
```

## 커스터마이즈

`plugins/cat-theme/hooks/cat-theme.ps1`을 고친다.

- `$Themes`: 테마 추가·삭제 (`id`, `name`, `emoji`, `face`, `color`)
- `$Cheers`: 응원 한마디 목록
- `$Context`: Claude에게 전달하는 말투 규칙

## 구조

```
.claude-plugin/marketplace.json        마켓플레이스 정의
plugins/cat-theme/
  .claude-plugin/plugin.json           플러그인 정의
  hooks/hooks.json                     SessionStart(startup) 훅 등록
  hooks/cat-theme.ps1                  훅 스크립트
```
