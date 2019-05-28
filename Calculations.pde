

// du/dt = -(duu_dx) - (duv_dy) - (dp/dx) + (1/Re)*(d^2u/dx^2 + d^2v/dy^2)
// dv/dt = -(dvv_dy) - (duv_dx) - (dp/dy) + (1/Re)*(d^2u/dx^2 + d^2v/dy^2)
// du/dx + dv/dy = 0
//
// u = F - (dt/dx)*()


// Intermediate Velocities
//float[][] u_star = new float[size + 2][size + 2];
//float[][] v_star = new float[size + 2][size + 2];
  
// The change in pressure from the previous step
//float[][] p_prime = new float[size][size];

float[][] F = new float[size + 2][size + 2];
float[][] G = new float[size + 2][size + 2];


public void setBoundaries(){
  int max = size + 1;
  
  for(int n = 0; n < size + 2; n++){
    // Set pressure on boundaries to the adjacent cells
    
    p[n][0] = p[n][1];
    p[n][max] = p[n][max - 1];
    p[0][n] = p[1][n];
    p[max][n] = p[max - 1][n];
    
    v[n][0] = -v[n][1]; // Top
    v[n][max] = -v[n][max - 1]; // Bottom
    v[0][n] = v[1][n]; // Left
    v[max][n] = v[max - 1][n]; // Right
    
    u[n][0] = u[n][1];
    u[n][max] = u[n][max - 1];
    u[0][n] = (presetMode == 1) ? u[1][n] : -u[1][n];
    u[max][n] = (presetMode == 1) ? u[max - 1][n] : -u[max - 1][n];
    
    float s = 0.95;
    h[n][0] = h[n][1] * s;
    h[n][max] = h[n][max - 1] * s;
    h[0][n] = h[1][n] * s;
    h[max][n] = h[max - 1][n] * s;
    
    /*
    v[n][0] = n/100.0; // Top
    v[n][max - 1] = z*v[n][max - 2]; // Bottom
    v[0][n] = v[1][n]; // Left
    v[max - 2][n] = v[max - 3][n]; // Right
    
    u[n][0] = b; // Top
    u[n][max - 2] = u[n][max - 3]; // Bottom
    u[0][n] = z*u[1][n]; // Left
    u[max - 2][n] = z*u[max - 3][n]; // Right*/
  }
}

public void calcIntermediateVelocity(){
  for(int j = 1; j < size + 1; j++){
    for(int i = 1; i < size + 1; i++){
      float re = sliders.get(0).value;
      
      float duu_dx = ((sq((u[i][j] + u[i+1][j]) / 2) - sq((u[i-1][j] + u[i][j]) / 2)) / dx);
      float dvv_dy = ((sq((v[i][j] + v[i][j+1]) / 2) - sq((v[i][j-1] + v[i][j]) / 2)) / dy);
      
      float duv_dx = (((((u[i][j] + u[i][j+1]) * (v[i][j] + v[i+1][j])) / 4) -
                       (((u[i-1][j] + u[i-1][j+1]) * (v[i-1][j] + v[i][j])) / 4)) / dx);
      float duv_dy = (((((v[i][j] + v[i+1][j]) * (u[i][j] + u[i][j+1])) / 4) -
                       (((v[i][j-1] + v[i+1][j-1]) * (u[i][j-1] + u[i][j])) / 4)) / dy);
      
      float ddu_dxx = ((u[i+1][j] - 2*u[i][j] + u[i-1][j])) / sq(dx);
      float ddu_dyy = ((u[i][j+1] - 2*u[i][j] + u[i][j-1])) / sq(dy);
      float ddv_dxx = ((v[i+1][j] - 2*v[i][j] + v[i-1][j])) / sq(dx);
      float ddv_dyy = ((v[i][j+1] - 2*v[i][j] + v[i][j-1])) / sq(dy);
      
      
      float g_x = 0; // External forces like gravity
      float g_y = 0;
      
      F[i][j] = (u[i][j] + dt * ((1 / re)*(ddu_dxx + ddu_dyy) - duu_dx - duv_dy + g_x));
      G[i][j] = (v[i][j] + dt * ((1 / re)*(ddv_dxx + ddv_dyy) - dvv_dy - duv_dx + g_y));
    }
  }
}

public void pressure_correction(){
  int iteration = 0;
  float max_change = 100;
  
  float[][] new_p = new float[size + 2][size + 2];
  
  // Solve the equation for the new pressure correction
  // Store the maximum difference between the two pressure fields
  // if that change is less than a certain value, stop calculating
  while(max_change >= epsilon && iteration < 5){
    for(int i = 0; i < p.length; i++){
      for(int j = 0; j < p.length; j++){
        new_p[i][j] = p[i][j];
      }
    }
    
    // Calculate the new pressure from the Poisson Equation
    // Do all the odd indexed cells
    for(int j = 1; j < size + 1; j++){
      for(int i = 1 + ((j+1) % 2); i < size + 1; i += 2){
        float dF_dx = (F[i][j] - F[i-1][j]) / dx;
        float dG_dy = (G[i][j] - G[i][j-1]) / dy;
        
        float b = -(dF_dx + dG_dy) * (sq(dx) / dt); // maybe not dx^2. Possibly just 1/dt
        
        new_p[i][j] = 0.15 * (p[i-1][j] + p[i+1][j] + p[i][j-1] + p[i][j+1] + b); //---------------------SHOULD BE 0.25 * BUT THAT BREAKS EVERYTHING BECAUSE THE PRESSURE BLOWS UP FOR SOME REASON---------------------------
      }
    }
    
    // Do all the even indexed cells
    for(int j = 1; j < size + 1; j++){
      for(int i = 1 + (j % 2); i < size + 1; i += 2){
        float dF_dx = (F[i][j] - F[i-1][j]) / dx;
        float dG_dy = (G[i][j] - G[i][j-1]) / dy;
        
        float b = -(dF_dx + dG_dy) * (sq(dx) / dt);
        
        new_p[i][j] = 0.15 * (new_p[i-1][j] + new_p[i+1][j] + new_p[i][j-1] + new_p[i][j+1] + b);
      }
    }
    
    for(int i = 0; i < p.length; i++){
      for(int j = 0; j < p.length; j++){
        p[i][j] = new_p[i][j];
      }
    }
    
    // Check for the divergence of the pressure
    for(int i = 1; i < size + 1; i++){
      for(int j = 1; j < size + 1; j++){
        float dp_x = abs(p[i][j] - p[i+1][j]);
        float dp_y = abs(p[i][j] - p[i][j+1]);
        
        if(dp_x < max_change){
          max_change = dp_x;
        }
        
        if(dp_y < max_change){
          max_change = dp_y;
        }
      }
    }
    
    iteration++;
  }
}

public void calcHeat(){
  float[][] h_prime = new float[size + 2][size + 2];
  float[][] new_h = new float[size + 2][size + 2];
  
  for(int i = 1; i < size + 1; i++){
    for(int j = 1; j < size + 1; j++){
      float ddh_dxx = (h[i+1][j] - 2*h[i][j] + h[i-1][j]) / sq(dx);
      float ddh_dyy = (h[i][j+1] - 2*h[i][j] + h[i][j-1]) / sq(dy);
      
      h_prime[i][j] = h[i][j] + dt * alpha * (ddh_dxx + ddh_dyy);
      new_h[i][j] = 0;
    }
  }
  
  for(int i = 1; i < size + 1; i++){
    for(int j = 1; j < size + 1; j++){
      PVector vel = new PVector(u[i][j], v[i][j]).div(15).limit(0.1);
      
      new_h[i][j] += h_prime[i][j] * (1 - abs(vel.x) - abs(vel.y)); // Split up the heat and make it move in the direction of the fluid
      
      if(vel.x >= 0){
        new_h[i+1][j] += h_prime[i][j] * vel.x;
      }else{
        new_h[i-1][j] -= h_prime[i][j] * vel.x;
      }
      
      if(vel.y >= 0){
        new_h[i][j+1] += h_prime[i][j] * vel.y;
      }else{
        new_h[i][j-1] -= h_prime[i][j] * vel.y;
      }
    }
  }
  
  h = new_h;
}

public void flow(){
  setBoundaries();
  runPreset(presetMode);
  
  calcIntermediateVelocity();  
  pressure_correction();
  
  for(int j = 1; j < size + 1; j++){
    for(int i = 1; i < size + 1; i++){
      u[i][j] = F[i][j] - (dt / dx) * (p[i+1][j] - p[i][j]);
      v[i][j] = G[i][j] - (dt / dy) * (p[i][j+1] - p[i][j]);
    }
  }
  
  calcHeat();
}

public float curl(int i, int j){
  return ((v[i][j] - v[i-1][j]) / dx) -
         ((u[i][j] - u[i][j-1]) / dy);
}
