import ClampUtil from '../utils/ClampUtil'

export interface ARGB {
  a: number // 0~255(0xFF)
  r: number // 0~255(0xFF)
  g: number // 0~255(0xFF)
  b: number // 0~255(0xFF)
}

interface RGB {
  r: number // 0~255(0xFF)
  g: number // 0~255(0xFF)
  b: number // 0~255(0xFF)
}

export class HexColor {
  readonly value: number

  /// ******************** Constructor ********************

  constructor(value: number) {
    this.value = value ?? 0x00000000
  }

  static fromARGB(argb: ARGB): HexColor {
    let a = ClampUtil.clamp(argb.a)
    let r = ClampUtil.clamp(argb.r)
    let g = ClampUtil.clamp(argb.g)
    let b = ClampUtil.clamp(argb.b)
    return new HexColor((a << 24) | (r << 16) | (g << 8) | b)
  }

  static fromRGB(rgb: RGB): HexColor {
    let argb = { a: 255, r: rgb.r, b: rgb.b, g: rgb.g } as ARGB
    return HexColor.fromARGB(argb)
  }

  /// ******************** ARGB-Store ********************

  // 转成【A/R/G/B】的文本形式存储
  formatToStoreARGB(): string {
    return `${this.alpha}/${this.red}/${this.green}/${this.blue}`
  }

  static fromStoreARGB(str: string): HexColor {
    let tmpList = str.split('/')
    return HexColor.fromARGB({
      a: Number(tmpList[0]),
      r: Number(tmpList[1]),
      g: Number(tmpList[2]),
      b: Number(tmpList[3])
    })
  }

  /// ******************** Getter ********************

  get opacity(): number {
    return this.alpha / 0xFF
  }

  get alpha(): number {
    return this.value >>> 24
  }

  get red(): number {
    return (this.value >> 16) & 0xFF
  }

  get green(): number {
    return (this.value >> 8) & 0xFF
  }

  get blue(): number {
    return (this.value) & 0xFF
  }

  get luminance(): number {
    return ((0.2126 * this.red) + (0.7152 * this.green) + (0.0722 * this.blue)) / 255
  }

  /// ******************** Method ********************

  copyWith(argb: Partial<ARGB>): HexColor {
    return HexColor.fromARGB({
      a: argb.a ?? this.alpha,
      r: argb.r ?? this.red,
      g: argb.g ?? this.green,
      b: argb.b ?? this.blue,
    })
  }

  withAlpha(alpha: number): HexColor {
    return this.copyWith({
      a: alpha
    })
  }

  withOpacity(opacity: number): HexColor {
    return this.withAlpha(opacity * 0xFF)
  }

  blend(backColor: HexColor): HexColor {
    if (this.alpha <= 0) return backColor
    if (this.alpha >= 0xFF) return this
    let fa = this.opacity
    let ba = backColor.opacity
    return HexColor.fromARGB({
      a: (fa + ba - fa * ba) * 0xFF,
      r: this.red * fa + backColor.red * ba * (1 - fa),
      g: this.green * fa + backColor.green * ba * (1 - fa),
      b: this.blue * fa + backColor.blue * ba * (1 - fa),
    })
  }

  toHSL(): HSLColor {
    return new HSLColor(RGB2HSL({
      r: this.red,
      g: this.green,
      b: this.blue,
    }))
  }
}

interface HSL {
  h: number // 0~1 色相Hue
  s: number // 0~1 饱和度Saturation
  l: number // 0~1 明度Lightness
}

export class HSLColor {
  readonly hue: number
  readonly saturation: number
  readonly lightness: number

  constructor(hsl: HSL) {
    this.hue = ClampUtil.clamp(hsl.h)
    this.saturation = ClampUtil.clamp(hsl.s)
    this.lightness = ClampUtil.clamp(hsl.l)
  }

  copyWith(hsl: Partial<HSL>): HSLColor {
    return new HSLColor({
      h: hsl.h ?? this.hue,
      s: hsl.s ?? this.saturation,
      l: hsl.l ?? this.lightness,
    })
  }

  toRGB(): HexColor {
    return HexColor.fromRGB(HSL2RGB({
      h: this.hue,
      s: this.saturation,
      l: this.lightness,
    }))
  }
}

function HSL2RGB(hsl: HSL): RGB {
  let r: number, g: number, b: number

  if (hsl.s === 0) {
    r = g = b = hsl.l
  } else {
    const q = hsl.l < 0.5 ? hsl.l * (1 + hsl.s) : hsl.l + hsl.s - hsl.l * hsl.s
    const p = 2 * hsl.l - q

    let HUE2RGB = (p: number, q: number, t: number): number => {
      if (t < 0) t += 1
      if (t > 1) t -= 1
      if (t < 1 / 6) return p + (q - p) * 6 * t
      if (t < 1 / 2) return q
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6
      return p
    }

    r = HUE2RGB(p, q, hsl.h + 1 / 3)
    g = HUE2RGB(p, q, hsl.h)
    b = HUE2RGB(p, q, hsl.h - 1 / 3)
  }

  return {
    r: Math.min(Math.floor(r * 256), 255),
    g: Math.min(Math.floor(g * 256), 255),
    b: Math.min(Math.floor(b * 256), 255),
  }
}

function RGB2HSL(rgb: RGB): HSL {
  let tmp = { r: rgb.r, g: rgb.g, b: rgb.b } as RGB
  tmp.r /= 255
  tmp.g /= 255
  tmp.b /= 255

  const max = Math.max(tmp.r, tmp.g, tmp.b)
  const min = Math.min(tmp.r, tmp.g, tmp.b)

  let h: number = (max + min) / 2
  let s: number = (max + min) / 2
  let l: number = (max + min) / 2

  if (max === min) {
    h = s = 0
  } else {
    const d = max - min
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
    if (max === tmp.r) h = (tmp.g - tmp.b) / d + (tmp.g < tmp.b ? 6 : 0)
    if (max === tmp.g) h = (tmp.b - tmp.r) / d + 2
    if (max === tmp.b) h = (tmp.r - tmp.g) / d + 4
    h /= 6
  }

  return { h: h, s: s, l: l }
}