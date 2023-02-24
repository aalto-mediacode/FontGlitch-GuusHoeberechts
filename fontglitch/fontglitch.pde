import controlP5.*;

// made by Guus Hoeberechts (https://github.com/guuseh)
// for Generative Media Coding workshop at Aalto University
// taught by Nuno Correia
// based on tutorial by Tim Rodenbröker 
// (https://timrodenbroeker.de/processing-tutorial-kinetic-typography-1/)
// and supershapes (http://paulbourke.net/geometry/supershape/)

ControlP5 control;

PFont font;
PGraphics pg;

float scaleC, aC, bC, mC, n2C, n3C;
float a, b, m, n2, n3;
boolean noiseC, waveC, sup1C, sup2C, cross;
int hide, sup1, sup2;
String text1, text2, text3;


void setup() {
  frameRate(30);
  control = new ControlP5(this);
  font = createFont("Gulax-Regular.otf", 250);
  
  // should be the same size
  size(1200,800, P2D);
  pg = createGraphics(1200, 800, P2D);
  
  // set intial values
  scaleC = 0.1;
  aC = -0.05;
  bC = 0.05;
  mC = 2;
  n2C = 0.05;
  n3C = 0.005;
  
  hide = 1;
  noiseC = false;
  waveC = false;
  sup1C = true;
  sup2C = true;
  cross = false;
  
//-------- draw controls --------
  
  control.addButton("hide")
         .setPosition(10,10)
         .setSize(50,10);
  control.addSlider("Scale")
         .setPosition(10,30)
         .setSize(50,10)
         .setRange(-2, 2)
         .setValue(0.1);
  control.addSlider("A")
         .setPosition(10,50)
         .setSize(50,10)
         .setRange(-1, 1)
         .setValue(-0.05);
  control.addSlider("B")
         .setPosition(10,70)
         .setSize(50,10)
         .setRange(-0.5, 0.5)
         .setValue(0.05);
  control.addSlider("M")
         .setPosition(10,90)
         .setSize(50,10)
         .setRange(-6, 6)
         .setValue(2);
  control.addSlider("N2")
         .setPosition(10,110)
         .setSize(50,10)
         .setRange(0.001, 0.5)
         .setValue(0.05);
  control.addSlider("N3")
         .setPosition(10,130)
         .setSize(50,10)
         .setRange(0.001, 0.5)
         .setValue(0.005);
  control.addButton("Noise")
         .setPosition(10,150)
         .setSize(50,10);
  control.addButton("Wave")
         .setPosition(10,170)
         .setSize(50,10);
  control.addButton("Sup1")
         .setPosition(10,190)
         .setSize(50,10);
  control.addButton("Sup2")
         .setPosition(10,210)
         .setSize(50,10);
  control.addTextfield("Line1")
         .setPosition(10,230)
         .setSize(50,10)
         .setAutoClear(false);
  control.addTextfield("Line2")
         .setPosition(10,260)
         .setSize(50,10)
         .setAutoClear(false);
  control.addTextfield("Line3")
         .setPosition(10,290)
         .setSize(50,10)
         .setAutoClear(false);
  control.addButton("Cross")
         .setPosition(10,320)
         .setSize(50,10); 
}

void draw() {
  background(0);

//------ read control values ----------

  setScale(control.get("Scale").getValue());
  setA(control.get("A").getValue());
  setB(control.get("B").getValue());
  setM(control.get("M").getValue());
  setN2(control.get("N2").getValue());
  setN3(control.get("N3").getValue());
  
  text1 = control.get(Textfield.class, "Line1").getText();
  text2 = control.get(Textfield.class, "Line2").getText();
  text3 = control.get(Textfield.class, "Line3").getText();
  
  
// ------------- show / hide controls ----------

  if(hide == 1){
    control.get("Scale").show();
    control.get("A").show();
    control.get("B").show();
    control.get("M").show();
    control.get("N2").show();
    control.get("N3").show();
    control.get("Noise").show();
    control.get("Wave").show();
    control.get("Sup1").show();
    control.get("Sup2").show();
    control.get(Textfield.class, "Line1").show();
    control.get(Textfield.class, "Line2").show();
    control.get(Textfield.class, "Line3").show();
    control.get("Cross").show();
  } else{
    control.get("Scale").hide();
    control.get("A").hide();
    control.get("B").hide();
    control.get("M").hide();
    control.get("N2").hide();
    control.get("N3").hide();
    control.get("Noise").hide();
    control.get("Wave").hide();
    control.get("Sup1").hide();
    control.get("Sup2").hide();
    control.get(Textfield.class, "Line1").hide();
    control.get(Textfield.class, "Line2").hide();
    control.get(Textfield.class, "Line3").hide();
    control.get("Cross").hide();
  }

//---------- draw PGraphics ------------

  pg.beginDraw();
  pg.background(0);
  pg.fill(0,0,255);
  pg.stroke(255);
    if(cross){
      pg.line(0, height/2, width, height/2);
      pg.line(width/2, 0, width/2, height);
    }
  pg.textFont(font);
  pg.textSize(250);
  pg.pushMatrix();
  pg.textAlign(LEFT, TOP);
  pg.text(text1,100, 50);
  pg.text(text2,100, 200);
  pg.text(text3,100, 350);
  pg.popMatrix();
  pg.endDraw();
  
   

//-------- set tile amount (max 100) --------

  int tilesX = 100;
  int tilesY = 100;

  int tileW = int(width/tilesX);
  int tileH = int(height/tilesY); 
  
  
//------- draw / copy tiles ------------
  for (int y = 0; y < tilesY; y++) {
    for (int x = 0; x < tilesX; x++) {

      // WARP
      int wave = int(sin(frameCount * 0.05 + ( x * (y*0.5) ) * 0.009) * 30);
      int noise = int(noise(frameCount*0.1 * ((x*0.01)*(y*0.01)))*50);
            
      beginShape();
      
      // --------- superformula variables ---------
      // play around with the variables inside the sin/cos
      // or remove sin/cos
      // get rid of x & y's to have more control 
      
         a = sin(y*scaleC*aC); 
         b = cos(y*scaleC*bC); 
         m = -cos(mC)*2;
         n2 = sin(x*n2C) * (x*scaleC*10) ;
         n3 = cos(x*n3C) * (y*-scaleC*10) ;  
        
          // use these settings instead for a less glitchy, slower effect
            //float a = sin(frameCount*-0.05);
            //float b = cos(frameCount*0.05);
            //float m = 2;
            //float n2 = sin(frameCount*0.05) *(x*0.5) ;
            //float n3 = cos(frameCount*0.005) *(y*-0.5) ;
        
        
        // don't change -> superformula
        if(!sup1C){
          sup1 = 1;
        } else{
          sup1 = int(pow(abs(cos(m * (frameCount*scaleC) / 4.0 ) / a), n2));
        }
        if(!sup2C){
          sup2= 1;
        } else{
          sup2 = int(pow(abs(sin(m * (frameCount*scaleC) / 4.0 ) / b), n3));
        }
         
       endShape();
 
      // init source variables
      int sx;
      int sy;
      int sw;
      int sh;

      // draw or not draw wave / noise / superformula x/y
      if(!noiseC && !waveC){
        sx = x*tileW + sup1;
        sy = y*tileH + sup2;
        sw = tileW;
        sh = tileH;
      } else if(!noiseC && waveC){
         sx = x*tileW + sup1*wave;
         sy = y*tileH + sup2;
         sw = tileW;
         sh = tileH;
      } else if(noiseC && !waveC){
         sx = x*tileW + sup1;
         sy = y*tileH + sup2+noise;
         sw = tileW;
         sh = tileH;
      } else{
         sx = x*tileW + sup1*wave;
         sy = y*tileH + sup2+noise;
         sw = tileW;
         sh = tileH;
      }

      // DESTINATION for copy
      int dx = x*tileW;
      int dy = y*tileH;
      int dw = tileW;
      int dh = tileH;
      
      copy(pg, sx, sy, sw, sh, dx, dy, dw, dh);   
    }
  }
}

//-------- set values from controls to variables --------
public void setScale(float scale){
  this.scaleC = scale;
}
public void setA(float a){
  this.aC = a;
}
public void setB(float b){
  this.bC = b;
}
public void setM(float m){
  this.mC = m;
}
public void setN2(float n2){
  this.n2C = n2;
}
public void setN3(float n3){
  this.n3C = n3;
}

//------- toggle controls ---------
public void hide(){
    if(hide == 0){
      hide = 1;
    } else{
      hide = 0;
    }
}

//----- toggle Noise / Wave / Sup1 / Sup2 ---------
public void Noise(){
   noiseC = !noiseC;
}
public void Wave(){
   waveC = !waveC;
}
public void Sup1(){
   sup1C = !sup1C;
}
public void Sup2(){
   sup2C = !sup2C;
}
public void Cross(){
  cross = !cross;
}
