import java.awt.Color;
import javax.swing.JOptionPane;

TextureSelector ts = new TextureSelector();

Color[] colorIndex = new Color[10000];


int levelHeight = 13;


String[] texturepack = new String[10000];
String[] args = {"second window"};
String[][] level = new String[levelHeight+1][1000];
String textureFilename = "textures.json";
String levelLoadFilename = "levels.json";


int textureSize = 0;
int texturepackLength = 0;
int bgr, bgb, bgg;
int roundX = 0, roundY = 0;
int pixX = 0, pixY = 0;
int blockX = 0, blockY = 0;
int pixSize = 4;
int selectedTexture = 0;
int textureOffsetX = 0;
int textureOffsetY = 0;
int scroll = 0;
int scrollBlock = 0;
int scrollSpeed = 10;
int editorFrameRate = 20;
int texturePixSize = -1;


float backgroundFlash = 0;



public class TextureSelector extends PApplet {

  void settings() {
    size(300, 600);
    
  }

  void draw() {
    frameRate(editorFrameRate);
    background(207);
    textSize(20);

    fill(backgroundFlash);
    rect(10, 205, 180, 90);

    //if(selectedTexture > 0) {
    //  fill(255);
    //  text("^", 150, 30);
    //}
    
    for (int i = 0; i < texturepackLength; i++) {

      drawTexture(20, i*100+10+selectedTexture*-100+200, 10, i);

      if (i == selectedTexture) {
        fill(255);
      } else {
        fill(0);
      }

      text(i, 110, i*100+30+selectedTexture*-100+200);
    }

    fill(0);
    text(selectedTexture, 10, 590);
  }

  void keyReleased() {
    if (key == 'w' && selectedTexture > -2) {
      selectedTexture--;
    }
    if (key == 's' && selectedTexture < texturepackLength-1) {
      selectedTexture++;
    }
    
  }

  void drawTexture(int x, int y, int _pixSize, int texPackNum) {
    fill(255);
  
    if(texPackNum > 1000) {
      return;
    }
  
    String[] strOut = new String[textureSize*textureSize]; 
    int[] out = new int[strOut.length];

    for (int i = 0; i < strOut.length; i++) {
      strOut[i] = texturepack[texPackNum].charAt(i*2) + "";
      
    }

    for (int i = 0; i < strOut.length; i++) {
      out[i] = Integer.parseInt(strOut[i]);
    }

    for (int i = 0; i < textureSize; i++) {
      for (int j = 0; j < textureSize; j++) {

        if (out[i*textureSize+j] == 0) {
          fill(bgr, bgg, bgb);
        } else {
          fill(colorIndex[out[i*textureSize+j]].getRed(), 
            colorIndex[out[i*textureSize+j]].getGreen(), 
            colorIndex[out[i*textureSize+j]].getBlue());
        }

        if (_pixSize < 5) {
          noStroke();
        } else {
          stroke(0);
        }

        rect(x+i*_pixSize, y+j*_pixSize, _pixSize, _pixSize);

        if (out[i*textureSize+j] == 0 && _pixSize > 20) {

          text("T", x+i*_pixSize+3, y+j*_pixSize+22);
        }

        stroke(0);
      }
    }
  }
}

void settings() {
  
  loadTextures();
  size(1000, levelHeight * pixSize*textureSize);
  
  texturePixSize = pixSize*textureSize;
  
  //String inputValue = JOptionPane.showInputDialog("Please input a value");
  //println(inputValue);
  
  PApplet.runSketch(args, ts);
}

void draw() {
  frameRate(editorFrameRate);
  background(backgroundFlash);
  backgroundFlash = sin(frameCount/10)*50+130;
    
  scrollBlock = (scroll*-1)/texturePixSize;
  
  int blockSize = pixSize*textureSize; 
  
  drawLevel();  
  
  roundX = round(mouseX/pixSize)*pixSize+pixSize/2 + scroll;
  roundY = round(mouseY/pixSize)*pixSize+pixSize/2;

  pixX = (mouseX / blockSize) + (scroll*-1)/texturePixSize;
  pixY = (mouseY / blockSize);

  blockX = (mouseX / blockSize) * blockSize;
  blockY = (mouseY / blockSize) * blockSize;

  fill(0);
  rect(blockX, blockY, pixSize*textureSize, pixSize*textureSize);
  
  //drawTexture(blockX + scroll, blockY, pixSize, selectedTexture);

  text(roundX + "\n" + roundY, 10, 10);
  text(pixX + "\n" + pixY, 10, 30);
  text(blockX + "\n" + blockY, 10, 70);
  
  text("texture width and height: " + pixSize*textureSize, 10, 100);
  
  text("scroll: " + scroll, 10, 120);
  text("scroll block: " + (scroll*-1)/texturePixSize, 10, 130);
  
  text("FPS: " + frameRate , width-60, 10);
  
  
  
  if (mousePressed) {
    level[pixY][pixX] = selectedTexture+"";
  }
  
  if(keyPressed) {
    if(key == 'a') {
      scroll+=scrollSpeed;
    }
    if(key == 'd') {
      scroll-=scrollSpeed;
    }
  }
  
  
}

void drawLevel() {
  
  int rectSize = pixSize*textureSize;
  
  for(int i = 0; i < 31 + scrollBlock; i++) {
    for(int j = 0; j < level.length; j++) {
      
      if(i > scrollBlock) {
      try {
        drawTexture(i*(textureSize*pixSize) + scroll, j*(textureSize*pixSize), pixSize, Integer.parseInt(level[j][i]));
        
      } catch(NumberFormatException nfe) {
        
      }
    }
    
    if(i > scrollBlock) {
      noFill();
      rect(i*(textureSize*pixSize) + scroll, j*(textureSize*pixSize), rectSize, rectSize);
      }
      
    }
  }
}

void importLevel() {
  println();
  println();
  println();
  
  try {
    String texStr = "";
    for (int i = 0; i < loadStrings(levelLoadFilename).length; i++) {
      texStr+=loadStrings(levelLoadFilename)[i] + "\n";
    }
    
    //println(texStr);
    Object obj = new JSONParser().parse(texStr);
    org.json.simple.JSONObject jObj = (org.json.simple.JSONObject) obj;
    
    String levelJSON = jObj.get("level1") + "";
    String[] imLevel = levelJSON.split("%");
    
    for(int i = 0; i < imLevel.length; i++) {
      
      //println(imLevel[i]);
      
      //String[] asdasd = imLevel[i].split("\\.");
      //println(asdasd.length);
      //for(int q = 0; q < asdasd.length; i++) {
      //  print(asdasd[q]);
      //}
      //println();
      
      level[i] = imLevel[i].split("\\.");
      
    }
    
    
  } 
  catch(Exception e) {
    println("error when loading level ");
  }
  
}

void exportLevel() {
  String levelFinalExport = "";
  
  for(int i = 0; i < levelHeight; i++) {
    for(int j = 0; j < level[0].length; j++) {
      
      if(level[i][j] == null) {
        levelFinalExport += "0.";
      } else {
        levelFinalExport += level[i][j] + ".";
      }
      
    }
    levelFinalExport = levelFinalExport.substring(0, levelFinalExport.length()-1);
    levelFinalExport += "%";
  }
  
  levelFinalExport = levelFinalExport.substring(0, levelFinalExport.length()-1);
  
  processing.data.JSONObject jobj = new processing.data.JSONObject();
  jobj.put("level1", levelFinalExport);
  
  //println(jobj.toString());
  saveStrings("levels.json", jobj.toString().split("\n"));
  
}

void loadTextures() {

  try {
    String texStr = "";
    for (int i = 0; i < loadStrings(textureFilename).length; i++) {
      texStr+=loadStrings(textureFilename)[i] + "\n";
    }
    println(texStr);
    Object obj = new JSONParser().parse(texStr);
    org.json.simple.JSONObject jObj = (org.json.simple.JSONObject) obj;

    //println(jObj.get("colorIndex"));
    textureSize = Integer.parseInt(jObj.get("textureSize").toString());
    println("texture size: " + textureSize);

    bgr = Color.decode(jObj.get("background").toString()).getRed();
    bgg = Color.decode(jObj.get("background").toString()).getGreen();
    bgb = Color.decode(jObj.get("background").toString()).getBlue();
    println("BACKGROUND R: " + bgr + " G: " + bgg + " B: " + bgb);
    println();

    //Color index
    println("Color Index: ");
    org.json.simple.JSONObject clrJson = (org.json.simple.JSONObject) jObj.get("colorIndex");

    colorIndex[0] = new Color(bgr, bgg, bgb);

    for (int i = 1; i < level[0].length; i++) {
      if (clrJson.get(i+"") != null) {
        colorIndex[i] = Color.decode(clrJson.get(i+"")+"");
        println(colorIndex[i]);
      } else {
        break;
      }
      println(i + "    " + clrJson.get(i+""));
    }

    println();

    //Texture data
    println("Texture Data: ");
    org.json.simple.JSONObject texJson = (org.json.simple.JSONObject) jObj.get("textureData");

    for (int i = 0; i < level[0].length; i++) {
      if (texJson.get(i+"") != null) {
        texturepack[i] = texJson.get(i+"").toString();
        //println(texturepack[i]);
      } else {
        texturepackLength = i;
        break;
      }
      println(i + "    " + texJson.get(i+""));
    }
  } 
  catch(Exception e) {
    println("error when loading textures ");
  }
}

void drawTexture(int x, int y, int _pixSize, int texPackNum) {
  fill(bgr, bgg, bgb);

  String[] strOut = new String[textureSize*textureSize]; 
  int[] out = new int[strOut.length];

  for (int i = 0; i < strOut.length; i++) {
    strOut[i] = texturepack[texPackNum].charAt(i*2) + "";
  }

  for (int i = 0; i < strOut.length; i++) {
    out[i] = Integer.parseInt(strOut[i]);
  }

  for (int i = 0; i < textureSize; i++) {
    for (int j = 0; j < textureSize; j++) {

      if (out[i*textureSize+j] == 0) {
        fill(bgr, bgg, bgb);
      } else {
        fill(colorIndex[out[i*textureSize+j]].getRed(), 
          colorIndex[out[i*textureSize+j]].getGreen(), 
          colorIndex[out[i*textureSize+j]].getBlue());
      }

      if (_pixSize < 5) {
        noStroke();
      } else {
        stroke(0);
      }

      rect(x+i*_pixSize, y+j*_pixSize, _pixSize, _pixSize);

      if (out[i*textureSize+j] == 0 && _pixSize > 20) {

        text("T", x+i*_pixSize+3, y+j*_pixSize+22);
      }

      stroke(0);
    }
  }
}

void keyReleased() {
  if (key == 'w' && selectedTexture > 0) {
    selectedTexture--;
  }
  if (key == 's' && selectedTexture < texturepackLength-1) {
    selectedTexture++;
  }
  if(key == 'x') {
    exportLevel();
  }
  if(key == 'z') {
    importLevel();
  }
}
