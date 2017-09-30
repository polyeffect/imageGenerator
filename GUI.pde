void setupGUI() {
  color activeColor = color(52, 95, 95);
  color foregroundColor = color(37, 89, 50);
  color captionTextColor = color(0, 0, 0);
  color valueTextColor = color(0, 0, 100);
  controlP5 = new ControlP5(this);

  // set color
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(100));
  controlP5.setColorForeground(foregroundColor);
  controlP5.setColorCaptionLabel(captionTextColor);
  controlP5.setColorValueLabel(valueTextColor);

  ControlGroup ctrl = controlP5.addGroup("menu", 15, 25, 35);
  ctrl.activateEvent(true);
  ctrl.setColorLabel(color(255));
  ctrl.close();

  sliders = new Slider[30];
  ranges = new Range[30];
  toggles = new Toggle[30];

  int left = 0;
  int top = 5;
  int len = 300;
  int hei = 15;

  int si = 0;
  int ri = 0;
  int ti = 0;
  int posY = 0;

  sliders[si++] = controlP5.addSlider("agentsCount", 1, 10000, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("agentsLife", 1, 1000, left, top+posY+20, len, 15);
  sliders[si++] = controlP5.addSlider("agentsRes", 2, 30, left, top+posY+40, len, 15);
  sliders[si++] = controlP5.addSlider("polygonScale", 1, 4, left, top+posY+60, len, 15);
  posY += 90;

  sliders[si++] = controlP5.addSlider("noiseScale", 1, 1000, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("noiseStrength", 0, 100, left, top+posY+20, len, 15);
  posY += 50;

  sliders[si++] = controlP5.addSlider("strokeWidth", 0, 2, left, top+posY+0, len, 15);
  posY += 30;

  sliders[si++] = controlP5.addSlider("agentsAlpha", 0, 255, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("strokeAlpha", 0, 255, left, top+posY+20, len, 15);
  sliders[si++] = controlP5.addSlider("overlayAlpha", 0, 255, left, top+posY+40, len, 15);
  sliders[si++] = controlP5.addSlider("lumin", 0, 255, left, top+posY+60, len, 15);
  posY += 90;

  toggles[ti] = controlP5.addToggle("isDark", isDark, left+0, top+posY, 15, 15);
  toggles[ti++].setLabel("Invert brightness value");
  toggles[ti] = controlP5.addToggle("isGrayscale", isGrayscale, left+0, top+posY+20, 15, 15);
  toggles[ti++].setLabel("Grayscale Mode");
  toggles[ti] = controlP5.addToggle("isBnW", isBnW, left+0, top+posY+40, 15, 15);
  toggles[ti++].setLabel("B&W Mode");
  toggles[ti] = controlP5.addToggle("invertB", invertB, left+150, top+posY+40, 15, 15);
  toggles[ti++].setLabel("InvertBlack");
  toggles[ti] = controlP5.addToggle("isBezier", isBezier, left+0, top+posY+60, 15, 15);
  toggles[ti++].setLabel("Bezier Draw Mode");
  posY += 110;

  sliders[si++] = controlP5.addSlider("H", 0, 360, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("S", 0, 100, left, top+posY+20, len, 15);
  sliders[si++] = controlP5.addSlider("B", 0, 100, left, top+posY+40, len, 15);
  posY += 70;
  sliders[si++] = controlP5.addSlider("SH", 0, 360, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("SS", 0, 100, left, top+posY+20, len, 15);
  sliders[si++] = controlP5.addSlider("SB", 0, 100, left, top+posY+40, len, 15);
  toggles[ti] = controlP5.addToggle("isStrokeColor", isStrokeColor, left+0, top+posY+60, 15, 15);
  toggles[ti++].setLabel("Stroke Color Mode");
  posY += 90;
  ranges[ri++] = controlP5.addRange("ConnectRange", 0, 500, minConnRadius, maxConnRadius, left, top+posY+0, len, 15);
  //sliders[si++] = controlP5.addSlider("connectionRadius",0,100,left,top+posY+60,len,15);
  sliders[si++] = controlP5.addSlider("bezierAngle", 0, 100, left, top+posY+20, len, 15);

  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].getCaptionLabel().toUpperCase(true);
    sliders[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    sliders[i].getCaptionLabel().getStyle().marginTop = -4;
    sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
    sliders[i].getCaptionLabel().getStyle().marginRight = -14;
    sliders[i].getCaptionLabel().setColorBackground(0xFFFFFFFF);
  }
  for (int i = 0; i < ti; i++) {
    toggles[i].setGroup(ctrl);
    toggles[i].setColorCaptionLabel(color(50));
    toggles[i].getCaptionLabel().getStyle().padding(4, 3, 1, 3);
    toggles[i].getCaptionLabel().getStyle().marginTop = -19;
    toggles[i].getCaptionLabel().getStyle().marginLeft = 18;
    toggles[i].getCaptionLabel().getStyle().marginRight = 5;
    toggles[i].getCaptionLabel().setColorBackground(0xFFffffff);
  }
  for (int i = 0; i < ri; i++) {
    ranges[i].setGroup(ctrl);
    ranges[i].getCaptionLabel().toUpperCase(true);
    ranges[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    ranges[i].getCaptionLabel().getStyle().marginTop = -4;
    ranges[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }
}

void drawGUI() {
  controlP5.show();
  controlP5.draw();
}

void hideGUI() {
  controlP5.hide();
}

void controlEvent(ControlEvent theControlEvent) {
  guiEvent = true;

  GUI = controlP5.getGroup("menu").isOpen();

  if (theControlEvent.isController()) {
    if (theControlEvent.getController().getName().equals("ConnectRange")) {
      float[] f = theControlEvent.getController().getArrayValue();
      minConnRadius = f[0];
      maxConnRadius = f[1];
    }
  }
}