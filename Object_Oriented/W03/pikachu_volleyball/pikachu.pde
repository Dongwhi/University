float s;  // 피카츄 그림
void pika(float x,float y){  // 피카츄의 좌표 입력
  s = 50; // 피카츄의 크기
  fill(255,255,0);
  ellipse(x-0.8*s,y-s,s*0.45,s*2);
  ellipse(x+0.8*s,y-s,s*0.45,s*2);
  circle(x,y,2.5*s);
  fill(0,0,0);
  arc(x-s*0.8,y-s*1.5,s*0.38,s*1.05,PI,PI*2);
  arc(x+s*0.8,y-s*1.5,s*0.38,s*1.05,PI,PI*2);
  daeching(s*0.6,s*0.45,s*0.6, x, y);
  fill(255,255,255);  
  daeching(s*0.55,s*0.55,s*0.25, x, y);
  fill(255,0,0);
  daeching(s*0.85,-s*0.55,s*0.5, x, y);
  fill(0,0,0);
  triangle(x-s*0.1,y+s*0.1,x+s*0.1,y+s*0.1,x,y+s*0.2);
  fill(255,255,0);
  bezier(x-s*0.35,y+s*0.5,x-s*0.2,y+s*0.6,x-s*0.1,y+s*0.6,x,y+s*0.5);
  bezier(x+s*0.35,y+s*0.5,x+s*0.2,y+s*0.6,x+s*0.1,y+s*0.6,x,y+s*0.5);
}
void daeching(float a,float b,float r, float x, float y){ // 대칭인 원 그리기 
//(기준 x로 부터의 거리,기준 x로 부터의 거리,원의 크기,기준x, 기준y)
 x=x-a;
 y=y-b;
 circle(x,y,r);
 x=x+a*2;
 circle(x,y,r);
}
void pika_1(){
  pika(pika_1_x,pika_1_y); // p1의 초기 좌표 입력
}
void pika_2(){
  pika(pika_2_x,pika_2_y); // p2의 초기 좌표 입력
}
