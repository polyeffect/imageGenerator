class Agent {
  /* Noise Direction */
  int x, y, loc;
  PVector p, pOld;
  float stepSize, angle, radius;
  boolean isOutside = false;

  /* Oscillation Figure */
  int pointCount = 1500;
  PVector[] lissajousPoints = new PVector[0];

  int modFreq2X = 11;
  int modFreq2Y = 17;

  float lineWeight = 1;
  float lineAlpha = 20;

  boolean connectAllPoints = true;
  float connectionRadius = 110;
  int i0 = 0, i1 = 0, cnt = 0;

  Agent(int _x, int _y) {
    //this.loc = 
    this.x = _x;
    this.y = _y;

    p = new PVector(x, y);
    pOld = new PVector(p.x, p.y);
    stepSize = random(1, 5);
  }

  /* Random Directional */
  void randomDirection() {
    angle = noise(p.x/noiseScale, p.y/noiseScale) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y -= sin(angle) * stepSize;

    if (p.x<-10) isOutside = true;
    else if (p.x>width+10) isOutside = true;
    else if (p.y<-10) isOutside = true;
    else if (p.y>height+10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
    }

    strokeWeight(strokeWidth*stepSize);
    line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
    isOutside = false;
  }

  void randomDirection2() {
    angle = noise(p.x/noiseScale, p.y/noiseScale) * 24;
    angle = (angle - int(angle)) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y += sin(angle) * stepSize;

    if (p.x<-10) isOutside = true;
    else if (p.x>width+10) isOutside = true;
    else if (p.y<-10) isOutside = true;
    else if (p.y>height+10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
    }

    strokeWeight(strokeWidth*stepSize);
    line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
    isOutside = false;
  }

  /* Shape */
  //----- Ellipse -----//
  void ellipseGenerate(float cr) {
    radius = noise(p.x/noiseScale, p.y/noiseScale) * noiseStrength;
    ellipse(x, y, radius, radius);
  }
  void ellipseGenerateBW(float sz) {
    ellipse(x, y, sz, sz);
  }
  //----- Rectangle -----//
  void rectGenerate(float cr) {
    radius = noise(p.x/noiseScale, p.y/noiseScale) * noiseStrength;
    rect(x, y, radius, radius);
  }
  void rectGenerateBW(float sz) {
    rect(x, y, sz, sz);
  }
  //----- Triangle -----//
  void triangleGenerate(int n, float cr) {
    if (x%int(n*2) == 0) polygon(3, x, y, (n+2)/cr, PI/2.0);
    else polygon(3, x, y, (n+2)/cr, -PI/2.0);
  }
  //----- Hexagon -----//
  void hexagonGenerate(int n, float cr) {
    if (x%int(n*2) == 0) polygon(6, x, y-(n/4), (n)/cr, PI/1.0);
    else polygon(6, x, y+(n/4), (n)/cr, PI/1.0);
  }

  /* Ocsillation form */
  void oscillationEllipse(float cr, float sz) {
    radius = noise(p.x/noiseScale, p.y/noiseScale) * noiseStrength * (sz/50);
    ellipse(x, y, radius, radius);
  }

  void oscillationEllipseBW(float cr, float sz) {
    ellipse(x, y, sz, sz);
  }

  // polygon function
  void polygon(int n, float cx, float cy, float r, float startAngle) {
    if (n > 2) {
      float angle = TWO_PI/n;
      beginShape();
      for (int i = 0; i < n; i++) {
        vertex(cx + r * cos(startAngle + angle * i), 
          cy + r * sin(startAngle + angle * i));
      }
      endShape(CLOSE);
    }
  }
}