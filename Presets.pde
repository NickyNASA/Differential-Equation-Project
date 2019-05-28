


public void runPreset(int type){
  int middle = floor(size / 2.0);
  int max = size + 1;
  
  switch(type){
  case -1:
    for(int i = 0; i < p.length; i++){
      for(int j = 0; j < p.length; j++){
        u[i][j] = 0;
        v[i][j] = 0;
        p[i][j] = 0;
        h[i][j] = 0;
      }
    }
    barriers = new ArrayList<Barrier>();
    presetMode = 0;
    break;
  case 0:
    // Dont add any velocity or pressure
    break;
  case 1:
    // Wind tunnel
    for(int i = 0; i < p.length; i++){
      u[1][i] = 0.25;
    }
    break;
  case 2:
    // Driven cavity
    for(int i = 0; i < p.length; i++){
      u[i][1] = 0.75;
      v[i][1] = i / 400.0;
    }
    
    break;
  case 3:
    // Clockwise
    for(int i = 0; i < p.length; i++){
      u[i][0] = 0.5;
      u[i][max] = -0.5;
      
      v[max][i] = 0.5;
      v[0][i] = -0.5;
    }
    break;
  case 4:
    // Counter-clockwise
    for(int i = 0; i < p.length; i++){
      u[i][0] = -0.5;
      u[i][max] = 0.5;
      
      v[max][i] = -0.5;
      v[0][i] = 0.5;
    }
    break;
  case 5:
    // Flowing left at top and bottom, and right in the middle;
    for(int i = 0; i < p.length; i++){ 
      u[i][0] = -0.5;
      u[i][middle] = 0.5;
      u[i][max] = -0.5;
      
      v[0][i] = (middle - i) / (float)size;
      v[max][i] = (i - middle) / (float)size;
    }
    break;
  case 6:
    // 4 Whirlpools
    
    for(int i = 0; i < p.length; i++){
      u[i][0] = (i - middle) / (float)size;
      u[i][max] = (i - middle) / (float)size;
      
      v[0][i] = (middle - i) / (float)size;
      v[max][i] = (middle - i) / (float)size;
      
      u[i][middle] = (middle - i) / (float)size;
      v[middle][i] = (i - middle) / (float)size;
    }
    break;
  }
}
