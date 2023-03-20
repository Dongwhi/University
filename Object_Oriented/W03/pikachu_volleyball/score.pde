// 점수 계산
void score_count(){
  if(ball_y>=700 && ball_x>=600){
    score_1++;
    get_point_1();
  } else if(ball_y>=700 && ball_x<600){
    score_2++;
    get_point_2();
  }
  score_show(score_1, score_2);
}
// 점수 표시
void score_show(int sco_1, int sco_2){
  fill(140,2,0); //점수 색
  textSize(70); //점수 크기
  text("score ", 30, 70);
  text("score ", 930, 70);
  text(sco_1, 200, 70); //1번 피카츄 점수
  text(sco_2, 1100, 70); //2번 피카츄 점수
}
  
