class Grid {
  public int w;
  public int h;
  
  public int[][] grid;
  // 0 is empty
  // 1 is single cell piece
  // 2 is 2 wide
  // 3 is 2 tall
  // 4 is 3 wide
  // 5 is 3 tall
  // 6 is 4 wide
  // 7 is 4 tall
  // 8 is 5 wide
  // 9 is 5 tall
  // 10 is r piece
  // 11 is l piece
  // 12 is j piece
  // 13 is t piece (flipped j)
  // 14 is R piece
  // 15 is L piece
  // 16 is J piece 
  // 17 is T piece (flipped J)
  // 18 is 2x2 block
  // 19 is 3x3 block
  
  public color cellCol(int n) {
    colorMode(RGB);
    
    if (n == 0) {
      return color(40);
    } else if (n == 1) {
      return color(125,143,214);
    } else if (n == 2 || n == 3) { // 2 wide, tall
      return color(255,197,61);
    } else if (n == 4 || n == 5) { // 3 wide, tall
      return color(237,149,74);
    } else if (n == 6 || n == 7) { // 4 wide, tall
      return color(231,107,131);
    } else if (n == 8 || n == 9) { // 5 wide, tall
      return color(218,101,83);
    } else if (n >= 10 && n <= 13) { // r,l,j,t
      return color(88,203,135);
    } else if (n >= 14 && n <= 17) { // R,L,J,T
      return color(91,189,229);
    } else if (n == 18) { // 2x2
      return color(153,220,80);
    } else if (n == 19) { // 3x3
      return color(76,214,178);
    }
    
    return 0;
  }
  
  public boolean isAnySpotAvailable(int[][] shape) {
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        if (shapeFitsAtPosition(shape, x, y)) {
          return true;
        }
      }
    }
    return false;
  }

  private boolean shapeFitsAtPosition(int[][] shape, int x, int y) {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[0].length; j++) {
        int shapeVal = shape[i][j];
        int gridVal = getGridValue(x + i, y + j);
        if (shapeVal == 1 && gridVal != 0) {
          return false;
        }
      }
    }
    return true;
  }
  
  private int getGridValue(int x, int y) {
    if (x < 0 || x >= w || y < 0 || y >= h) {
      return -1; // out of bounds
    }
    return grid[x][y];
  }
  
  // outputs grid position as a pvector
  public PVector worldToGridPos(PVector worldPos) {
    PVector ret = new PVector(-1, -1);
    
    PVector gtl = new PVector(gridMargin, gridMargin);
    PVector gbr = new PVector(width - gridMargin, marginBot);
    
    if ((worldPos.x < gtl.x && worldPos.y < gtl.y) &&
        (worldPos.x > gbr.x && worldPos.y > gbr.y)) {
        return ret;
    }
    
    PVector adjPos = new PVector(worldPos.x - gtl.x, worldPos.y - gtl.y);
    //stroke(0,255,0);
    //strokeWeight(10);
    //point(gtl.x + adjPos.x, gtl.y + adjPos.y);
    int gridX = int(round((adjPos.x) / int(cs + (cs * padMult))));
    int gridY = int(round((adjPos.y) / int(cs + (cs * padMult))));
    
    ret = new PVector(gridX, gridY);
    return ret;
  }
  
  public PVector worldToGridPosFlt(PVector worldPos) {
    PVector ret = new PVector(-1, -1);
    
    PVector gtl = new PVector(gridMargin, gridMargin);
    PVector gbr = new PVector(width - gridMargin, marginBot);
    
    if ((worldPos.x < gtl.x && worldPos.y < gtl.y) &&
        (worldPos.x > gbr.x && worldPos.y > gbr.y)) {
        return ret;
    }
    
    PVector adjPos = new PVector(worldPos.x - gtl.x, worldPos.y - gtl.y);
    //stroke(0,255,0);
    //strokeWeight(10);
    //point(gtl.x + adjPos.x, gtl.y + adjPos.y);
    float gridX = (adjPos.x) / int(cs + (cs * padMult));
    float gridY = (adjPos.y) / int(cs + (cs * padMult));
    
    ret = new PVector(gridX, gridY);
    return ret;
  }
  
  public PVector gridToWorldPos(PVector gridPos) {
    PVector ret = new PVector(0, 0);
    
    PVector gtl = new PVector(gridMargin, gridMargin);
    
    float worldX = gridPos.x * int(cs + (cs * padMult)) + gtl.x;
    float worldY = gridPos.y * int(cs + (cs * padMult)) + gtl.y;
    
    ret = new PVector(worldX, worldY);
    
    return ret;
  }
  
  public void clearFullRowsAndCols() {
    boolean[] fullRows = new boolean[h];
    boolean[] fullCols = new boolean[w];

    // check for full rows and columns
    for (int i = 0; i < w; i++) {
      boolean isColFull = true;
      for (int j = 0; j < h; j++) {
        if (grid[i][j] == 0) {
          isColFull = false;
          break;
        }
      }
      if (isColFull) fullCols[i] = true;
    }
    
    for (int j = 0; j < h; j++) {
      boolean isRowFull = true;
      for (int i = 0; i < w; i++) {
        if (grid[i][j] == 0) {
          isRowFull = false;
          break;
        }
      }
      if (isRowFull) fullRows[j] = true;
    }

    // clear full rows and columns
    for (int i = 0; i < w; i++) {
      if (fullCols[i]) {
        for (int j = 0; j < h; j++) {
          grid[i][j] = 0;
        }
      }
    }

    for (int j = 0; j < h; j++) {
      if (fullRows[j]) {
        for (int i = 0; i < w; i++) {
          grid[i][j] = 0;
        }
      }
    }
  }
  
  public void init() {
    grid = new int [w][h];
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        grid[i][j] = 0;
      }
    }
  }
  
  Grid (int wid, int hgt) {
    w = wid;
    h = hgt;
    init();
  }
}
