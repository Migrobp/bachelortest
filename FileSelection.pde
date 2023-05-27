Map<String, Object> makeItem(String theLabel) {
  Map m = new HashMap<String, Object>();
  m.put("label", theLabel);
  return m;
}

void menu(int i) {
  println("Pressed File" + i);
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("menu")) {
    int index = int(theEvent.getValue());
    Map m = ((SilderList)theEvent.getController()).getItem(index);
    println("Got event on this item: " + m);
  }
}

public void loadFiles() {
  if (isOnRaspBerry) {
    testDir = new File(dataPath("/media/hello/"));
    testFiles = testDir.listFiles();
    if (testFiles.length > 0) {
      dir = new File(sketchPath("/media/hello/" + testFiles[0].getName()));
      files = dir.listFiles();
    }
  }
  if (!isOnRaspBerry) {
    dir = new File(sketchPath("projectorObjects/"));
    files = dir.listFiles();
  }

  SilderList m = new SilderList(cp5, "menu", 160, 440);
  m.setPosition(800 - 160 - 20, 20);
  if (files != null) {
    for (int i = 0; i < files.length; i++) {
      m.addItem(makeItem(files[i].getName()));
      if (i == files.length - 1) {
        m.addItem(makeItem("REFRESH"));
      }
    }
  } else {
    m.addItem(makeItem("NO USB DEVICE INSERTED"));
    m.addItem(makeItem("REFRESH"));
  }
}

class SilderList extends Controller<SilderList> {
  float pos, npos;
  int itemHeight = 60;
  int scrollerLength = 40;
  int pressableAreaWidth = 60;
  int pressableAreaHeight = 50;
  int fileButtonX = 5;
  int fileButtonY = 5;

  int dragMode = 0;
  int buttonIndex = -1;

  List< Map<String, Object>> items = new ArrayList< Map<String, Object>>();
  PGraphics menu;
  boolean updateMenu;

  SilderList(ControlP5 c, String theName, int theWidth, int theHeight) {
    super( c, theName, 0, 0, theWidth, theHeight );
    c.register( this );
    menu = createGraphics(getWidth(), getHeight());

    setView(new ControllerView<SilderList>() {

      public void display(PGraphics pg, SilderList t ) {
        if (updateMenu) {
          updateMenu();
        }
        if (inside() ) { // draw scrollbar
          menu.beginDraw();
          int len = -(itemHeight * items.size());
          int ty = int(map(pos, len, 0, getHeight() - scrollerLength - 2, 2 ) );
          menu.fill(listBackgroundColor);
          menu.rect(getWidth()-6, ty, 4, scrollerLength );
          menu.endDraw();
        }
        pg.image(menu, 0, 0);
      }
    }
    );
    updateMenu();
  }

  // only update the image buffer when necessary - to save some resources
  void updateMenu() {
    int len = -(itemHeight * items.size()) ;
    npos = constrain(npos, len, 0);
    pos += (npos - pos) * 0.1;

    /// draw the SliderList
    menu.beginDraw();
    menu.noStroke();
    // List color !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    menu.background(listBackgroundColor);
    menu.textFont(cp5.getFont().getFont());
    menu.pushMatrix();
    menu.translate( 0, int(pos) );
    menu.pushMatrix();

    int i0 = PApplet.max( 0, int(map(-pos, 0, itemHeight * items.size(), 0, items.size())));
    int range = ceil((float(getHeight())/float(itemHeight))+1);
    int i1 = PApplet.min( items.size(), i0 + range );

    menu.translate(0, i0*itemHeight);

    for (int i=i0; i<i1; i++) {
      Map m = items.get(i);
      menu.noStroke();
      menu.fill(listLineColor);
      menu.rect(0, itemHeight-1, getWidth(), 1 );
      menu.fill(listTextColor);
      String txt = String.format("%s", m.get("label").toString().toUpperCase());
      menu.text(txt, 20, 30 );
      menu.fill(255);
      menu.translate( 0, itemHeight );
    }
    menu.popMatrix();
    menu.popMatrix();
    menu.endDraw();
    updateMenu = abs(npos-pos)>0.01 ? true:false;
  }

  // when detecting a click, check if the click happend to the far right,
  // if yes, scroll to that position, otherwise do whatever this item of
  // the list is supposed to do.
  public void onClick() {
    if (getPointer().x()>getWidth()-10) {
      npos= -map(getPointer().y(), 0, getHeight(), 0, items.size()*itemHeight);
      updateMenu = true;
    }
  }

  public void onPress() {
    int x = getPointer().x();
    int y = (int)(getPointer().y()-pos)%itemHeight;
    boolean withinButton = within(x, y, fileButtonX, fileButtonY, pressableAreaWidth, pressableAreaHeight);
    dragMode =  withinButton ? 2:1;
    // Checks if you press inside the box !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if (withinButton) {
      buttonIndex = getIndex();
      fileName = items.get(buttonIndex).get("label").toString();
      selectedImg = fileName;
      if (fileName == "REFRESH") {
        println("REFRESH PRESSED");
        if (files != null) {
          files = null;
        }
        loadFiles();
      } else if (fileName == "NO USB DEVICE INSERTED") {
        return;
      }
      showPreview = "no";
    }
    imgWidthFactor = 1;
    imgHeightFactor = 1;
    updateMenu = true;
  }

  public void onDrag() {
    switch(dragMode) {
      case(1): // drag and scroll the list
      npos += getPointer().dy() * 2;
      updateMenu = true;
      break;
    }
  }

  public void onScroll(int n) {
    npos += ( n * 4 );
    updateMenu = true;
  }

  void addItem(Map<String, Object> m) {
    items.add(m);
    updateMenu = true;
  }

  Map<String, Object> getItem(int theIndex) {
    return items.get(theIndex);
  }

  private int getIndex() {
    int len = itemHeight * items.size();
    int index = int(map(getPointer().y() - pos, 0, len, 0, items.size() ) ) ;
    return index;
  }
}

public static float f( Object o ) {
  return ( o instanceof Number ) ? ( ( Number ) o ).floatValue( ) : Float.MIN_VALUE;
}

public static boolean within(int theX, int theY, int theX1, int theY1, int theW1, int theH1) {
  return (theX>theX1 && theX<theX1+theW1 && theY>theY1 && theY<theY1+theH1);
}
