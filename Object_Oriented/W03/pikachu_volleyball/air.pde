void air(){
  //피카츄가 땅에 있으면 air=false, 공중에 있으면 air=true
  if(ground==pika_1_y){
    air_1=false;
  } else{
    air_1=true;
  }
  if(ground==pika_2_y){
    air_2=false;
  } else{
    air_2=true;
  }
}
