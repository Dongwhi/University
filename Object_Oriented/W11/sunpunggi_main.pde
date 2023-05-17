Sunpung [] sp;
void setup() {
  size(1000, 1000);
  sp = new Sunpung[3]; // 선풍기 3개 생성
  for (int i=0; i<3; i++) {
    //                 (x좌표, y좌표, 사이즈(조절가능), 날개수(정수)) 
    sp[i] = new Sunpung(random(width),random(height), random(15, 20), i+4);
  }
}
void draw(){
  background(0,255,255);
  for (int i=0; i<3; i++) { // i<3 의 3부분은 선풍기의 개수
    if (i!=2){ // 개수 -1번째는 선풍기끼리의 충돌 여부를 확인할 필요 없음
      for(int j=i+1;j<3;j++){ // 선풍기끼리 충돌 여부 확인
        sp[i].collide(sp[j]);
      }
    }
    sp[i].act(); // 이동, 벽과의 충돌 확인
    sp[i].sun_shape(); // 그리기
  }  
}
