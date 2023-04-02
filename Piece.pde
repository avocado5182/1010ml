import java.io.*;
import java.util.*;

class Piece {
  public int type;
  public int[][] shape; // row then col, 0 is empty, 1 is filled
  public PVector ogtl; // og tl & br are used to scale the piece when dragging
  public PVector ogbr;
  public PVector tl;
  public PVector br;
  public boolean heldFirst = false; // was this held when the mouse first clicked?
  public boolean held = false;      // is this piece currently being held?
  
  Piece(int t) {
    if (t < 0 || t > 19) t = 1;
    
    type = t;
    shape = getShape(type);
  }
  
  boolean equals(Piece p) {
    boolean ret = false;
    
    ret = 
      (type == p.type) &&
      (shape == p.shape) &&
      (tl == p.tl) && (br == p.br) &&
      (held == p.held);
    
    return ret;
  }
  
  public Piece() {
    type = 1;
    shape = getShape(type);
  }
  
  public PVector shapedPcPos() {
    // return a world position using this piece's tl and br
    // which is at the top left of the piece's rectangle/square
    // that includes the shape of the piece
    
    //// grid-aligned position of shape's top left
    //float shapeX = 2.5 - (shape.length);
    //float shapeY = 2.5 - (shape[0].length);
    
    // grid-aligned position of piece's top left
    PVector pcPos = grid.worldToGridPosFlt(tl);
    float pcX = pcPos.x;
    float pcY = pcPos.y;
    
    PVector gOff = new PVector(5 - shape.length, 5 - shape[0].length);
    PVector shapePos = new PVector(pcX + gOff.x / 2, pcY + gOff.y / 2); // grid-aligned, fractional
    shapePos = new PVector(round(shapePos.x), floor(shapePos.y));
    
    PVector worldPos = grid.gridToWorldPos(shapePos);
    
    return worldPos;
  }
  
  // 0, 0, 3, 1
  int[][] setRect(int x1, int y1, int x2, int y2, int val, boolean center) {
    if (center) {
      int[][] ret = new int[max(x2 - x1, x1, x2)][max(y2 - y1, y1, y2)];
      for (int i = x1; i < x2; i++) {
        for (int j = y1; j < y2; j++) {
          ret[i][j] = val;
        }
      }
      
      return ret;
    } else return setRect(x1, y1, x2, y2, val);
  }
  
  int[][] setRect(int x1, int y1, int x2, int y2, int val) {
    int maxX = max(x2 - x1, x1, x2);
    int maxY = max(y2 - y1, y1, y2);
    int[][] ret = new int[max(maxX, maxY)][max(maxX, maxY)];
    //println(x1, y1, x2, y2, val);
    //println(max(x2 - x1, x1, x2), max(y2 - y1, y1, y2));
    for (int i = x1; i < x2; i++) {
      for (int j = y1; j < y2; j++) {
        ret[i][j] = val;
      }
    }
    
    return ret;
  }
  
  int[][] unionArrays(int[][] a1, int[][] a2) {
    int arrWid = max(a1.length, a2.length); //
    int arrHgt = max(a1[0].length, a2[0].length);
    
    //println(a1[4][0]);
    
    int[][] ret = new int[arrWid][arrHgt];
    for (int i = 0; i < arrWid; i++) {
      for (int j = 0; j < arrHgt; j++) {
        if (i >= a1.length || j >= a1[0].length) continue;
        int a1Val = a1[i][j];
        //if (i >= a2.length || j >= a2[0].length) continue;
        int a2Val = a2[i][j];
        
        //ret[i][j] = max(a1Val, a2Val);
        
        if (!(a1Val == 0 && a2Val == 0)) {
          if (a2Val != 0) {
            ret[i][j] = a2Val;
          } else {
            ret[i][j] = max(a1Val, a2Val);
          }
        }
      }
    }
    
    return ret;
  }
  
  public int[][] getShape(int t) {
    int[][] ret = new int[1][1];
    
    switch (t) {
      case 0:
        return new int[1][1];
      case 1:
        ret = new int[1][1];
        ret[0][0] = 1;
        return ret;
      case 2:
        ret = new int[2][1];
        ret = setRect(0, 0, 2, 1, 1, true);
        return ret;
      case 3:
        ret = new int[1][2];
        ret = setRect(0, 0, 1, 2, 1, true);
        return ret;
      case 4:
        ret = new int[3][1];
        ret = setRect(0, 0, 3, 1, 1, true);
        return ret;
      case 5:
        ret = new int[1][3];
        ret = setRect(0, 0, 1, 3, 1, true);
        return ret;
      case 6:
        ret = new int[4][1];
        ret = setRect(0, 0, 4, 1, 1, true);
        return ret;
      case 7:
        ret = new int[1][4];
        ret = setRect(0,0,1,4,1, true);
        return ret;
      case 8:
        ret = new int[5][1];
        ret = setRect(0, 0, 5, 1, 1, true);
        return ret;
      case 9:
        ret = new int[1][5];
        ret = setRect(0,0,1,5,1, true);
        return ret;
      case 10:
        ret = new int[2][2];
        ret[0][0] = 1;
        ret[1][0] = 1;
        ret[0][1] = 1;
        return ret;
      case 11:
        ret = new int[2][2];
        ret[0][0] = 1;
        ret[0][1] = 1;
        ret[1][1] = 1;
        return ret;
      case 12:
        ret = new int[2][2];
        ret[1][0] = 1;
        ret[0][1] = 1;
        ret[1][1] = 1;
        return ret;
      case 13:
        ret = new int[2][2];
        ret[0][0] = 1;
        ret[0][1] = 1;
        ret[1][1] = 1;
        return ret;
      case 14: // R
        ret = new int[3][3];
        ret = unionArrays(setRect(0, 0, 1, 3, 1), setRect(0, 0, 3, 1, 1));
        return ret;
      case 15: // L
        ret = new int[3][3];
        ret = unionArrays(setRect(0, 0, 1, 3, 1), setRect(0, 2, 3, 3, 1));
        return ret;
      case 16: // J
        ret = new int[3][3];
        ret = unionArrays(setRect(0, 2, 3, 3, 1), setRect(2, 0, 3, 3, 1));
        return ret;
      case 17: // T
        ret = new int[3][3];
        ret = unionArrays(setRect(0, 0, 3, 1, 1), setRect(2, 0, 3, 3, 1));
        return ret;
      case 18:
        ret = new int[2][2];
        ret = setRect(0, 0, 2, 2, 1, true);
        return ret;
      case 19:
        ret = new int[3][3];
        ret = setRect(0, 0, 3, 3, 1, true);
        return ret;
      default:
        return new int[1][1];
    }
  }
  
  public int[][] getShape() {
    return getShape(type);
  }
}
