void physics(){ //각종 물리 관련 함수
  //플레이어에게 작용하는 중력
  velocity_1 = velocity_1 + gravity;
  pika_1_y = pika_1_y + velocity_1;
  velocity_2 = velocity_2 + gravity;
  pika_2_y = pika_2_y + velocity_2;
  //플레이어를 바닥 높이에 고정
  if ( pika_1_y > height - 100){
    pika_1_y = height - 100;
    velocity_1 = 0;}
  if ( pika_2_y > height - 100){
    pika_2_y = height - 100;
    velocity_2 = 0;}
  //공과 벽 충돌
  wall_collide();
  //공과 피카츄 충돌
  player_collide();
}
