//사운드
import processing.sound.*;
SoundFile [] sound=new SoundFile[3];
//이미지
PImage img;
//변수
float pika_1_x, pika_1_y, pika_2_x, pika_2_y, ball_x, ball_y, ballSpeedX, ballSpeedY;
//상수
float ground, net, d, jumpHeight, slide_speed, gravity, friction_ground, friction_air, velocity_1, velocity_2, slide_velocity_1, slide_velocity_2;
//구름 관련 변수. 상수
float [] cloud_x, cloud_y, cloud_speed, cloud_size;

int smash_count_1, smash_count_2, score_1, score_2, count_wall_x, count_wall_y, count_pika_1, count_pika_2 = 0;

boolean air_1, air_2, smashing_1, smashing_2, sliding_1, sliding_2, touched_wall_x, touched_wall_y, touched_pika_1, touched_pika_2 = false;
//false: 조작키 정상 작동, true: 조작기 차단
String recent_move_1, recent_move_2 = "rignt";

void setup(){
  size(1200,800);
  for(int i=0;i<3;i++){
    sound[i] = new SoundFile(this,"sound"+nf(i,1)+".mp3");
  }
  sound[0].loop();
  img = loadImage("back_img.png");
  //피카츄 시작 위치
  pika_1_x = 300;
  pika_2_x = 900;
  pika_1_y = pika_2_y = 700;
  //공 시작 위치
  ball_x = 600;
  ball_y = 200;
  //공 초기 가속도
  ballSpeedX = 7;
  ballSpeedY = 3;
  //땅 높이
  ground = 700;
  //네트 높이
  net = 400;
  //50단위를 갖는 상수
  d = 50;
  
  //점프 높이
  jumpHeight = 15;
  //슬라이드 거리
  slide_speed = 15;
  //중력값
  gravity = 0.5;
  //땅에서 마찰값
  friction_ground = 1;
  //공중에서 마찰값
  friction_air = 0.5;
  //점프시 가속도
  velocity_1 = 0;
  velocity_2 = 0;
  //슬라이딩시 가속도
  slide_velocity_1 = 0;
  slide_velocity_2 = 0;
  //구름 좌표, 속도, 크기
  cloud_x = new float[3];
  cloud_y = new float[3];
  cloud_speed = new float[3];
  cloud_size = new float[3];
  for(int i=0;i<3;i++){
    cloud_x[i] = random(100,1100);
    cloud_y[i] = random(50,250);
    cloud_speed[i] = random(1,3);
    cloud_size[i] = random(100,200);
  }

}

void draw(){
  image(img,0,0,1200,800);
  strokeWeight(0);
  fill(250);
  bottom(); //경기장 바닥
  net(); //네트
  cloud_move(); //구름
  pika_1(); //피카츄
  pika_2();
  air(); //공중인지 아닌지 판정
  skill(); //스킬 실행
  physics(); //물리 관련
  ball_move(); //공
  score_count(); //점수 세기, 표시
}
