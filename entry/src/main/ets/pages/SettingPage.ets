import { Theme, ThemeManager, ThemeMode, THEME_KEY } from '@fx/theme'
import { ColorKeys } from '../constants/ColorKeys'
import router from '@ohos.router'
import { RouterURL } from '../constants/RouterURL'
import { FXNavBar } from '../view/FXNavBar'

@Entry
@Component
struct SettingPage {
  @StorageProp(THEME_KEY) theme: Theme = ThemeManager.theme

  build() {
    Column() {
      FXNavBar({ title: '外观设置' })

      Row() {
        Text('跟随系统外观')
          .fontColor(this.theme.extra(ColorKeys.TEXT_PRIMARY))

        Toggle({ type: ToggleType.Switch, isOn: this.theme.mode === ThemeMode.auto })
          .selectedColor(this.theme.primary)
          .switchPointColor(this.theme.onPrimary)
          .onChange(isOn => {
            ThemeManager.setThemeMode(isOn ? ThemeMode.auto : ThemeMode.light, getContext())
          })
      }
      .width('100%')
      .backgroundColor(this.theme.extra(ColorKeys.VIEW))
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.theme.mode !== ThemeMode.auto) {
        Row() {
          Text('暗黑模式')
            .fontColor(this.theme.extra(ColorKeys.TEXT_PRIMARY))

          Toggle({ type: ToggleType.Switch, isOn: this.theme.mode === ThemeMode.dark })
            .selectedColor(this.theme.primary)
            .switchPointColor(this.theme.onPrimary)
            .onChange(isOn => {
              ThemeManager.setThemeMode(isOn ? ThemeMode.dark : ThemeMode.light, getContext())
            })
        }
        .width('100%')
        .backgroundColor(this.theme.extra(ColorKeys.VIEW))
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .justifyContent(FlexAlign.SpaceBetween)
      }

      Row() {
        Text('主题色')
          .fontColor(this.theme.extra(ColorKeys.TEXT_PRIMARY))

        Text('->')
          .fontColor(this.theme.extra(ColorKeys.TEXT_PRIMARY))
      }
      .width('100%')
      .backgroundColor(this.theme.extra(ColorKeys.VIEW))
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => router.pushUrl({ url: RouterURL.SETTING_THEME }))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }
}