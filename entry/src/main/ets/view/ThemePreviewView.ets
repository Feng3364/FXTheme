import { Theme, HexColor, ThemeMode } from '@fx/theme'

interface NamedColor {
  name: string
  color: HexColor
}

@Component
export struct ThemePreviewView {
  @Prop theme: Theme
  @Link isPreviewing: boolean
  @State themeModes: Array<ThemeMode> = [ThemeMode.auto, ThemeMode.light, ThemeMode.dark]
  @State colors: Array<NamedColor> = []

  aboutToAppear() {
    this.colors = this.allColors()
  }

  themeModeName(themeMode: ThemeMode): string {
    switch (themeMode) {
      case ThemeMode.auto:
        return '跟随系统'
      case ThemeMode.light:
        return '亮色'
      case ThemeMode.dark:
        return '暗色'
    }
  }

  @Builder
  ModeBuilder() {
    Row() {
      Row() {
        ForEach(this.themeModes, (item: ThemeMode) => {
          Button(this.themeModeName(item))
            .padding(10)
            .borderRadius(99)
            .backgroundColor(this.theme!.mode == item
              ? this.theme!.primary
              : '#00FFFFFF')
            .fontColor(this.theme!.mode == item
              ? this.theme!.onPrimary
              : this.theme!.onBackground)
            .onClick(async () => {
              if (this.theme!.mode != item) {
                this.theme.mode = item
                this.colors = this.allColors()
              }
            })
        })
      }
      .borderRadius(99)
      .borderWidth(3)
      .borderStyle(BorderStyle.Solid)
      .borderColor(this.theme!.primary)

      Text('X')
        .width(40)
        .aspectRatio(1)
        .fontColor(this.theme.onBackground)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.isPreviewing = false
        })
    }
    .padding({ left: 16, right: 16, top: 44, bottom: 16 })
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
  }

  @Builder
  ListBuilder() {
    List({ space: 16 }) {
      ForEach(this.colors, (item: NamedColor) => {
        ListItem() {
          ColorCard({ theme: $theme, namedColor: item })
        }
      }, (item: NamedColor) => {
        return `${item.name}:${formatToARGB(item.color)}`
      })
    }
    .layoutWeight(1)
    .padding(16)
  }

  build() {
    Column() {
      this.ModeBuilder()
      this.ListBuilder()
    }
    .height('100%')
    .backgroundColor(this.theme.background)
  }

  private allColors(): Array<NamedColor> {
    let colorScheme = this.theme.current
    let list = Object.entries(colorScheme).map((value: [string, HexColor]) => {
      return {
        name: value[0],
        color: new HexColor(value[1].value)
      } as NamedColor
    })
    list.pop()
    for (let map of colorScheme.extras.entries()) {
      list.push({
        name: map[0],
        color: map[1]
      })
    }
    return list
  }
}

@Component
struct ColorCard {
  @Link theme: Theme
  readonly namedColor?: NamedColor
  textColor?: HexColor

  aboutToAppear() {
    let background = this.theme!.current.background
    let blend = this.namedColor!.color.blend(background)

    this.textColor = blend.luminance > 0.5
      ? this.namedColor!.color.toHSL()
      .copyWith({ l: 0 })
      .toRGB()
      .withOpacity(0.6)
      : this.namedColor!.color.toHSL()
      .copyWith({ l: 1 })
      .toRGB()
      .withOpacity(0.6)
  }

  build() {
    Row() {
      Text(this.namedColor!.name)
        .align(Alignment.Start)
        .fontColor(this.textColor!.value)
      Column() {
        Text(formatToARGB(this.namedColor!.color))
          .fontColor(this.textColor!.value)
      }
      .align(Alignment.BottomStart)
    }
    .alignSelf(ItemAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(this.namedColor!.color.value)
    .borderRadius(12)
    .borderWidth(1)
    .borderColor(this.theme!.divider)
    .padding(16)
    .width('100%')
  }
}

function formatToARGB(hex: HexColor): string {
  let ff = (v: number) => {
    let s = v.toString(16).toUpperCase()
    if (s.length == 1) {
      return `0${s}`
    } else {
      return s
    }
  }
  return `0x${ff(hex.alpha)}${ff(hex.red)}${ff(hex.green)}${ff(hex.blue)}`
}