# SessionStart: 세션마다 고양이 테마를 하나 골라 배너·상태줄 고양이를 바꾼다
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$Utf8 = New-Object Text.UTF8Encoding($false)
$StatePath    = "$HOME/.claude/cat-theme.json"

# face: 배너·상태줄 고양이, color: 256색 코드
$Themes = @(
    @{ id='cheese'; name='치즈냥'; emoji='🧀'; face='ฅ^•ﻌ•^ฅ'; color=214 }
    @{ id='mackerel'; name='고등어냥'; emoji='🐟'; face='(=^･ω･^=)'; color=110 }
    @{ id='sakura'; name='삼색냥'; emoji='🌸'; face='ฅ^•ﻌ•^ฅ'; color=216 }
    @{ id='tuxedo'; name='턱시도냥'; emoji='🎩'; face='(=^-ω-^=)'; color=252 }
    @{ id='black'; name='까망냥'; emoji='🌙'; face='ᓚᘏᗢ'; color=141 }
    @{ id='blue'; name='러블냥'; emoji='💎'; face='(^･ω･^)'; color=75 }
    @{ id='kitten'; name='아기냥'; emoji='🍼'; face='(=^･ｪ･^=)'; color=223 }
)

# 직전 테마는 제외하고 무작위 선택
$Last = try { ([IO.File]::ReadAllText($StatePath, $Utf8) | ConvertFrom-Json).id } catch { $null }
$Theme = $Themes | Where-Object { $_.id -ne $Last } | Get-Random

# 1) 상태줄이 읽을 현재 테마 저장
[IO.File]::WriteAllText($StatePath, (@{ id=$Theme.id; name=$Theme.name; face=$Theme.face; color=$Theme.color } | ConvertTo-Json -Compress), $Utf8)

# 2) 시작 배너
# 세션마다 무작위로 고르는 응원 한마디
$Cheers = @(
    '오늘도 한 줄씩 차근차근이면 충분하다냥'
    '막히는 버그도 결국 다 풀린다냥, 같이 보자냥'
    '어제보다 조금만 나아가도 대단한 거다냥'
    '쉬어 가는 것도 실력이다냥, 물 한 잔 마시고 하자냥'
    '에러 메시지는 힌트다냥, 겁먹지 말자냥'
    '작게 커밋하고 크게 뿌듯해하자냥'
    '여기까지 온 것만으로도 잘하고 있다냥'
    '모르는 건 부끄러운 게 아니다냥, 물어보면 된다냥'
    '오늘 배운 한 가지가 내일의 무기다냥'
    '완벽보다 완성이 먼저다냥, 일단 돌려 보자냥'
    '꾹꾹이 응원 보낸다냥, 오늘도 화이팅이다냥'
    '천천히 가도 멈추지만 않으면 된다냥'
)
$Cheer = $Cheers | Get-Random

# 첫 줄은 "SessionStart:startup says:" 뒤에 붙어 나오므로 글자만 두고, 고양이 그림은 다음 줄부터 둔다
$Banner = @"
$($Theme.emoji) 오늘의 고양이: $($Theme.name)  $($Theme.face)
 /\_/\
( o.o )  $Cheer
 > ^ <
"@
# 3) 답변 말투: systemMessage 는 사용자에게만 보이므로 additionalContext 로 Claude 에게 전달
$Context = "이번 세션의 고양이 테마는 $($Theme.name)이다. 사용자에게 하는 모든 답변은 반말로만 쓰고 문장 끝을 '~냥'으로 한다(예: '확인했다냥', '이거 고칠까냥?', '새 세션에서 확인해 봐냥'). 존댓말('-요', '-습니다', '-세요', '주시면', '드릴게')은 섞지 않는다. 코드·명령어·식별자·로그·커밋 메시지·파일 내용에는 적용하지 않는다."
@{
    systemMessage = $Banner
    hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $Context }
} | ConvertTo-Json -Compress -Depth 3
exit 0
