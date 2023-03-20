void wall_collide(){  // 공과 벽 충돌
  if( ball_x <=50 && ballSpeedX<0){  // 좌측 벽 충돌 시
    ballSpeedX = -ballSpeedX;
  }
  if( ball_x >=1150 && ballSpeedX>0){  // 우측 벽 충돌 시
    ballSpeedX = -ballSpeedX;
  }
  if(ball_x >=530 && ball_x <=600 && ballSpeedX>0 && ball_y >=420 ){ // 좌측 네트와 충돌시
    ballSpeedX = -ballSpeedX;
  }
  if(ball_x >=600 && ball_x <=670 && ballSpeedX<0 && ball_y >=420){ // 우측 네트와 충돌시
    ballSpeedX = -ballSpeedX;
  }
  if(ball_y>=700){
    ballSpeedY = -ballSpeedY;
  }
}
