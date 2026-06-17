# 设计令牌

## 六大核心维度（横向覆盖）

| 维度                         | 包含内容                                                               | 典型样例值                                |
| -------------------------- | ------------------------------------------------------------------ | ------------------------------------ |
| 色彩体系 (Color)               | 品牌色、中性色、功能色（成功/警告/错误）、透明度/不透明度                                     | `#0066FF`, `rgba(0,0,0,0.6)`         |
| 排版体系 (Typography)          | 字阶（Size）、字重（Weight）、行高（Height）、字距（Letter-spacing）、字体族（Font Family） | `16px`, `600`, `1.5`                 |
| 空间与尺寸 (Spacing & Sizing)   | 间距（内边距/外边距）、组件宽高、图标尺寸                                              | `4px`, `8px`, `16px`（通常基于 4 或 8 的倍数） |
| 圆角与边框 (Border & Corner)    | 圆角半径（Corner）、边框宽度（Width）、边框样式（Style）                               | `8px`, `2px`, `solid`                |
| 阴影与景深 (Shadow & Elevation) | 投影（X/Y偏移、模糊、扩散）、内阴影；对应 Material Design 中的海拔层级（Elevation）           | `0px 4px 12px rgba(0,0,0,0.1)`       |
| 动效与缓动 (Motion)             | 过渡持续时间（Duration）、缓动函数（Easing）、延迟（Delay）                            | `200ms`, `ease-in-out`               |

## 三阶架构（纵贯所有维度）

任何一个维度的值，都必须经历这三层抽象，才配叫"设计令牌"：

### 1. 原始令牌（Primitive Token）

纯粹的物理值，无意义，只作为"原料"存储。

```
blue-60: #0066FF
scale-400: 16px
```

### 2. 语义令牌（Semantic Token）

赋予设计意图，应对主题换肤（如浅色/深色模式）。

```
text-primary: {blue-60}    // 主文本色
bg-default: {gray-10}      // 默认背景
```

### 3. 组件令牌（Component Token）

绑定具体 UI 部件，杜绝硬编码。

```
button-primary-bg: {text-primary}
card-padding: {scale-400}
```

