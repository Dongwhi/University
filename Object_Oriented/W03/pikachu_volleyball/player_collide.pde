void player_collide(){  // 공과 p 충돌
  float dx1 = ball_x - pika_1_x, dy1 = pika_1_y - ball_y; // 1번 피카츄와 공의 거리
  float dx2 = ball_x - pika_2_x, dy2 = pika_2_y - ball_y; // 2번 피카츄와 공의 거리
  float d1 = sqrt(dx1*dx1+dy1*dy1);
  float d2 = sqrt(dx2*dx2+dy2*dy2);
  float collide_x = 1.5, collide_y = 1; // 충돌시 x, y 증가값
  
  
  if (d1<=100 && dy1>=20 && ballSpeedY<0){// 공이 player1 머리에 맞는다면
    ballSpeedY = -ballSpeedY; // y속도 반전 후
      if (recent_move_1 == "left"){  // 마지막 입력이 왼쪽이라면
         ballSpeedX = ballSpeedX - 2; // 1은 가중치 변경가능
         collide_x = - abs(collide_x);
      }
      else{ //오른쪽이나 입력이 없는 경우
        ballSpeedX = ballSpeedX + 2;
        collide_x = abs(collide_x);
      }
      if( smashing_1 == true ){  // player1 충돌 시 smash 활성화라면 속도 증가
        sound[1].jump(0.5);
        ballSpeedX += collide_x;
        ballSpeedY += collide_y;
      }
      if (air_1==true){  // 점프 상태라면
        ballSpeedX += collide_x;
        ballSpeedY += collide_y;
      }
    }
  else if(d1<=100 && dy1<20){ // 머리 아래 충돌시
    if(dx1>0 && ballSpeedX<0){ // 공이 오른쪽에서 맞는 경우
      ballSpeedX = - ballSpeedX;
    }
    else if (dx1<0 && ballSpeedX>0){ // 공이 왼쪽에서 맞는 경우
      ballSpeedX = - ballSpeedX;
    }
  }

  if (d2<=100 && dy2>=20 && ballSpeedY<0){// 공이 player2 머리에 맞는다면
    ballSpeedY = -ballSpeedY; // y속도 반전 후
      if (recent_move_2 == "left"){  // 마지막 입력이 왼쪽이라면
         ballSpeedX = ballSpeedX - 2; // 1은 가중치 변경가능
         collide_x = - abs(collide_x);
      }
      else{ //오른쪽이나 입력이 없는 경우
        ballSpeedX = ballSpeedX + 2;
        collide_x = abs(collide_x);
      }
      if( smashing_2 == true ){  // player2 충돌 시 smash 활성화라면 속도 증가
        sound[1].jump(0.5);
        ballSpeedX += collide_x;
        ballSpeedY += collide_y;
      }
      if (air_2==true){  // 점프 상태라면
        ballSpeedX += collide_x;
        ballSpeedY += collide_y;
      }
    }
  else if(d2<=100 && dy2<20){ // 머리 아래 충돌시
    if(dx2>0 && ballSpeedX<0){ // 공이 왼쪽에서 맞는 경우
      ballSpeedX = - ballSpeedX;
    }
    else if (dx2<0 && ballSpeedX>0){ // 공이 오른쪽에서 맞는 경우
      ballSpeedX = - ballSpeedX;
    }
  }
}
