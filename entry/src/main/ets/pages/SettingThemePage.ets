import { DEFAULT_THEMES, HexColor, Theme, ThemeManager, THEME_KEY } from '@fx/theme'
import { ThemeUtils } from '../utils/ThemeUtils'
import { FXNavBar, NAV_BAR_HEIGHT } from '../view/FXNavBar'
import { ThemePreviewView } from '../view/ThemePreviewView'

@Entry
@Component
struct SettingThemePage {
  /// ******************** Variable ********************

  @State themes: Theme[] = []
  @State itemWidth: number = 0
  @State gridHeight: number = 0
  @StorageProp(THEME_KEY) curTheme: Theme = ThemeManager.theme
  @State isPreviewing: boolean = false

  /// ******************** LifeCycle ********************

  aboutToAppear() {
    DEFAULT_THEMES.forEach((theme) => {
      ThemeUtils.setLightExtras(theme)
      ThemeUtils.setDarkExtras(theme)
    })
    this.themes = DEFAULT_THEMES
  }

  /// ******************** Method ********************

  getBackgroundColor(theme: Theme, isLight: boolean): number {
    return isLight ? theme.light.primary.value : theme.dark.primary.value
  }

  /// ******************** Builder ********************

  @Builder
  ModalBuilder() {
    ThemePreviewView({ theme: this.curTheme, isPreviewing: $isPreviewing })
      .width('100%')
      .height('100%')
  }

  @Builder
  GridBuild() {
    Grid() {
      ForEach(this.themes, (item: Theme) => {
        GridItem() {
          Stack({ alignContent: Alignment.BottomEnd }) {
            Polygon({ width: this.itemWidth, height: this.itemWidth })
              .points([[0, 0], [0, this.itemWidth], [this.itemWidth, 0]])
              .fill(this.getBackgroundColor(item, true))

            Polygon({ width: this.itemWidth, height: this.itemWidth })
              .points([[this.itemWidth, this.itemWidth], [0, this.itemWidth], [this.itemWidth, 0]])
              .fill(this.getBackgroundColor(item, false))

            Text('√')
              .fontColor(item.id === this.curTheme.id ? this.curTheme.onPrimary : this.curTheme.divider)
              .textAlign(TextAlign.Center)
              .width(20)
          }
        }
        .width('100%')
        .aspectRatio(1)
        .onClick(() => {
          this.curTheme = item
          this.curTheme.mode = ThemeManager.theme.mode
        })
      }, (item: Theme) => item.id.toString())

      GridItem() {
        Text('+')
          .fontColor(this.curTheme.onBackground)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .backgroundColor(this.curTheme.background)
          .border({ width: 1, color: this.curTheme.divider })
          .size({ width: '100%', height: '100%' })
      }
      .aspectRatio(1)
      .onClick(() => {
        let seedColor = new HexColor(Math.random() * 0xFFFFFFFF)
        let newTheme = Theme.fromSeedColor(seedColor)
        ThemeUtils.setLightExtras(newTheme)
        ThemeUtils.setDarkExtras(newTheme)
        this.themes = this.themes.concat(newTheme)
      })
    }
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
    .width('100%')
    .height(this.gridHeight)
  }

  @Builder
  BottomBuild() {
    Row({ space: 0.5 }) {
      Button('预览')
        .type(ButtonType.Normal)
        .size({ width: '50%', height: 50 })
        .bindContentCover($$this.isPreviewing, this.ModalBuilder)
        .backgroundColor(this.curTheme.primary)
        .fontColor(this.curTheme.onPrimary)
        .onClick(() => {
          this.isPreviewing = true
        })
      Button('确定')
        .type(ButtonType.Normal)
        .size({ width: '50%', height: 50 })
        .backgroundColor(this.curTheme.primary)
        .fontColor(this.curTheme.onPrimary)
        .onClick(() => {
          ThemeManager.setTheme(this.curTheme, getContext())
        })
    }
    .width('100%')
  }

  /// ******************** UI ********************

  build() {
    Column() {
      FXNavBar({ title: '主题色' })
      this.GridBuild()
      this.BottomBuild()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.curTheme.background)
    .onAreaChange((_, newArea) => {
      this.itemWidth = (Number(newArea.width) - 20) / 3.0
      this.gridHeight = (Number(newArea.height) - NAV_BAR_HEIGHT - 50)
    })
  }
}