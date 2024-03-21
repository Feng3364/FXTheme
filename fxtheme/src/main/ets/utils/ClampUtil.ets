interface Range {
  min?: number
  max?: number
}

export default class ClampUtil {
  static clamp(value: number, range: Range = {
    min: 0, max: 255
  }): number {
    if (range.min && value < range.min) return range.min
    if (range.max && value > range.max) return range.max
    return value
  }
}