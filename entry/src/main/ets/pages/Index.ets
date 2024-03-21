import { Theme, ThemeManager, THEME_KEY } from '@fx/theme'
import { ColorKeys } from '../constants/ColorKeys'
import router from '@ohos.router'
import { RouterURL } from '../constants/RouterURL'

@Entry
@Component
struct Index {
  @StorageProp (THEME_KEY) theme: Theme = ThemeManager.theme

  build() {
    Column() {
      Text('进入外观设置')
        .fontColor(this.theme.extra(ColorKeys.TEXT_PRIMARY))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.theme.background)
    .onClick(() => router.pushUrl({ url: RouterURL.SETTING }))
  }
}