void ball_design(){ // 공 디자인
  fill(0,0,0);
  circle(ball_x,ball_y,100);
  fill(255,0,0);
  circle(ball_x,ball_y,85);
  fill(255);
  arc(ball_x,ball_y,85,85,0,PI);
  fill(0);
  rect(ball_x-45,ball_y-5,90,10);
  circle(ball_x,ball_y,25);
  fill(255);
  circle(ball_x,ball_y,17);
}
void ball_move(){ // 공 움직임
  ball_design();
  ball_x = ball_x + ballSpeedX; // 공 x좌표 이동
  ball_y = ball_y - ballSpeedY; // 공 y좌표 이동 
  ballSpeedY = ballSpeedY - gravity; // 공 Y좌표 중력 작용
}
