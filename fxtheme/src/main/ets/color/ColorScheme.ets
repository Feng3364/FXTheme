import { HexColor } from './'

export interface ColorSchemeType {
  primary: HexColor,
  onPrimary: HexColor,
  background: HexColor,
  onBackground: HexColor,
  divider: HexColor,
  extras: Map<string, HexColor>
}

export class ColorScheme implements ColorSchemeType {

  readonly primary: HexColor
  readonly onPrimary: HexColor
  readonly background: HexColor
  readonly onBackground: HexColor
  readonly divider: HexColor
  readonly extras: Map<string, HexColor>

  constructor(value: ColorSchemeType) {
    this.primary = value.primary
    this.onPrimary = value.onPrimary
    this.background = value.background
    this.onBackground = value.onBackground
    this.divider = value.divider
    this.extras = value.extras
  }

  copyWith(value: ColorSchemeType): ColorScheme {
    return new ColorScheme({
      primary: value.primary ?? this.primary,
      onPrimary: value.onPrimary ?? this.onPrimary,
      background: value.background ?? this.background,
      onBackground: value.onBackground ?? this.onBackground,
      divider: value.divider ?? this.divider,
      extras: value.extras ?? new Map()
    })
  }
}