/*

Hold control and scroll the mouse wheel to change the mouse mode.
If the mouse mode is adding barriers, scroll the mouse wheel normally to change the direction of the barrier placement

Barriers dont work well if it is on a curved surface because they only point in one direction

If reynolds number is too big (around 40 or above) it will eventually start going too fast and will break. Just hit the reset button to fix that.
*/



int presetMode = 0;
int mouseMode = 2;
int displayMode = 4;
int barrierMode = 0;
boolean showParticles = false;
boolean showVelocityField = false;

int size = 75;
int fieldWidth = 600;
int fieldHeight = 600;

float cellSize = fieldWidth / (float)size;

int iterationsPerFrame = 10; // ------------ Lower this value if it starts lagging -----------------
float epsilon = pow(10, -10);

float dt = 0.01;
float dx = 0.8;
float dy = 0.8;

float density = 1;
float alpha = 0.5;

float[][] u = new float[size + 2][size + 2]; // x-velocity at the cell
float[][] v = new float[size + 2][size + 2]; // y-velocity at the cell
float[][] p = new float[size + 2][size + 2]; // pressure at the cell
float[][] h = new float[size + 2][size + 2]; // heat at the cell

ArrayList<Barrier> barriers = new ArrayList<Barrier>();
ArrayList<Particle> particles = new ArrayList<Particle>();

ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Menu> menus = new ArrayList<Menu>();
ArrayList<Slider> sliders = new ArrayList<Slider>();
String[] mouseTypes;

public void setup(){
  size(1000, 700);
  background(255);
  
  Button resetButton = new Button(90, 100, 120, 30, "Reset", 0){
                        public void onClick(){
                          presetMode = -1;
                        }};
  Button button0 = new Button(90, 140, 120, 30, "Nothing", 0){
                    public void onClick(){
                      presetMode = 0;
                    }};
  Button button1 = new Button(200, 100, "Show Particles", 1){
                    public void onClick(){
                      showParticles = this.isActive;
                    }};
  Button button2 = new Button(200, 140, "Show Velocity Field", 1){
                    public void onClick(){
                      showVelocityField = this.isActive;
                    }};
                    
  buttons.add(resetButton);
  buttons.add(button0);
  buttons.add(button1);
  buttons.add(button2);
  
  Menu menu1 = new Menu(90, 240, "Presets", makeArray(new String[] {"Wind Tunnel", "Driven Cavity", "Clockwise", "Counter-clockwise", "2 Whirlpools", "4 Whirlpools"})){
                public void onSubClick(int i){
                  presetMode = i;
                }};
  Menu menu2 = new Menu(230, 240, "Display Mode", makeArray(new String[] {"Nothing", "X Velocity", "Y Velocity", "Speed", "Heat", "Curl", "Pressure"})){
                public void onSubClick(int i){
                  displayMode = i;
                }};
  mouseTypes = new String[] {"Place Barriers", "Drag Fluid", "Add Pressure", "Add/Remove Heat"};
  
  menus.add(menu1);
  menus.add(menu2);
  
  Slider slider1 = new Slider(155, 180, 0.5, 100, "Reynolds Number");
  
  sliders.add(slider1);
}



public void draw(){
  background(255);
  
  fill(0);
  text("FPS: " + round(frameRate), 970, 30);
  text("Particles: " + particles.size(), 900, 10);
  
  textAlign(CORNER, CORNER);
  if(presetMode <= 0){
    text("Preset Mode = Nothing", 20, 20); 
  }else{
    text("Preset Mode = " + menus.get(0).names.get(presetMode - 1), 20, 20);
  }
  text("Display Mode = " + menus.get(1).names.get(displayMode - 1), 20, 40);
  
  String barrierText = "";
  switch(barrierMode){
  case 0:
    barrierText = "Up";
    break;
  case 1:
    barrierText = "Left";
    break;
  case 2:
    barrierText = "Down";
    break;
  case 3:
    barrierText = "Right";
    break;
  }
  text("Mouse Mode = " + mouseTypes[mouseMode - 1] + ((mouseMode == 1) ? ": " + barrierText : ""), 20, 60);
  
  for(Button b : buttons){
    b.display();
  }
  for(Menu m : menus){
    m.display();
  }
  for(Slider s : sliders){
    s.display();
  }
  
  if(mousePressed){
    int gridX = floor((mouseX - 350) / cellSize);
    int gridY = floor((mouseY - 50) / cellSize);
    
    float mx = (mouseX - pmouseX) / 10.0;
    float my = (mouseY - pmouseY) / 10.0;
    
    float maxVel = 1;
    mx = constrain(mx, -maxVel, maxVel);
    my = constrain(my, -maxVel, maxVel);
    
    if(gridX >= 0 && gridX <= size+1 &&
       gridY >= 0 && gridY <= size+1){
      switch(mouseMode){
      case 1:
        // Place Barriers
        if(mouseButton == LEFT){
          attemptAddBarrier(gridX, gridY);
        }else if(mouseButton == RIGHT){
          attemptRemoveBarrier(gridX, gridY);
        }
        break;
      case 2:
        // Move Fluid
        u[gridX][gridY] = mx;
        v[gridX][gridY] = my;
        break;
      case 3:
        // Add Pressure
        p[gridX][gridY] = 2;
        break;
      case 4:
        // Add Heat
        if(mouseButton == LEFT){
          h[gridX][gridY] = 5;
        }else if(mouseButton == RIGHT){
          h[gridX][gridY] = 0;
        }
        break;
      }
    }
      
    for(int i = 0; i < sliders.size(); i++){
      sliders.get(i).update();
    }
  }
  
  for(int a = 0; a < iterationsPerFrame; a++){
    flow();
  }
  
  pushMatrix();
  translate(350, 50);
  rectMode(CORNER);
  fill(255, 10);
  stroke(0);
  strokeWeight(5);
  rect(0, 0, fieldWidth + 2*cellSize, fieldHeight + 2*cellSize, 2);
  //drawGrid();
  
  display(displayMode);
  if(showVelocityField){
    drawVelocity();
  }
  
  if(showParticles){
    particles.add(new Particle((int)random(20, fieldWidth - 20), (int)random(20, fieldHeight - 20)));
    
    for(int i = 0; i < particles.size(); i++){
      particles.get(i).update();
    }
  }
  
  for(Barrier b : barriers){
    b.display();
    b.calcBoundaries();
  }
  popMatrix();
}


public void mouseClicked(){
  for(Button b : buttons){
    b.click();
  }
  for(Menu m : menus){
    m.click();
  }
  /*
  int gridX = floor((mouseX - 350) / cellSize);
  int gridY = floor((mouseY - 50) / cellSize);
  
  if(gridX >= 0 && gridX <= size+1 &&
     gridY >= 0 && gridY <= size+1){
    println("Pressure = " + p[gridX][gridY]);
  }*/
}

public void mouseReleased(){
  for(int i = 0; i < sliders.size(); i++){
    sliders.get(i).release();
  }
}

public void mouseWheel(MouseEvent event){
  if(keyPressed && keyCode == CONTROL){
    mouseMode = constrain(mouseMode + event.getCount(), 1, mouseTypes.length);
  }else{
    barrierMode = constrain(barrierMode + event.getCount(), 0, 3);
  }
}

public void keyPressed(){
  switch(key){
  case 'w':
    barrierMode = 0;
    break;
  case 'a':
    barrierMode = 1;
    break;
  case 's':
    barrierMode = 2;
    break;
  case 'd':
    barrierMode = 3;
    break;
  }
}

public ArrayList<String> makeArray(String[] ls){
  ArrayList<String> out = new ArrayList<String>();
  
  for(String str : ls){
    out.add(str);
  }
  
  return out;
}
