import ClampUtil from '../utils/ClampUtil'
import { HexColor, HSLColor, ColorSchemeType } from './'

interface LightDarkPattern {
  light: LightColorPattern
  dark: DarkColorPattern
}

/// 颜色样式类（根据颜色生成主题方案）
export abstract class ColorPattern {
  protected readonly seedColor: HexColor

  protected constructor(seedColor: HexColor) {
    this.seedColor = seedColor
  }

  static seed2Type(seekColor: HexColor): LightDarkPattern {
    return {
      light: new LightColorPattern(seekColor),
      dark: new DarkColorPattern(seekColor),
    }
  }

  abstract get scheme(): ColorSchemeType
}

export class LightColorPattern extends ColorPattern {
  private readonly hslSeedColor: HSLColor
  private readonly luminance: number

  constructor(seedColor: HexColor) {
    super(seedColor)
    this.hslSeedColor = seedColor.toHSL()
    this.luminance = seedColor.luminance
  }

  /// ******************** Getter ********************

  get scheme(): ColorSchemeType {
    return {
      primary: this.primary,
      onPrimary: this.onPrimary,
      background: this.background,
      onBackground: this.onBackground,
      divider: this.divider,
      extras: new Map()
    }
  }

  private get primary(): HexColor {
    return this.seedColor
  }

  private get onPrimary(): HexColor {
    if (this.luminance > 0.5) {
      return this.hslSeedColor.copyWith({
        s: 0.1, l: 0
      }).toRGB()
    } else {
      return this.hslSeedColor.copyWith({
        s: 0.1, l: 1
      }).toRGB()
    }
  }

  private get background(): HexColor {
    return this.hslSeedColor.copyWith({
      s: 0.1, l: 0.95
    }).toRGB()
  }

  private get onBackground(): HexColor {
    return this.hslSeedColor.copyWith({
      s: 0.1, l: 0.05
    }).toRGB()
  }

  private get divider(): HexColor {
    return this.onBackground.withOpacity(0.2)
  }
}

export class DarkColorPattern extends ColorPattern {
  private readonly hslSeedColor: HSLColor
  private readonly luminance: number

  constructor(seedColor: HexColor) {
    let hslSeedColor = seedColor.toHSL()
    hslSeedColor = hslSeedColor.copyWith({
      s: ClampUtil.clamp(hslSeedColor.saturation - 0.2, {
        min: 0.1, max: 0.9
      })
    })
    seedColor = hslSeedColor.toRGB()
    super(seedColor)
    this.hslSeedColor = hslSeedColor
    this.luminance = seedColor.luminance
  }

  /// ******************** Getter ********************

  get scheme(): ColorSchemeType {
    return {
      primary: this.primary,
      onPrimary: this.onPrimary,
      background: this.background,
      onBackground: this.onBackground,
      divider: this.divider,
      extras: new Map()
    }
  }

  private get primary(): HexColor {
    return this.seedColor
  }

  private get onPrimary(): HexColor {
    if (this.luminance > 0.5) {
      return this.hslSeedColor.copyWith({
        s: 0.1, l: 0
      }).toRGB().withOpacity(0.9)
    } else {
      return this.hslSeedColor.copyWith({
        s: 0.1, l: 1
      }).toRGB().withOpacity(0.7)
    }
  }

  private get background(): HexColor {
    return this.hslSeedColor.copyWith({
      s: 0.1, l: 0.05
    }).toRGB()
  }

  private get onBackground(): HexColor {
    return this.hslSeedColor.copyWith({
      s: 0.1, l: 0.95
    }).toRGB().withOpacity(0.9)
  }

  private get divider(): HexColor {
    return this.onBackground.withOpacity(0.2)
  }
}