/**
 * KiroGhost.pde
 * ------------------------------------------------------------
 * Vibe Coding Lab 01 - 'Kiro의 유령' 캐릭터 렌더링
 *
 * Processing(4.x, Java 모드)으로 귀여운 유령 캐릭터 "Kiro"를
 * 화면에 그리고, 위아래로 떠다니는 부유(floating) 애니메이션과
 * 눈 깜빡임, 물결치는 아랫단, 반짝이는 별 배경을 표현한다.
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
  float bodyH = 260;   // 몸통 높이
  float topR  = bodyW / 2;

  // 부드러운 외곽 글로우
  noStroke();
  for (int g = 6; g >= 1; g--) {
    fill(170, 210, 255, 10);
    ellipse(0, -bodyH * 0.1, bodyW + g * 16, bodyH + g * 16);
  }

  // 몸통(머리 반원 + 세로 벽 + 물결 아랫단)
  fill(240, 248, 255);
  noStroke();
  beginShape();
  // 왼쪽 벽 위로 올라가기
  vertex(-topR, bodyH / 2 - topR);
  // 머리 반원 (왼→위→오른쪽)
  for (float a = PI; a <= TWO_PI; a += 0.1) {
    float x = cos(a) * topR;
    float y = sin(a) * topR - (bodyH / 2 - topR);
    vertex(x, y);
  }
  // 오른쪽 벽 내려오기
  vertex(topR, bodyH / 2 - topR);

  // 아랫단 물결 (오른쪽 → 왼쪽)
  int waves = 4;
  float waveW = bodyW / waves;
  float baseY = bodyH / 2 - topR;
  for (int i = 0; i <= waves; i++) {
    float x = topR - i * waveW;
    // 물결이 시간에 따라 출렁이도록
    float wobble = sin(frameCount * 0.08 + i * 1.1) * 10;
    float y = baseY + ((i % 2 == 0) ? 42 : 16) + wobble;
    vertex(x, y);
  }
  endShape(CLOSE);

  // 볼 홍조
  noStroke();
  fill(255, 170, 190, 120);
  ellipse(-70, 20, 46, 30);
  ellipse( 70, 20, 46, 30);

  // 눈
  drawEyes();

  // 입
  drawMouth();

  // 이름표: "Kiro"
  fill(90, 120, 200);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Kiro", 0, -bodyH * 0.42);
}

// ----- 눈 -----
void drawEyes() {
  float eyeY  = -20;
  float eyeDX = 48;
  if (blinking) {
    // 감은 눈: 짧은 선
    stroke(40, 50, 80);
    strokeWeight(5);
    line(-eyeDX - 14, eyeY, -eyeDX + 14, eyeY);
    line( eyeDX - 14, eyeY,  eyeDX + 14, eyeY);
    noStroke();
  } else {
    // 뜬 눈: 검은 눈 + 하이라이트
    noStroke();
    fill(40, 50, 80);
    ellipse(-eyeDX, eyeY, 34, 42);
    ellipse( eyeDX, eyeY, 34, 42);
    fill(255);
    ellipse(-eyeDX + 7, eyeY - 8, 11, 11);
    ellipse( eyeDX + 7, eyeY - 8, 11, 11);
  }
}

// ----- 입 -----
void drawMouth() {
  noFill();
  stroke(40, 50, 80);
  strokeWeight(4);
  // 작은 미소 (호)
  arc(0, 28, 46, 36, 0.15 * PI, 0.85 * PI);
  noStroke();
}

// ----- 하단 안내 문구 -----
void drawCaption() {
  fill(255, 255, 255, 180);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Vibe Coding Lab 01 - Kiro the Ghost  (Processing)", width / 2, height - 24);
}
