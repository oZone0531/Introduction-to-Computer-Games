/**
 * KiroGhost_Secondattempt.pde
 * ------------------------------------------------------------
 * Vibe Coding Lab 01 - 'Kiro의 유령' 캐릭터 렌더링 (2차 수정)
 *
 * Kiro Agent AI 마스코트에 어울리도록 미니멀하게 다듬은 버전.
 *   - 눈 하이라이트 제거 (단색 눈)
 *   - 볼 홍조 제거
 *   - 입 제거
 *   - 몸통을 더 길게 (물결 아랫단을 아래로 내려 길쭉한 실루엣)
 *   - 아랫단 물결을 직선이 아닌 부드러운 곡선(curveVertex)으로 표현
 *
 * 실행: Processing에서 이 폴더를 열고 Run(▶) 버튼을 누른다.
 * ------------------------------------------------------------
 */

// ----- 전역 상태 -----
float floatOffset = 0;      // 유령이 떠다니는 수직 오프셋
int   blinkTimer  = 0;      // 눈 깜빡임 타이머(프레임 단위)
boolean blinking  = false;  // 현재 깜빡이는 중인지

// 배경 별
int   STAR_COUNT = 60;
float[] starX, starY, starSize, starPhase;

void setup() {
  size(600, 600);
  // 별 좌표 초기화
  starX     = new float[STAR_COUNT];
  starY     = new float[STAR_COUNT];
  starSize  = new float[STAR_COUNT];
  starPhase = new float[STAR_COUNT];
  for (int i = 0; i < STAR_COUNT; i++) {
    starX[i]     = random(width);
    starY[i]     = random(height);
    starSize[i]  = random(1, 3.5);
    starPhase[i] = random(TWO_PI);
  }
  // 깜빡임 첫 예약
  blinkTimer = int(random(60, 180));
}

void draw() {
  drawBackground();
  drawStars();

  // 부유 애니메이션: sin 곡선으로 위아래 이동
  floatOffset = sin(frameCount * 0.04) * 18;

  // 깜빡임 상태 갱신
  updateBlink();

  // 유령을 화면 중앙에 배치
  pushMatrix();
  translate(width / 2, height / 2 + floatOffset);
  drawGhost();
  popMatrix();

  drawCaption();
}

// ----- 배경 -----
void drawBackground() {
  // 위에서 아래로 어두운 보라 → 짙은 남색 그라데이션
  for (int y = 0; y < height; y++) {
    float t = map(y, 0, height, 0, 1);
    color c = lerpColor(color(40, 20, 70), color(12, 10, 35), t);
    stroke(c);
    line(0, y, width, y);
  }
}

// ----- 반짝이는 별 -----
void drawStars() {
  noStroke();
  for (int i = 0; i < STAR_COUNT; i++) {
    float twinkle = 150 + 105 * sin(frameCount * 0.05 + starPhase[i]);
    fill(255, 255, 230, twinkle);
    ellipse(starX[i], starY[i], starSize[i], starSize[i]);
  }
}

// ----- 눈 깜빡임 로직 -----
void updateBlink() {
  blinkTimer--;
  if (blinkTimer <= 0) {
    if (!blinking) {
      blinking = true;
      blinkTimer = 8;             // 눈을 감고 있는 프레임 수
    } else {
      blinking = false;
      blinkTimer = int(random(90, 220)); // 다음 깜빡임까지 대기
    }
  }
}

// ----- 유령 본체 -----
void drawGhost() {
  float bodyW = 220;   // 몸통 너비
  float bodyH = 360;   // 몸통 높이 (길쭉하게 늘림: 260 -> 360)
  float topR  = bodyW / 2;

  // 부드러운 외곽 글로우
  noStroke();
  for (int g = 6; g >= 1; g--) {
    fill(170, 210, 255, 10);
    ellipse(0, -bodyH * 0.1, bodyW + g * 16, bodyH + g * 16);
  }

  // 몸통(머리 반원 + 세로 벽 + 곡선 물결 아랫단)
  fill(240, 248, 255);
  noStroke();

  float wallBottom = bodyH / 2 - topR;  // 세로 벽이 끝나는 y (물결 시작점)

  beginShape();
  // 왼쪽 벽 위로 올라가기
  vertex(-topR, wallBottom);
  // 머리 반원 (왼→위→오른쪽)
  for (float a = PI; a <= TWO_PI; a += 0.1) {
    float x = cos(a) * topR;
    float y = sin(a) * topR - wallBottom;
    vertex(x, y);
  }
  // 오른쪽 벽 내려오기
  vertex(topR, wallBottom);

  // ----- 아랫단 물결: 부드러운 곡선(curveVertex) -----
  // curveVertex는 양 끝에 보조(앵커) 점이 필요하므로
  // 오른쪽 벽 아래점을 한 번 더 찍어 시작 앵커로 사용한다.
  int   waves    = 4;                    // 물결 봉우리/골 개수
  float waveW    = bodyW / waves;        // 물결 한 칸의 가로 폭
  float dipDeep  = 70;                   // 깊게 내려가는 골 (아래로 더 내림)
  float dipShort = 30;                   // 얕게 내려가는 골

  // 시작 앵커(오른쪽 벽 바닥)
  curveVertex(topR, wallBottom);
  // 오른쪽 -> 왼쪽으로 물결 곡선 생성
  for (int i = 0; i <= waves; i++) {
    float x = topR - i * waveW;
    // 시간에 따라 출렁이는 효과
    float wobble = sin(frameCount * 0.08 + i * 1.1) * 10;
    float y = wallBottom + ((i % 2 == 0) ? dipDeep : dipShort) + wobble;
    curveVertex(x, y);
  }
  // 끝 앵커(왼쪽 벽 바닥)
  curveVertex(-topR, wallBottom);

  endShape(CLOSE);

  // 눈 (하이라이트/홍조/입 없이 단색 눈만)
  drawEyes();

  // 이름표: "Kiro"
  fill(90, 120, 200);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Kiro", 0, -bodyH * 0.42);
}

// ----- 눈 (단색, 하이라이트 없음) -----
void drawEyes() {
  float eyeY  = -40;   // 몸통이 길어진 만큼 눈을 살짝 위로
  float eyeDX = 48;
  if (blinking) {
    // 감은 눈: 짧은 선
    stroke(40, 50, 80);
    strokeWeight(5);
    line(-eyeDX - 14, eyeY, -eyeDX + 14, eyeY);
    line( eyeDX - 14, eyeY,  eyeDX + 14, eyeY);
    noStroke();
  } else {
    // 뜬 눈: 단색 (하이라이트 제거)
    noStroke();
    fill(40, 50, 80);
    ellipse(-eyeDX, eyeY, 34, 42);
    ellipse( eyeDX, eyeY, 34, 42);
  }
}

// ----- 하단 안내 문구 -----
void drawCaption() {
  fill(255, 255, 255, 180);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Vibe Coding Lab 01 - Kiro the Ghost (2nd attempt)  (Processing)", width / 2, height - 24);
}
