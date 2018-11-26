import java.awt.Color;

Color[] colorIndex = new Color[10000];

String textureFilename = "textures.json";

String[] texturepack = new String[10000];

int bgr, bgg, bgb;
int textureSize = 0;
int colors = 0;
int texturepackLength = 0;
int pixSize = 10;
int selectedTexture = 0;
int selectedOption = 0;

boolean[] canCollide;
boolean[] canHurt;
boolean[] canBreak;
boolean[] isGoal;

org.json.simple.JSONObject ogJOBJ;



void setup() {

  importTexturepack();

  size(400, 600);
  println("length: " + texturepackLength);
  textSize(22);

  canCollide = new boolean[texturepackLength];
  canHurt = new boolean[texturepackLength];
  canBreak = new boolean[texturepackLength];
  isGoal = new boolean[texturepackLength];

  for (int i = 0; i < texturepackLength; i++) {
    canCollide[i] = false;
    canHurt[i] = false;
    canBreak[i] = false;
    isGoal[i] = false;
  }

  importAttributes();
}

void draw() {

  background(207);
  fill(0);
  text(selectedTexture + " : " + selectedOption, width-100, height-20);

  fill(207 + random(130));
  rect(10, 252, 150, textureSize * (pixSize + 2));

  for (int i = 0; i < 5; i++) {
    if (selectedTexture+i < texturepackLength && selectedTexture + i - 1 > 0) {

      drawTexture(40, 20 + i * textureSize * (pixSize + 5), pixSize, selectedTexture+i-2);
    }
  }

  for (int i = 0; i < 4; i++) {

    if (i == selectedOption) {
      fill(0);
      rect(180, 100 + selectedOption * 100, 120, 30);
    }

    fill(207 + random(130));
    rect(200, 100 + i * 100, 100, 30);

    fill(0);

    if (i == 0) {
      text("canCollide", 180, 100 + i * 100);
      text(canCollide[selectedTexture] + "", 210, 122 + i * 100);
    }

    if (i == 1) {
      text("canHurt", 180, 100 + i * 100);
      text(canHurt[selectedTexture] + "", 210, 122 + i * 100);
    }

    if (i == 2) {
      text("canBreak", 180, 100 + i * 100);
      text(canBreak[selectedTexture] + "", 210, 122 + i * 100);
    }

    if (i == 3) {
      text("isGoal", 180, 100 + i * 100);
      text(isGoal[selectedTexture] + "", 210, 122 + i * 100);
    }
  }

  if (keyPressed) {

    if (key == 'w' && selectedTexture > 0) {
      selectedTexture--;
      keyPressed = false;
    }

    if (key == 's' && selectedTexture < texturepackLength - 3) {
      selectedTexture++;
      keyPressed = false;
    }

    if (key == 'p') {
      for (int i = 0; i < texturepackLength; i++) {
        canCollide[i] = false;
        canHurt[i] = false;
        canBreak[i] = false;
        isGoal[i] = false;
      }
    }

    if (keyCode == DOWN && selectedOption < 3) {
      selectedOption++;
      keyPressed = false;
    }

    if (keyCode == UP && selectedOption > 0) {
      selectedOption--;
      keyPressed = false;
    }

    if (key == 'x') {
      exportAttributes();
      keyPressed = false;
    }

    if (keyCode == RIGHT) {
      if (selectedOption == 0) {
        canCollide[selectedTexture] = true;
      }
      if (selectedOption == 1) {
        canHurt[selectedTexture] = true;
      }
      if (selectedOption == 2) {
        canBreak[selectedTexture] = true;
      }
      if (selectedOption == 3) {
        isGoal[selectedTexture] = true;
      }

      keyPressed = false;
    }

    if (keyCode == LEFT) {
      if (selectedOption == 0) {
        canCollide[selectedTexture] = false;
      }
      if (selectedOption == 1) {
        canHurt[selectedTexture] = false;
      }
      if (selectedOption == 2) {
        canBreak[selectedTexture] = false;
      }
      if (selectedOption == 3) {
        isGoal[selectedTexture] = false;
      }

      keyPressed = false;
    }
  }

  canCollide[0] = false;
  canHurt[0] = false;
  canBreak[0] = false;
}

void exportAttributes() {
  println();
  org.json.simple.JSONObject atts = new org.json.simple.JSONObject();

  String collideComp = "", breakComp = "", hurtComp = "", goalComp = "";

  for (int i = 0; i < texturepackLength; i++) {

    if (canCollide[i] == true) {
      collideComp += i + ",";
    }
    if (canHurt[i] == true) {
      hurtComp += i + ",";
    }
    if (canBreak[i] == true) {
      breakComp += i + ",";
    }
    if (isGoal[i] == true) {
      goalComp += i + ",";
    }
  }

  if (collideComp.length() > 0) {
    collideComp = collideComp.substring(0, collideComp.length()-1);
  }

  if (breakComp.length() > 0) {
    breakComp = breakComp.substring(0, breakComp.length()-1);
  }

  if (hurtComp.length() > 0) {
    hurtComp = hurtComp.substring(0, hurtComp.length()-1);
  }

  if (goalComp.length() > 0) {
    goalComp = goalComp.substring(0, goalComp.length()-1);
  }

  atts.put("canCollide", collideComp);
  atts.put("canBreak", breakComp);
  atts.put("canHurt", hurtComp);
  atts.put("isGoal", goalComp);

  println("exported attributes");
  println("attributes: " + atts);
  println();
  org.json.simple.JSONObject ogJOBJwAtts = ogJOBJ;
  ogJOBJwAtts.put("attributes", atts);

  println(ogJOBJwAtts);
  saveStrings("textures with attributes.json", ogJOBJwAtts.toString().split("\n"));
}

void drawTexture(int x, int y, int _pixSize, int texPackNum) {
  fill(255);

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

void importTexturepack() {

  try {
    String texStr = "";
    for (int i = 0; i < loadStrings(textureFilename).length; i++) {
      texStr+=loadStrings(textureFilename)[i] + "\n";
    }
    //println(texStr);
    Object obj = new JSONParser().parse(texStr);

    org.json.simple.JSONObject jObj = (org.json.simple.JSONObject) obj;

    ogJOBJ = (org.json.simple.JSONObject) obj;

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
    colors = 1;
    for (int i = 1; i < 1000; i++) {
      if (clrJson.get(i+"") != null) {
        colorIndex[i] = Color.decode(clrJson.get(i+"")+"");
        colors++;
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

    for (int i = 0; i < 1000; i++) {
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

void importAttributes() {

  println();
  println("attributes: ");

  //maybe attributes

  if (ogJOBJ.get("attributes") == null) {

    println("texturepack has no attribute data");
  } else {

    println(ogJOBJ.get("attributes"));

    org.json.simple.JSONObject attIn = (org.json.simple.JSONObject) ogJOBJ.get("attributes");

    String inHurt = attIn.get("canHurt") + "";
    String inBreak = attIn.get("canBreak") + "";
    String inCollide = attIn.get("canCollide") + "";
    String inGoal = attIn.get("isGoal") + "";

    for (int i = 0; i < inCollide.split(",").length; i++) {
      canCollide[Integer.parseInt(inCollide.split(",")[i])] = true;
    }

    for (int i = 0; i < inBreak.split(",").length; i++) {
      canBreak[Integer.parseInt(inBreak.split(",")[i])] = true;
    }

    for (int i = 0; i < inHurt.split(",").length; i++) {
      canHurt[Integer.parseInt(inHurt.split(",")[i])] = true;
    }

    for (int i = 0; i < inGoal.split(",").length; i++) {
      isGoal[Integer.parseInt(inGoal.split(",")[i])] = true;
    }
  }
}
