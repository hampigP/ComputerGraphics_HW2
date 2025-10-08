public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // Please paste your code from HW1 CGLine.
    int xi = round(x1), yi = round(y1);
    int xf = round(x2), yf = round(y2);

    int dx = abs(xf - xi);
    int dy = abs(yf - yi);
    int sx = xi < xf ? 1 : -1;
    int sy = yi < yf ? 1 : -1;
    int err = dx - dy;

    while (true) {
        drawPoint(xi, yi, color(0)); // 使用黑色畫筆
        if (xi == xf && yi == yf) break;
        int e2 = 2 * err;
        if (e2 > -dy) { err -= dy; xi += sx; }
        if (e2 <  dx) { err += dx; yi += sy; }
    }
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2 
    // You need to check the coordinate p(x,v) if inside the vertices. 
    // If yes return true, vice versa.
    if (vertexes == null || vertexes.length < 3) return false;

    boolean inside = false;
    int n = vertexes.length;

    for (int i = 0, j = n - 1; i < n; j = i++) {
      float xi = vertexes[i].x, yi = vertexes[i].y;
      float xj = vertexes[j].x, yj = vertexes[j].y;

      float dy = (yj - yi);
      float denom = (abs(dy) < 1e-12f) ? (dy < 0 ? -1e-12f : 1e-12f) : dy;

      boolean crosses = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / denom + xi);
      if (crosses) inside = !inside;
    }
    return inside;
}

public Vector3[] findBoundBox(Vector3[] v) {
    
    
    // TODO HW2 
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2
   
    Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    if (v != null && v.length > 0) {
        // 先用第一個點初始化（會覆蓋掉上面的 0/999）
        recordminV.x = v[0].x; recordminV.y = v[0].y; recordminV.z = v[0].z;
        recordmaxV.x = v[0].x; recordmaxV.y = v[0].y; recordmaxV.z = v[0].z;
        // 走訪其餘點，持續更新
        for (int i = 1; i < v.length; i++) {
            float px = v[i].x, py = v[i].y, pz = v[i].z;

            if (px < recordminV.x) recordminV.x = px;
            if (py < recordminV.y) recordminV.y = py;
            if (pz < recordminV.z) recordminV.z = pz;

            if (px > recordmaxV.x) recordmaxV.x = px;
            if (py > recordmaxV.y) recordmaxV.y = py;
            if (pz > recordmaxV.z) recordmaxV.z = pz;
        }
    } else {
        // 沒有頂點：回傳 (0,0,0) ~ (0,0,0)
        recordminV.x = recordminV.y = recordminV.z = 0;
        recordmaxV.x = recordmaxV.y = recordmaxV.z = 0;
    }
    
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertices of the "boundary".
    // The output is the vertices of the polygon.

    // 逐條邊裁切（假設 boundary 為逆時針 CCW；若是順時針，判定的 >= 0 改成 <= 0）
    for (int i = 0; i < points.length; i++) {
        input.add(points[i]);
    }
    float area = 0;
    for (int i = 0; i < boundary.length; i++) {
      Vector3 p = boundary[i];
      Vector3 q = boundary[(i + 1) % boundary.length];
      area += p.x * q.y - q.x * p.y; // 簽名面積：>0 表 CCW，<0 表 CW
    }
    boolean ccw = (area > 0);
  
  // 逐條邊裁切
    for (int b = 0; b < boundary.length; b++) {
      Vector3 A = boundary[b];
      Vector3 B = boundary[(b + 1) % boundary.length];
  
      output.clear();
      if (input.size() == 0) break;
  
      Vector3 S = input.get(input.size() - 1);
      for (int i = 0; i < input.size(); i++) {
        Vector3 E = input.get(i);
  
        float crossE = (B.x - A.x) * (E.y - A.y) - (B.y - A.y) * (E.x - A.x);
        float crossS = (B.x - A.x) * (S.y - A.y) - (B.y - A.y) * (S.x - A.x);
  
        // 根據 boundary 的方向決定內側判定
        boolean Ein = ccw ? (crossE >= 0) : (crossE <= 0);
        boolean Sin = ccw ? (crossS >= 0) : (crossS <= 0);
  
        if (Ein) {
            if (!Sin) {
                // 外->內：加交點
                float x1 = S.x, y1 = S.y, x2 = E.x, y2 = E.y;
                float x3 = A.x, y3 = A.y, x4 = B.x, y4 = B.y;
                float denom = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);
                float px, py;
                if (abs(denom) < 1e-12f) { px = E.x; py = E.y; }
                else {
                    px = ((x1*y2 - y1*x2)*(x3 - x4) - (x1 - x2)*(x3*y4 - y3*x4)) / denom;
                    py = ((x1*y2 - y1*x2)*(y3 - y4) - (y1 - y2)*(x3*y4 - y3*x4)) / denom;
                }
                output.add(new Vector3(px, py, 0));
            }
            output.add(E);
        } else if (Sin) {
            // 內->外：加交點
            float x1 = S.x, y1 = S.y, x2 = E.x, y2 = E.y;
            float x3 = A.x, y3 = A.y, x4 = B.x, y4 = B.y;
            float denom = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);
            float px, py;
            if (abs(denom) < 1e-12f) { px = E.x; py = E.y; }
            else {
                px = ((x1*y2 - y1*x2)*(x3 - x4) - (x1 - x2)*(x3*y4 - y3*x4)) / denom;
                py = ((x1*y2 - y1*x2)*(y3 - y4) - (y1 - y2)*(x3*y4 - y3*x4)) / denom;
            }
            output.add(new Vector3(px, py, 0));
        }
        S = E;
    }
  
    // 下一條邊繼續裁
    input = new ArrayList<Vector3>(output);
    output = new ArrayList<Vector3>();
  }

    output = input;

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;
}
