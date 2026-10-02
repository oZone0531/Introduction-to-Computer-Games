# Vibe Coding Lab 01 — Kiro the Ghost 👻

Processing(4.x, Java 모드)으로 **'Kiro의 유령' 캐릭터**를 화면에 렌더링하는 실습입니다.

## 미리보기 (렌더링되는 모습)

- 어두운 보라 → 남색 그라데이션 밤하늘 배경
- 반짝이는(twinkle) 별 60개
- 화면 중앙에 둥둥 떠다니는(float) 흰색 유령 **Kiro**
  - 위아래 부유 애니메이션 (`sin` 곡선)
  - 주기적인 눈 깜빡임
  - 출렁이는 물결 모양 아랫단
  - 분홍 볼 홍조와 미소
  - 머리 위 "Kiro" 이름표

## 파일

| 파일 | 설명 |
|------|------|
| `KiroGhost.pde` | 메인 Processing 스케치 |

## 실행 방법

1. [Processing](https://processing.org/download) 4.x 를 설치합니다.
2. `KiroGhost` 폴더를 Processing에서 엽니다.
   - Processing은 스케치 폴더 이름과 `.pde` 파일 이름이 같아야 합니다 (여기서는 둘 다 `KiroGhost`).
3. 상단의 **Run(▶)** 버튼을 누르면 600×600 창에 Kiro 유령이 나타납니다.

### 명령줄로 실행 (선택)

Processing CLI(`processing-java`)가 설치되어 있다면:

```bash
processing-java --sketch="$(pwd)/KiroGhost" --run
```

## 코드 포인트

- `drawBackground()` : `lerpColor`로 세로 그라데이션을 한 줄씩 그림
- `drawStars()` : `sin`으로 투명도를 흔들어 반짝임 표현
- `drawGhost()` : `beginShape()/vertex()`로 머리 반원 + 물결 아랫단을 한 번에 그림
- `updateBlink()` : 랜덤 타이머로 자연스러운 눈 깜빡임 구현
- `floatOffset` : `sin(frameCount)`으로 상하 부유 애니메이션

## 커스터마이즈 아이디어

- `size(600, 600)` 값을 바꿔 창 크기 조절
- `STAR_COUNT`로 별 개수 조절
- `drawGhost()`의 `bodyW`, `bodyH`로 유령 크기 조절
- 색상(`fill`) 값을 바꿔 유령 테마 변경
