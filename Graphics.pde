

public void drawArrow(int x, int y, float dx, float dy){
  pushMatrix();
  translate(x, y);
  rotate(atan(dy / dx));
  rectMode(CENTER);
  
  fill(0, 0, 0);
  noStroke();
  rect(0, 0, 10, 0.5);
  
  popMatrix();
  rectMode(CORNER);
}

public void drawGrid(){
  for(int i = 0; i < size + 3; i++){ 
    float x = i * cellSize;
    
    stroke(0, 0, 0);
    strokeWeight(3);
    line(x, 0, x, fieldHeight + 2*cellSize);
    line(0, x, fieldWidth + 2*cellSize, x);
  }
  
  float k = (fieldWidth / size);
  for(int i = 0; i < size + 2; i++){
    float x = i * cellSize;
    fill(0, 0, 0, 100);
    noStroke();
    rect(0, x, k, k);
    rect(fieldWidth + k, x, k, k);
  }
  
  for(int i = 1; i < size + 1; i++){
    float x = i * cellSize;
    fill(0, 0, 0, 100);
    noStroke();
    rect(x, 0, k, k);
    rect(x, fieldWidth + k, k, k);
  }
}

public void drawPressure(){
  for(int j = 1; j < p[0].length - 1; j++){
    for(int i = 1; i < p.length - 1; i++){
      float x = i * cellSize;
      float y = j * cellSize;
      
      float e = 30;
      
      fill(0);
      ellipse(x + cellSize/2, y + cellSize/2, e*p[i][j], e*p[i][j]);
    }
  }
}
public void drawVelocity(){
  for(int j = 1; j < p[0].length - 1; j++){
    for(int i = 1; i < p.length - 1; i++){
      float x = i * cellSize;
      float y = j * cellSize;
      
      drawArrow((int)x + (int)cellSize/2, (int)y + (int)cellSize/2, (u[i-1][j] + u[i][j])/2, (v[i][j-1] + v[i][j])/2);
    }
  }
}

public void display(int mode){
  switch(mode){
  case 1:
    // Show nothing
    break;
  case 2:
    // Show the x velocity
    for(int i = 1; i < p.length - 1; i++){
      for(int j = 1; j < p.length - 1; j++){
        float x = i * cellSize;
        float y = j * cellSize;
        
        float value = u[i][j];
        float c = 160 - map(value, 0, 0.5, 0, 160);
        
        colorMode(HSB);
        rectMode(CORNER);
        noStroke();
        
        fill(c, 255, 255);
        rect(x, y, cellSize, cellSize);
        colorMode(RGB);
      }
    }
    break;
  case 3:
    // Show the y velocity
    for(int i = 1; i < p.length - 1; i++){
      for(int j = 1; j < p.length - 1; j++){
        float x = i * cellSize;
        float y = j * cellSize;
        
        float value = v[i][j];
        float c = 160 - map(value, 0, 0.5, 0, 160);
        
        colorMode(HSB);
        rectMode(CORNER);
        noStroke();
        
        fill(c, 255, 255);
        rect(x, y, cellSize, cellSize);
        colorMode(RGB);
      }
    }
    break;
  case 4:
    // Show the speed
    for(int i = 1; i < p.length - 1; i++){
      for(int j = 1; j < p.length - 1; j++){
        float x = i * cellSize;
        float y = j * cellSize;
        
        float value = sqrt(sq(u[i][j]) + sq(v[i][j]));
        float c = 160 - map(value, 0, 0.5, 0, 160);
        
        colorMode(HSB);
        rectMode(CORNER);
        noStroke();
        
        fill(c, 255, 255);
        rect(x, y, cellSize, cellSize);
        colorMode(RGB);
      }
    }
    break;
  case 5:
    // Show the heat
    for(int i = 1; i < p.length - 1; i++){
      for(int j = 1; j < p.length - 1; j++){
        float x = i * cellSize;
        float y = j * cellSize;
        
        float value = sqrt(h[i][j]);
        float c = 160 - map(value, 0, 0.4, 0, 160);
        
        colorMode(HSB);
        rectMode(CORNER);
        noStroke();
        
        fill(c, 255, 255);
        rect(x, y, cellSize, cellSize);
        colorMode(RGB);
      }
    }
    break;
  case 6:
    // Show the curl
    for(int i = 1; i < p.length - 1; i++){
      for(int j = 1; j < p.length - 1; j++){
        float x = i * cellSize;
        float y = j * cellSize;
        
        float value = curl(i, j);
        float c = map(value, -0.1, 0.1, 0, 200);
        
        colorMode(HSB);
        rectMode(CORNER);
        noStroke();
        
        fill(c, 255, 255);
        rect(x, y, cellSize, cellSize);
        colorMode(RGB);
      }
    }
    break;
  case 7:
    // Show the pressure
    for(int i = 1; i < p.length - 1; i++){
      for(int j = 1; j < p.length - 1; j++){
        float x = i * cellSize;
        float y = j * cellSize;
        
        float value = p[i][j];
        float c = 160 - map(value, -0.1, 0.1, 0, 160);
        
        colorMode(HSB);
        rectMode(CORNER);
        noStroke();
        
        fill(c, 255, 255);
        rect(x, y, cellSize, cellSize);
        colorMode(RGB);
      }
    }
    break;
  }
}
