pizza[] pz;
kumamon []ku;
Sunpung [] sp;
void setup() {
  size(1600, 1200);
  
  pz = new pizza[2];
  pz[0] = new pizza();
  pz[1] = new pizza(5);
  
  ku = new kumamon[2];
  ku[0] = new kumamon();
  ku[1] = new kumamon(8);
  
  sp = new Sunpung[3];
  for (int i=0; i<3; i++) {
    sp[i] = new Sunpung(random(width),random(height), random(15, 20), i+4);
  }
}

void draw() {
  background(0, 255, 255);
  
  pz[0].character();
  pz[1].character();
  pz[0].act();
  pz[1].move();
  
  ku[0].kk();
  ku[1].kk();
  ku[0].baggue();
  ku[1].mouse();
  
  for (int i=0; i<3; i++) {
    if (i!=2){
      for(int j=i+1;j<3;j++){
        sp[i].collide(sp[j]);
      }
    }
    sp[i].act();
    sp[i].sun_shape();
  }  
}

void keyPressed() {
  for (pizza p : pz) {
    p.keyPressed();
  }
}

void keyReleased() {
  for (pizza p : pz) {
    p.keyReleased();
  }
}

class kumamon{
  kumamon(){d=5; x=random(0,width); y=random(0,height); vx=random(-20,20); vy=random(-30,30);}
  kumamon(int r){d=r; x=random(0,width); y=random(0,height); vx=random(-20,20); vy=random(-30,30);}
  int d;
  float x,y,vx,vy;
  void kk(){
    float k = 8*d;
    fill(1,1,1);
    ellipse(x,y,40*d,30*d);  //얼굴
    circle(x+16*d,y-12*d,k);  //오른쪽귀
    circle(x-16*d,y-12*d,k);  //왼쪽귀
    fill(255,0,0);
    circle(x+16*d,y+5*d,k+d/2);  //오른쪽볼
    circle(x-16*d,y+5*d,k+d/2);  //왼쪽볼
    fill(255);
    circle(x-10*d,y-4*d,k);  //왼쪽눈
    circle(x+10*d,y-4*d,k);  //오른쪽눈
    ellipse(x,y+5.5*d,20*d,15*d);  //흰색입
    circle(x+16*d,y-12*d,k*0.5+0.5*d);  //안쪽귀(오른쪽)
    circle(x-16*d,y-12*d,k*0.5+0.5*d);  //안쪽귀(왼쪽)
    curve(x-15*d,y,x-13*d,y-10*d,x-8*d,y-10*d,x-6*d,y);  //왼쪽눈썹
    curve(x+6*d,y,x+8*d,y-10*d,x+13*d,y-10*d,x+15*d,y);  //오른쪽눈썹
    fill(1,1,1);
    ellipse(x,y+d,6*d,4.5*d);  //코
    ellipse(x-10*d,y-4*d,1.1*d,2.6*d);  //왼쪽눈동자
    ellipse(x+10*d,y-4*d,1.1*d,2.6*d);  //오른쪽눈동자
    ellipse(x,y+7.5*d,15*d,5*d);  //입
  }
  void baggue(){  //속도 랜덤, 가장자리에서 튕기도록
    x += vx; y += vy;
    if(x<0) vx = -vx;
    if(x>width) vx = -vx;
    if(y<0) vy = -vy;
    if(y>height) vy = -vy;
  }
  void mouse(){  //mouse에 따라 움직이는 오브젝트
    x = mouseX;
    y = mouseY;
  }
}

class pizza{
  pizza(){x=random(0,width); y=random(0,height); s=100; vx=random(-20,20); vy=random(-20,20);}
  pizza(int r){x=random(0,width);y=random(0,height); s=30*r; vx=random(-20,20);vy=random(-20,20);}
  float x,y,vx,vy,s;
  boolean left, right, up, down;  
  void character(){
    bread();
    ham();
    olive();
  }
  void bread(){
    fill(170,100,0);
    arc(x,y+0.7*s,3*s,3*s,8*PI/6,10*PI/6);
    fill(255,204,102);
    arc(x,y+0.7*s,2.6*s,2.6*s,8*PI/6,10*PI/6);
  }
  void ham(){
    fill(200,0,0);
    circle(x-0.3*s,y-0.35*s,30);
    fill(200,0,0);
    circle(x+0.25*s,y-0.3*s,30);
    fill(200,0,0);
    circle(x,y+0.2*s,30);
  }
  void olive(){
    fill(0,0,0);
    circle(x+0.2*s,y-0.05*s,15);
    fill(255,204,102);
    circle(x+0.2*s,y-0.05*s,10);
    fill(0,0,0);
    circle(x-0.03*s,y-0.33*s,15);
    fill(255,204,102);
    circle(x-0.03*s,y-0.33*s,10);
    fill(0,0,0);
    circle(x-0.2*s,y-0.02*s,15);
    fill(255,204,102);
    circle(x-0.2*s,y-0.02*s,10); 
  }
  void act() {
    x += vx;
    y += vy;
    if (x > width) vx = -vx;
    if (x < 0) vx = -vx;
    if (y > height) vy = -vy;
    if (y < 0) vy = -vy;
  }

  void keyReleased() {
    if (keyCode == LEFT) {
      left = false;
    }
    if (keyCode == RIGHT) {
      right = false;
    }
    if (keyCode == UP) {
      up = false;
    }
    if (keyCode == DOWN) {
      down = false;
    }
  }

  void keyPressed() {
    if (keyCode == LEFT) {
      left = true;
    }
    if (keyCode == RIGHT) {
      right = true;
    }
    if (keyCode == UP) {
      up = true;
    }
    if (keyCode == DOWN) {
      down = true;
    }
  }

  void move() {
    if (left==true) {
      x -= 1;
    }
    if (right==true) {
      x += 1;
    }
    if (up==true) {
      y -= 1;
    }
    if (down==true) {
      y += 1;
    }
  }
}
class Sunpung{
  Sunpung(){};
  Sunpung(float a, float b, float c, int d){
    x = a;
    y = b;
    s = c; // 선풍기 크기
    n = d; // 날개 수
    fan_angle = radians(360./n);
    vx = random(-3,3); vy = random(-2,2);
  }
  float x, y, s, fan_angle, vx, vy;
  int n;
  void collide(Sunpung b){ // 선풍기끼리의 충돌 구현
    float dd;
    dd = sqrt((x-b.x)*(x-b.x) + (y-b.y)*(y-b.y));
    if(dd < 4*(s+b.s)){ // 만약 충돌이 부자연스럽다면 4*(s+b.s) 에서 (s+b.s)에 다른 수를 곱하여 조절. 수가 커지면 히트박스 커짐.
      float vx1 = vx, vy1 = vy;
      vx = b.vx;
      vy = b.vy;
      b.vx = vx1;
      b.vy = vy1;
    }
  }
  void act(){ // 선풍기 평상시 이동, 벽과의 충돌 구현
    x += vx;  y += vy;
   if(x<0 || x>width) vx = - vx;
   if(y<0 || y>height) vy = - vy;
  }
  void sun_shape(){ // 선풍기 그리는 함수
    fill(247, 247, 223);
    quad(x-3*s, y+2*s, x+3*s, y+2*s, x+4*s, y+6*s, x-4*s, y+6*s);
    rect(x-4*s, y+6*s, 8*s, 2*s);
    rect(x-s, y-2*s, 2*s, 6*s);
    fill(83, 185, 230);
    draw_button(x-3*s, y, s);
    draw_button(x-2.3*s, y, s);
    draw_button(x-1.6*s, y, s);
    draw_button(x-0.9*s, y, s);
    fill(210);
    circle(x, y-4*s, 10*s);
    fill(83, 185, 230);
    circle(x, y-4*s, 2*s);
    fill(84, 127, 255, 120);
    for (int i = 0; i < n; i++){      
      draw_fan(x, y, s, i, fan_angle);
    }
  }
}
// 선풍기 그릴때 사용하는 함수
void draw_button(float x, float y, float s){
  rect(x-0.25*s, y+5*s, 0.5*s, 0.3*s);
  ellipse(x, y+5*s, 0.5*s, 0.3*s);
  arc(x, y+5.3*s, 0.5*s, 0.3*s, 0, radians(360./2));
}
void draw_fan(float x, float y, float s, int n, float fan_angle){
  curve(x+s*cos(fan_angle*(n+0.5)),y+s*sin(fan_angle*(n+0.5))-4*s,
  x+s*cos(fan_angle*n),y+s*sin(fan_angle*n)-4*s,
  x+4*s*cos(fan_angle*n),y+4*s*sin(fan_angle*n)-4*s,
  x+4*s*cos(fan_angle*(n+0.5)),y+4*s*sin(fan_angle*(n+0.5))-4*s);
  arc(x+1.5*s*cos(fan_angle*n),y+1.5*s*sin(fan_angle*n)-4*s,5*s,5*s,fan_angle*n,fan_angle*(n+1));
  curve(x+s*cos(fan_angle*(n+1)),y+s*sin(fan_angle*(n+1))-4*s,
  x+s*cos(fan_angle*(n+0.5)),y+s*sin(fan_angle*(n+0.5))-4*s,
  x+3.3*s*cos(fan_angle*(n+0.65)),y+3.3*s*sin(fan_angle*(n+0.65))-4*s,
  x+3.3*s*cos(fan_angle*(n+1)),y+3.3*s*sin(fan_angle*(n+1))-4*s);
}
