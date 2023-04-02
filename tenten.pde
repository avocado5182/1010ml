import java.io.*;
import java.util.*;

Grid grid;

int gridMargin = 20; // pixels of space around the grid
float pad = 2; // padding between grid cells
float padMult = 1; // equal to grid pad / grid cell size
float marginBot = 0; // bottom margin for ui positioning
float cs;
Piece[] toPlay; // list of pieces at the bottom which you play

// https://www.geeksforgeeks.org/print-2-d-array-matrix-java/
void print2D(int mat[][]) {
  // Loop through all rows
  for (int[] row : mat)
 
      // converting each row as string
      // and then printing in a separate line
      println(Arrays.toString(row));
}

void setup () {
  size(600,800);
  grid = new Grid(10, 10);
  
}

void drawGrid(Grid g) {
  cs = (width - (gridMargin * 2) - (pad * (g.w - 1))) / g.w;
  padMult = pad / cs;
  marginBot = g.w * (cs + pad) + gridMargin;
  //fill(0, 0, 255);
  //rect(gridMargin, marginBot, width - gridMargin * 2, height - marginBot - gridMargin);
  
  //println(startPos);
  //println(cellSize);
  noStroke();
  for (int i = 0; i < g.w; i++) {
    for (int j = 0; j < g.h; j++) {
      fill(g.cellCol(g.grid[i][j]));
      //println(startPos.x + i * (cellSize + cellPadding));
      rect(gridMargin + i * (cs + pad), gridMargin + j * (cs + pad), cs, cs, 8);
    }
  }
}

Piece genPiece() {
  float r = random(1) * 42;
  int pc = int(floor(r));
  Piece p = new Piece();
  
  
  if (pc < 4) { // R, T, J, L; 0, 1, 2, 3
    pc += 14;
    p.type = pc;
    p.shape = p.getShape();
    return p;
  }
  
  if (pc < 24) { // . r t j l h v H V O; 4, 6, 8, 10, 12, 14, 16, 18, 20, 22
    switch(pc) {
      case 4:
        pc = 1;
        p.type = pc;
        p.shape = p.getShape();
        return p;
      case 22: 
        pc = 19;
        p.type = pc;
        p.shape = p.getShape();
        return p;
      case 5: 
        pc = 10;
        p.type = pc;
        p.shape = p.getShape();
        return p;
      default:
        break;
    }
    
    if (pc >= 6 && pc <= 20) {
      pc -= 6;
      pc /= 2;
      pc += 6;
      p.type = pc;
      p.shape = p.getShape();
      return p;
    }
  }
  if (pc < 36) { // - i _ I; 24, 27, 30, 33
    pc -= 24; // 6 to -18
    pc /= 3;  // -18 to -6
    pc += 2;  // -6 to -4
    p.type = pc;
    p.shape = p.getShape();
    return p;
  }
  if (pc < 42) {
    p.type = 18;
    p.shape = p.getShape();
    return p;
  }
  
  p.type = 1;
  p.shape = p.getShape();
  return p;
}

void drawPieceInRect(PVector tl, PVector br, Piece p) {
  color pcCol = grid.cellCol(p.type);
  float red = red(pcCol);
  float green = green(pcCol);
  float blue = blue(pcCol);
  
  for (int i = 0; i < p.shape.length; i++) {
    for (int j = 0; j < p.shape[0].length; j++) {
      //stroke(255,0,0);
      //strokeWeight(5);
      //point(tl.x, tl.y);
      //point(br.x, br.y);
      
      color cellCol = color(red, green, blue, p.shape[i][j] * 255);
      fill(cellCol);
      if (alpha(cellCol) == 0) noStroke();
      else {
        strokeWeight(0);
        stroke(0);
      }
      //rect(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
      
      float usableWidth = (br.x - tl.x) * (1 - padMult); // width of inputted rectangle
      float cellSize = (usableWidth) / 5;
      float padAmt = (br.x - tl.x) * padMult;
      float xPad = i * padAmt;
      float yPad = j * padAmt;
      float xOff = cellSize * (5 - p.shape.length) / 2;
      float yOff = cellSize * (4 - p.shape[0].length) / 2;
      float xPos = cellSize * i + p.tl.x + xOff + xPad / 3;
      float yPos = cellSize * j + p.tl.y + yOff + yPad / 3;
      
      rect(xPos, yPos, cellSize, cellSize, 8);
    }
  }
}

void drawPieceInRect(PVector tl, PVector br, Piece p, color fillCol) {
  for (int i = 0; i < p.shape.length; i++) {
    for (int j = 0; j < p.shape[0].length; j++) {
      fill(red(fillCol), green(fillCol), blue(fillCol), p.shape[i][j] * alpha(fillCol));
      if (alpha(fillCol) * p.shape[i][j] == 0) noStroke();
      else {
        strokeWeight(0);
        stroke(0);
      }
      //rect(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
      
      float usableWidth = (br.x - tl.x) * (1 - padMult); // width of inputted rectangle
      float cellSize = (usableWidth) / 5;
      float padAmt = (br.x - tl.x) * padMult;
      float xPad = i * padAmt;
      float yPad = j * padAmt;
      float xOff = cellSize * (5 - p.shape.length) / 2;
      float yOff = cellSize * (4 - p.shape[0].length) / 2;
      float xPos = cellSize * i + tl.x + xOff + xPad / 3;
      float yPos = cellSize * j + tl.y + yOff + yPad / 3;
      
      rect(xPos, yPos, cellSize, cellSize, 8);
    }
  }
}

void regenerateToPlay() {
  toPlay = new Piece[3];
  for (int i = 0; i < toPlay.length; i++) {
    toPlay[i] = genPiece();
    Piece pc = toPlay[i];
    pc.held = false;
    
    //println(pc.type);
    float usableWidth = (width - (gridMargin * 2));
    
    float renderWidth = (usableWidth) / (toPlay.length);
    float padding = (usableWidth - (renderWidth * toPlay.length)) / (toPlay.length + 1);
    PVector tl = new PVector(gridMargin + (renderWidth * i) + padding, marginBot + gridMargin);
    PVector br = new PVector(gridMargin + (renderWidth * (i + 1)) + padding, height - gridMargin * 2);
    
    pc.ogtl = tl;
    pc.ogbr = br;
    pc.tl = tl;
    pc.br = br;
  }
}

void drawToPlay() {
  if (toPlay == null || toPlay.length == 0) {
    // regenerate toPlay
    regenerateToPlay();
  }
  
  for (Piece pc : toPlay) {
    if (pc == null) continue;
    boolean isColliding = rectPtCollides(pc.tl, pc.br, new PVector(mouseX, mouseY));
    
    if (pc.heldFirst && isColliding) {
      Grid g = grid;
      cs = (width - (gridMargin * 2) - (pad * (g.w - 1))) / g.w;
      
      // scale up the piece to fit the grid
      float usableWidth = (width - (gridMargin * 2));
      float renderWidth = (usableWidth) / (toPlay.length);
      
      float scaleAmt = (cs * 5) / renderWidth;
      PVector center = new PVector(
        pc.tl.x + (pc.br.x-pc.tl.x) / 2, 
        pc.tl.y + (pc.br.y-pc.tl.y) / 2
      );
      
      pc.tl = new PVector(
        center.x - ((center.x - pc.ogtl.x) * scaleAmt),
        center.y - ((center.y - pc.ogtl.y) * scaleAmt)
      );
      
      pc.br = new PVector(
        center.x - ((center.x - pc.ogbr.x) * scaleAmt),
        center.y - ((center.y - pc.ogbr.y) * scaleAmt)
      );
    } else if (pc.tl != pc.ogtl && pc.br != pc.ogbr) {
      pc.tl = pc.ogtl;
      pc.br = pc.ogbr;
    }
    
    drawPieceInRect(
      pc.tl, 
      pc.br, 
      pc
    );
  }
}

void draw() {
  background(60);
  drawGrid(grid);
  drawToPlay();
}

boolean rectPtCollides(PVector tl, PVector br, PVector pt) {
  //(mouseX > rectX && mouseX < rectX + rectWidth && mouseY > rectY && mouseY < rectY + rectHeight)
  return (pt.x > tl.x && pt.x < br.x && pt.y > tl.y && pt.y < br.y);
}

Piece firstHeld;

void mousePressed() {
  PVector mouse = new PVector(mouseX, mouseY);
  for (Piece p : toPlay) {
    if (p == null) continue;
    
    boolean isColliding = rectPtCollides(p.tl, p.br, mouse);
    if (isColliding) {
      p.heldFirst = true;
      firstHeld = p;
    }
  }
}

void mouseDragged() {
  PVector mouse = new PVector(mouseX, mouseY);
  for (Piece p : toPlay) {
    if (p == null) continue;
    
    boolean isColliding = rectPtCollides(p.tl, p.br, mouse);
    p.held = false;
    
    // if colliding, first held is this, and this piece was first held on click
    if (isColliding && (firstHeld == null || firstHeld == p) && p.heldFirst) {
      // drag the piece around
      firstHeld = p;
      p.held = true;
      p.ogtl = new PVector(p.ogtl.x + mouse.x - pmouseX, p.ogtl.y + mouse.y - pmouseY);
      p.tl = p.ogtl;
      p.ogbr = new PVector(p.ogbr.x + mouse.x - pmouseX, p.ogbr.y + mouse.y - pmouseY);
      p.br = p.ogbr;
    } else {
      p.held = true;
    }
  }
}

void resetToPlayPiece(int i) {
  toPlay[i] = new Piece(toPlay[i].type);
  Piece pc = toPlay[i];
  pc.held = false;
  
  float usableWidth = (width - (gridMargin * 2));
  
  float renderWidth = (usableWidth) / (toPlay.length);
  float padding = (usableWidth - (renderWidth * toPlay.length)) / (toPlay.length + 1);
  PVector tl = new PVector(gridMargin + (renderWidth * i) + padding, marginBot + gridMargin);
  PVector br = new PVector(gridMargin + (renderWidth * (i + 1)) + padding, height - gridMargin * 2);
  
  pc.ogtl = tl;
  pc.ogbr = br;
  pc.tl = tl;
  pc.br = br;
}

void mouseReleased() {
  firstHeld = null;

  for (int i = 0; i < toPlay.length; i++) {
    Piece p = toPlay[i];

    if (p == null) {
      continue;
    }

    if (p.heldFirst) {
      PVector shapedGridPos = grid.worldToGridPos(p.shapedPcPos());

      if (isPieceOutOfBounds(p, shapedGridPos)) {
        resetToPlayPiece(i);
        break;
      }

      PVector gridPos = shapedGridPos;

      int[][] shapePlacement = new int[grid.w][grid.h];
      int[][] oldGrid = grid.grid;

      boolean makePieceNull = true;

      for (int j = 0; j < shapePlacement.length; j++) {
        for (int k = 0; k < shapePlacement[0].length; k++) {
          if (j < int(gridPos.x) || k < int(gridPos.y)) {
            shapePlacement[j][k] = grid.grid[j][k];
            continue;
          }

          if (j - int(gridPos.x) >= p.shape.length || k - int(gridPos.y) >= p.shape[0].length) {
            shapePlacement[j][k] = grid.grid[j][k];
            continue;
          }

          if (grid.grid[j][k] != 0 && p.shape[j - int(gridPos.x)][k - int(gridPos.y)] != 0) {
            shapePlacement = new int[grid.w][grid.h];
            grid.grid = oldGrid;
            makePieceNull = false;

            resetToPlayPiece(i);
            break;
          }

          shapePlacement[j][k] = p.shape[j - int(gridPos.x)][k - int(gridPos.y)] * p.type;
        }
      }

      grid.grid = p.unionArrays(grid.grid, shapePlacement);
      //grid.clearFullRows();
      //grid.clearFullCols();
      grid.clearFullRowsAndCols();

      if (makePieceNull) {
        p.shape = new int[5][5];
        toPlay[i] = null;
      }
    }

    p.heldFirst = false;
  }

  boolean allNull = true;

  for (int i = 0; i < toPlay.length; i++) {
    if (toPlay[i] != null) {
      allNull = false;
      break;
    }
  }
  
  boolean allAvailable = true;
  int nullPcs = 0;
  int unavailable = 0;
  for (Piece p: toPlay) {
    if (p == null) {
      nullPcs ++;
      continue;
    }
    if (!grid.isAnySpotAvailable(p.shape)) {
      allAvailable = false;
      unavailable ++;
    }
  }
  if (!allAvailable && unavailable >= toPlay.length - nullPcs ) {
    println("Tough luck bozo.");
    exit();
  }

  if (allNull) {
    regenerateToPlay();
  }
}

boolean isPieceOutOfBounds(Piece piece, PVector pos) {
  int[][] shape = piece.getShape();
  for (int i = 0; i < shape.length; i++) {
    for (int j = 0; j < shape[i].length; j++) {
      if (shape[i][j] != 0) {
        int newX = int(pos.x) + i;
        int newY = int(pos.y) + j;
        if (newX < 0 || newX >= grid.w || newY < 0 || newY >= grid.h || grid.grid[newX][newY] != 0) {
          return true;
        }
      }
    }
  }
  return false;
}
