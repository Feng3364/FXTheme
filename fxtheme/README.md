## FXTheme

#### 功能介绍

- 支持NEXT版本
- 提供多套预设主题方案
- 支持暗黑模式及外观模式切换的监听
- 支持动态切换主题方案
- 支持自定义主题方案，且能扩展主题模版

#### 下载安装

```
ohpm install @fx/theme
```

#### 使用介绍

1. 初始化（必选）

```
import { ThemeManager } from '@fx/theme'

export default class YourAbility extends UIAbility {
  onCreate() {
    ThemeManager.init(this.context)
  }
}
```

2. 扩展主题模板（可选）

预设了五个色值—— primary（主题色）onPrimary（主题色上的文本色）background（背景色）onBackground（背景色上的文本色）divider（分割线颜色）

```
// 下列代码为【明亮模式】扩展了多个色值以供页面使用
ThemeManager.theme.light.extras.set(ColorKeys.DISABLED, new HexColor(theme.primary).withOpacity(0.2))
ThemeManager.theme.light.extras.set(ColorKeys.VIEW, new HexColor(0xFFFFFFFF))

ThemeManager.theme.light.extras.set(ColorKeys.TEXT_PRIMARY, new HexColor(0xFF2A2929))
ThemeManager.theme.light.extras.set(ColorKeys.TEXT_SECONDARY, new HexColor(0xFF818181))
ThemeManager.theme.light.extras.set(ColorKeys.TEXT_PLACEHOLDER, new HexColor(0xFFC2C1C1))

ThemeManager.theme.light.extras.set(ColorKeys.SUCCESS, new HexColor(0xFF27BA9B))
ThemeManager.theme.light.extras.set(ColorKeys.DANGER, new HexColor(0xFFFF4C4C))
ThemeManager.theme.light.extras.set(ColorKeys.WARNING, new HexColor(0xFFFFAB2E))
```

3. 自定义主题方案（可选）

```
// 使用ARGB主题方案
let newTheme1 = Theme.fromSeedColor(new HexColor(0xFFEE4000))
newTheme1.mode = ThemeManager.theme.mode
ThemeManager.setTheme(newTheme1, this.context)

// 使用全套自定义方案
let newTheme2 = new Theme({
  id: 123,
  mode: ThemeMode.auto,
  light: {
    primary: new HexColor(0xFFEE4000),
    onPrimary: new HexColor(0xFFEE4000),
    background: new HexColor(0xFFEE4000),
    onBackground: new HexColor(0xFFEE4000),
    divider: new HexColor(0xFFEE4000),
    extras: new Map() // 这里也可以扩展主题模版
  } as ColorSchemeType,
  dark: {
    primary: new HexColor(0xFFEE4000),
    onPrimary: new HexColor(0xFFEE4000),
    background: new HexColor(0xFFEE4000),
    onBackground: new HexColor(0xFFEE4000),
    divider: new HexColor(0xFFEE4000),
    extras: new Map() // 这里也可以扩展主题模版
  } as ColorSchemeType,
} as ThemeType)
newTheme2.mode = ThemeManager.theme.mode
ThemeManager.setTheme(newTheme2, this.context)
```

4. 使用主题色

- 页面中使用——建议在需要动态切换**外观模式**、**主题方案**的页面使用`@StorageProp (THEME_KEY) theme: Theme = ThemeManager.theme`——以此来监听变化做出相应的动态变更

```
import { Theme, ThemeManager, THEME_KEY } from '@fx/theme'
import { ColorKeys } from '@fx/base' // 业务头文件，主要是定义了一个常量字符串来标识扩展色值

@Entry
@Component
struct YourPage {
  @StorageProp (THEME_KEY) theme: Theme = ThemeManager.theme

  build() {
    Column() {
      Text('文本')
        .fontColor(this.theme.extra(ColorKeys.TEXT_PRIMARY)) //使用扩展文本色
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background) //使用主题背景色
  }
}
```

- 弹窗或View中使用——建议在公共View中使用Page方案，在弹窗等生命周期短的组件中使用`ThemeManager.theme`——减少监听带来的性能损耗

```
import { Theme, ThemeManager, THEME_KEY } from '@fx/theme/Index'

@CustomDialog
struct YourDialog {

  build() {
    Button('按钮')
      .width('90%')
      .height(50)
      .backgroundColor(ThemeManager.theme.primary)
      .fontColor(ThemeManager.theme.onPrimary)
  }
}

export { YourDialog }
```

5. 切换主题方案

```
// ability中传入this.context；component中传入getContext()
ThemeManager.setTheme(theme, this.context)
```

5. 切换外观模式

```
// ability中传入this.context；component中传入getContext()
ThemeManager.setThemeMode(ThemeMode.dark, this.context)
```

部分逻辑参考于[@goweii/theme](https://ohpm.openharmony.cn/#/cn/detail/@goweii%2Ftheme)，在此表示感谢