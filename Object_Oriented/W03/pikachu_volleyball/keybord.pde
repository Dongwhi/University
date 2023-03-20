void keyPressed(){
  // slide or smash 결정
  if(key=='s'){ //플레이어 1의 스킬키
    if(air_1){ //플레이어 1이 떠있다면
      smashing_1 = true; //1초동안 스매시 상태 부여
    } else{ //땅에 있다면
      if(sliding_1){
      } else{ //슬라이딩중이 아니라면
        sliding_1 = true; //슬라이딩 실행
        slide_velocity_1 = slide_speed;
      }
     }
  }
  if(keyCode == DOWN){ //플레이어 2의 스킬키
    if(air_2){
      smashing_2 = true;
    } else{
      if(sliding_2){
      } else{
        sliding_2 = true;
        slide_velocity_2 = slide_speed;
      }
    }
  }
  //점프
  if(key == 'w' && pika_1_y == height - 100){
    velocity_1 = (-jumpHeight);
    sound[2].jump(1.23);
  }
  if(keyCode == UP && pika_2_y == height - 100){
    velocity_2 = (-jumpHeight);
    sound[2].jump(1.23);
  }
  //이동
  if(sliding_1){
  }else{ //슬라이딩 중이 아닐 때
    if(key=='a'){ //왼쪽 키를 누르면
      pika_1_x -= 40; //x좌표 -
      recent_move_1 = "left"; //최근 이동: 왼쪽
    } else if(key=='d'){ //오른쪽 키를 누르면
      pika_1_x += 40; //x좌표 +
      recent_move_1 = "right"; //최근 이동: 오른쪽
    }
  }
  if(sliding_2){
  }else{
    if(keyCode == LEFT){
      pika_2_x -= 40;
      recent_move_2 = "left";
    } else if(keyCode == RIGHT){
      pika_2_x += 40;
      recent_move_2 = "right";
    }
  }
}
