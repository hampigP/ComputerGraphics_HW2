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

掃一遍所有頂點，紀錄最小的 x/y、最大的 x/y。就得到一個軸對齊的 bounding box，接下來座像素填塞 (pnpoly)時，就只掃這個小矩形，
