import { ColorSchemeType, HexColor, Theme, ThemeManager, ThemeMode, ThemeType } from '@fx/theme'
import { UIAbility } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { ThemeUtils } from '../utils/ThemeUtils'

export default class EntryAbility extends UIAbility {
  onCreate(): void {
    this.configTheme()
  }

  configTheme() {
    // 初始化（加载上次的主题）
    ThemeManager.init(this.context)

    // // 自定义主题一
    // let newTheme1 = Theme.fromSeedColor(new HexColor(0xFFEE4000))
    // newTheme1.mode = ThemeManager.theme.mode
    // ThemeManager.setTheme(newTheme1, this.context)
    // // 自定义主题二
    // let newTheme2 = new Theme({
    //   id: 123,
    //   mode: ThemeMode.auto,
    //   light: {
    //     primary: new HexColor(0xFFEE4000),
    //     onPrimary: new HexColor(0xFFEE4000),
    //     background: new HexColor(0xFFEE4000),
    //     onBackground: new HexColor(0xFFEE4000),
    //     divider: new HexColor(0xFFEE4000),
    //     extras: new Map() // 这里也可以扩展主题模版
    //   } as ColorSchemeType,
    //   dark: {
    //     primary: new HexColor(0xFFEE4000),
    //     onPrimary: new HexColor(0xFFEE4000),
    //     background: new HexColor(0xFFEE4000),
    //     onBackground: new HexColor(0xFFEE4000),
    //     divider: new HexColor(0xFFEE4000),
    //     extras: new Map() // 这里也可以扩展主题模版
    //   } as ColorSchemeType,
    // } as ThemeType)
    // newTheme2.mode = ThemeManager.theme.mode
    // ThemeManager.setTheme(newTheme2, this.context)
    //
    // 拓展模板色
    ThemeUtils.setLightExtras(ThemeManager.theme)
    ThemeUtils.setDarkExtras(ThemeManager.theme)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index')
  }
}
