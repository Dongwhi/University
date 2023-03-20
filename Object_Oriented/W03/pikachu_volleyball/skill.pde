// 스킬 실행, 카운팅
void skill(){
  if(smashing_1){
    if(smash_count_1==60){
      smash_count_1 = 0;
      smashing_1 = false;
    } else{
      smash_count_1++;
    }
  }
  if(smashing_2){
    if(smash_count_2==60){
      smash_count_2 = 0;
      smashing_2 = false;
    } else{
      smash_count_2++;
    }
  }
  if(sliding_1){
    if(slide_velocity_1==0){
      sliding_1 = false;
    } else{
      if(air_1){
        slide_1(recent_move_1, slide_velocity_1);
        slide_velocity_1 = slide_velocity_1-friction_air;
      } else{
        slide_1(recent_move_1, slide_velocity_1);
        slide_velocity_1 = slide_velocity_1-friction_ground;
      }
    }
  }
  if(sliding_2){
    if(slide_velocity_2==0){
      sliding_2 = false;
    } else{
      if(air_2){
        slide_2(recent_move_2, slide_velocity_2);
        slide_velocity_2 = slide_velocity_2-friction_air;
      } else{
        slide_2(recent_move_2, slide_velocity_2);
        slide_velocity_2 = slide_velocity_2-friction_ground;
      }
    }
  }
}
