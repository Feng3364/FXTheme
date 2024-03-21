import { Theme, ThemeManager, THEME_KEY } from '@fx/theme'
import router from '@ohos.router'

export const NAV_BAR_HEIGHT: number = 44

@Preview
@Component
struct FXNavBar {
  title: string = ''
  showBack: boolean = true
  onBackClick?: () => void
  @StorageProp(THEME_KEY) theme: Theme = ThemeManager.theme

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontColor(this.theme.onBackground)
          .fontWeight(600)
      }
      .width('100%')
      .height('100%')
      .padding({ left: NAV_BAR_HEIGHT, right: NAV_BAR_HEIGHT })
      .justifyContent(FlexAlign.Center)

      if (this.showBack) {
        Text('<-')
          .textAlign(TextAlign.Center)
          .fontColor(this.theme.onBackground)
          .width(NAV_BAR_HEIGHT)
          .aspectRatio(1)
          .onClick(() => {
            if (this.onBackClick) {
              this.onBackClick()
            } else {
              router.back()
            }
          })
      }
    }
    .width('100%')
    .height(NAV_BAR_HEIGHT)
    .backgroundColor(this.theme.background)
  }
}

export { FXNavBar }