## 🧱 一、NumPy 基础结构：ndarray 对象

### 1. `ndarray` 是什么？

NumPy 的核心是 `ndarray`（n-dimensional array）对象，一个多维数组，功能强大、运算高效。

```
python复制编辑import numpy as np
a = np.array([1, 2, 3])  # 一维数组
b = np.array([[1, 2], [3, 4]])  # 二维数组
```

------

## 📏 二、数组属性

| 属性       | 含义                   | 示例         |
| ---------- | ---------------------- | ------------ |
| `ndim`     | 数组的维数             | `a.ndim`     |
| `shape`    | 数组的形状（各维长度） | `a.shape`    |
| `size`     | 元素个数               | `a.size`     |
| `dtype`    | 元素类型               | `a.dtype`    |
| `itemsize` | 单个元素占字节数       | `a.itemsize` |



------

## 🧰 三、创建数组的方式

```
python复制编辑np.zeros((2, 3))        # 全零数组
np.ones((2, 3))         # 全一数组
np.eye(3)               # 单位矩阵
np.arange(0, 10, 2)     # 类似 range
np.linspace(0, 1, 5)    # 线性等间隔数组
np.random.rand(2, 3)    # [0,1)之间的随机数
np.random.randint(0, 10, size=(2, 3))  # 整数随机数
```

------

## 🔁 四、数组操作

### 1. 形状变换

```
python复制编辑a.reshape((3, 2))
a.ravel()      # 展平为一维
a.T            # 转置
a.flatten()    # 返回拷贝的一维数组
```

### 2. 拼接与拆分

```

np.concatenate([a, b], axis=0) #纵向拼接
np.vstack([a, b])   # 垂直堆叠
np.hstack([a, b])   # 水平堆叠

np.split(a, 2, axis=0)  # 拆分
```

------

## 🧮 五、数学运算与广播机制

```
python复制编辑a + b
a - b
a * b
a / b
a ** 2

np.sin(a)
np.mean(a)
np.sum(a, axis=0)
np.max(a)
np.argmin(a)
```

### ✅ 广播机制：不同形状自动匹配计算（重要）

```
a = np.array([[1, 2, 3],
              [4, 5, 6]])      # shape = (2, 3)

b = np.array([10, 20, 30])     # shape = (3,)
result = a + b
[[11 22 33]
 [14 25 36]]
```

------

## 🔍 六、数组索引与切片

```
python复制编辑a[0, 1]      # 单个元素
a[1, :]      # 第2行
a[:, 1]      # 第2列
a[::2]       # 步长访问
a[a > 3]     # 布尔索引
```

------

## 🛠️ 七、常用函数

| 类型   | 示例                                |
| ------ | ----------------------------------- |
| 排序   | `np.sort()`, `np.argsort()`         |
| 聚合   | `np.sum()`, `np.mean()`, `np.std()` |
| 比较   | `np.where(a > 5, 1, 0)`             |
| 唯一值 | `np.unique()`                       |
| 点积   | `np.dot(a, b)`                      |

### 八、图像操作-常用函数

图像在 NumPy 中通常表示为一个 `ndarray`：

- **灰度图**：二维数组（H, W）
- **彩色图**：三维数组（H, W, 3），最后一维是 **BGR（OpenCV）** 或 **RGB（PIL）**

```
h, w = img.shape[:2]
```

## 使用布尔掩码筛选图像像素

### 示例：提取图中所有绿色强度大于150的区域

```
python复制编辑green_mask = img[:, :, 1] > 150
img[green_mask] = [0, 255, 0]  # 将这些像素高亮为绿色
```

------

## 条件修改 + 图像掩码处理（高级操作）

### 示例：将亮度值小于100的像素变暗

```
python复制编辑gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
dark_mask = gray < 100
img[dark_mask] = [0, 0, 0]  # 设置为黑色
```

------

##  图像拼接与合成

```
python复制编辑top = img[:100, :, :]
bottom = img[-100:, :, :]
combined = np.vstack([top, bottom])  # 垂直拼接
```

## NumPy 图像切片关键词

| 操作     | 代码关键点                                       |
| -------- | ------------------------------------------------ |
| 访问通道 | `img[:, :, 0]` （蓝）                            |
| 区域切片 | `img[y1:y2, x1:x2]`                              |
| 修改颜色 | `img[...] = [B, G, R]`                           |
| 掩码操作 | `mask = condition` 然后 `img[mask] = color`      |
| 拼接     | `np.vstack()`, `np.hstack()`, `np.concatenate()` |

