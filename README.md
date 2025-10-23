# ComputerGraphics_HW2
[DEMO video](https://youtu.be/celnMxz5WsU?si=sKtF7U5_TkjVE6w8)

## makeTrans(t) 平移

把點 `(x,y,z)` 平移 `(tx,ty,tz)` -> `(x+tx, y+ty, z+tz)`

矩陣
```
[1 0 0 tx]
[0 1 0 ty]
[0 0 1 tz]
[0 0 0 1]
```
實作：`makeIdentuty()` 後，填`m[3]=tx, m[7]=ty, m[11]=tz`

## makeRotZ(a) 繞Z旋轉

Z軸垂直螢幕，旋轉角 a

2D旋轉套在 (x,y)

```
x' = cos a * x - sin a * y
y' = sin a * x + cos a * y
z' = z
```

矩陣
```
[c -s 0 0]
[s c 0 0]
[0 0 1 0]
[0 0 0 1]
```
實作：`m[0]=c, m[1]=-s, m[4]=s, m[5]=c, m[10]=1`

## makeRotX(a) / makeRotY(a)

把標準旋轉矩陣填到對角的 3 x 3

- RotX：
```
[1 0 0 0]
[0 c -s 0]
[0 s c 0]
[0 0 0 1]
```

-RotY：
```
[c 0 s 0]
[0 1 0 0]
[-s 0 c 0]
[0 0 0 1]
```

## makeScale(s)

把 (x,y,z) 各自放大 / 縮小：
```
[sx 0 0 0]
[0 sy 0 0]
[0 0 sz 0]
[0 0 0 1]
```

實作：改對角 `m[0]=sx, m[5]=sy, m[10]=sz`

## findBoundBox()

掃一遍所有頂點，紀錄最小的 x/y、最大的 x/y。就得到一個軸對齊的 bounding box，接下來座像素填塞 (pnpoly)時，就只掃這個小矩形，不掃整個畫布

演算法：

1. 用第一個點初始化 `minX, minY, maxX, maxY`

2. 之後每個點都做
    - `minX = min(minX, x)`, `minY = min(minY, y)`
    - 'maxX = max(maxX, x)', `maxY = max(maxY, y)`

3. 回傳 `(minX, minY)` 和 `(maxX, maxY)` 兩個角點

## pnpoly(x,y,vertexes)

從測試點 `(x,y)` 向右射一條水平光線，統計它與多邊形邊的交點 「次數是否為奇數」。 奇數 = 在內部， 偶數 = 在外部。

### 公式

對每條邊 `(xi, yi)-(xj,yj)`：

- 掃描線是否跨越這條邊：`(yi > y) != (yj > y)`
- 若跨越，計算交點的 x ：
  ```
  x_intersect = (xj - xi) * (y - yi) / (yj - yi) + xi
  ```
- 若 `x < x_intersect` ，表示交點在測試點右方 -> 焦點次數翻轉一次 (inside = !inside)

## Sutherland_Hodgman_algorithm(points, boundary)

把「任意多邊形」用「半平面裁切」的方式，對邊界矩形的每一條邊裁一。每裁一次，輸入多邊形會變成被這條邊裁過的輸出; 然後繼續用輸出當下一輪輸入，直到四條邊都裁完。

- 給定邊界邊 AB、測試點 P，算 `vross (B-A, P-A)`：
  - 若邊界點序是 CCW (逆時針)，左側 (cross >=0) 是內側
  - 逤是 CW (順時針)，就要取 `cross <= 0` 裁是內側
 
有四種情況(S = 前一點，E = 當前點)：
1. S 在外、 E 在外：輸出甚麼都不加
2. S 在內、 E 在內：輸出 E
3. S 在外、 E 在內：輸出焦點、再輸出 E
4. S 在內、 E 在外：輸出交點(不輸出 E)

程式步驟：

1. 先把 `points` 複製到 `input`

2. 迴圈每一條邊界邊：
    - 清空 `output`，遍歷`input`的邊(S -> E)依上面四種情形輸出點
    - 把 `output`複製回`input`， 進入下一條邊
3. 全部邊裁完後的`input`就是裁切結果
