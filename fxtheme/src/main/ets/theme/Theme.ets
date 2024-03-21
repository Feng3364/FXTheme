import { HexColor, ColorPattern, ColorSchemeType } from '../color'

export enum ThemeMode {
  auto,
  light,
  dark
}

export interface ThemeType {
  id: number
  mode: ThemeMode
  seedColor?: HexColor
  light: ColorSchemeType
  dark: ColorSchemeType
}

export class Theme implements ThemeType {
  readonly id: number //默认用种子色做id
  mode: ThemeMode = ThemeMode.auto
  readonly seedColor?: HexColor
  readonly light: ColorSchemeType
  readonly dark: ColorSchemeType

  /// ******************** Constructor ********************

  constructor(type: ThemeType) {
    this.id = type.id
    this.mode = type.mode
    this.seedColor = type.seedColor
    this.light = type.light
    this.dark = type.dark
  }

  static fromSeedColor(value: HexColor): Theme {
    let lightDarkPattern = ColorPattern.seed2Type(value)
    return new Theme({
      id: value.value,
      mode: ThemeMode.auto,
      seedColor: value,
      light: lightDarkPattern.light.scheme,
      dark: lightDarkPattern.dark.scheme
    } as ThemeType)
  }

  static copyWith(value: Theme): Theme {
    return new Theme({
      id: value.id,
      mode: value.mode,
      seedColor: value.seedColor,
      light: value.light,
      dark: value.dark
    } as ThemeType)
  }

  /// ******************** JSON ********************

  static fromJSON(json: string): Theme {
    let list = json.split('-')

    let hex = (str: string) => {
      return HexColor.fromStoreARGB(str)
    }
    let scheme = (str: string) => {
      return {
        primary: hex(str.split('~')[0]),
        onPrimary: hex(str.split('~')[1]),
        background: hex(str.split('~')[2]),
        onBackground: hex(str.split('~')[3]),
        divider: hex(str.split('~')[4]),
        extras: new Map()
      } as ColorSchemeType
    }
    return new Theme({
      id: Number(list[0]),
      mode: Theme.setModeBy(Number(list[1])),
      light: scheme(list[2]),
      dark: scheme(list[3]),
    } as ThemeType)
  }

  toJSON() {
    let schemeJSON = (scheme: ColorSchemeType) => {
      return [
        scheme.primary.formatToStoreARGB(),
        scheme.onPrimary.formatToStoreARGB(),
        scheme.background.formatToStoreARGB(),
        scheme.onBackground.formatToStoreARGB(),
        scheme.divider.formatToStoreARGB()
      ].join('~')
    }
    return [
      this.id.toString(),
      this.mode.valueOf().toString(),
      schemeJSON(this.light),
      schemeJSON(this.dark)
    ].join('-')
  }

  static setModeBy(number: number): ThemeMode {
    if (number === 0) {
      return ThemeMode.auto
    } else if (number === 1) {
      return ThemeMode.light
    } else {
      return ThemeMode.dark
    }
  }

  /// ******************** Getter ********************

  get current(): ColorSchemeType {
    switch (this.mode) {
      case ThemeMode.auto:
      case ThemeMode.light:
        return this.light
      case ThemeMode.dark:
        return this.dark
    }
  }

  get primary(): number {
    return this.current.primary.value
  }

  get onPrimary(): number {
    return this.current.onPrimary.value
  }

  get background(): number {
    return this.current.background.value
  }

  get onBackground(): number {
    return this.current.onBackground.value
  }

  get divider(): number {
    return this.current.divider.value
  }

  extra(key: string): number | undefined {
    return this.current.extras.get(key)?.value
  }
}

// 具体色值请看color.json
export const PRIMARY_RED = Theme.fromSeedColor(new HexColor(0xFFEE4000))

export const PRIMARY_ORANGE = Theme.fromSeedColor(new HexColor(0xFFFF8C00))

export const PRIMARY_YELLOW = Theme.fromSeedColor(new HexColor(0xFFFFFF00))

export const PRIMARY_GREEN = Theme.fromSeedColor(new HexColor(0xFF32CD32))

export const PRIMARY_BLUE = Theme.fromSeedColor(new HexColor(0xFF4876FF))

export const PRIMARY_PINK = Theme.fromSeedColor(new HexColor(0xFFFF69B4))

export const PRIMARY_WHITE = Theme.fromSeedColor(new HexColor(0xFFFFFAFA))

export const PRIMARY_BLACK = Theme.fromSeedColor(new HexColor(0xFF1F1F1F))

export const PRIMARY_GOLDEN = Theme.fromSeedColor(new HexColor(0xFFFFD700))

export const DEFAULT_THEME = PRIMARY_WHITE

export const DEFAULT_THEMES = [PRIMARY_RED, PRIMARY_ORANGE, PRIMARY_YELLOW, PRIMARY_GREEN, PRIMARY_BLUE, PRIMARY_PINK, PRIMARY_WHITE, PRIMARY_BLACK, PRIMARY_GOLDEN]