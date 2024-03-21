import { HexColor, Theme } from '@fx/theme'
import { ColorKeys } from '../constants/ColorKeys'

export class ThemeUtils {
  static setLightExtras(theme: Theme) {
    if (theme.seedColor) {
      theme.light.extras.set(ColorKeys.DISABLED, theme.seedColor!.withOpacity(0.2))
    } else {
      theme.light.extras.set(ColorKeys.DISABLED, new HexColor(theme.primary).withOpacity(0.2))
    }
    theme.light.extras.set(ColorKeys.VIEW, new HexColor(0xFFFFFFFF))

    theme.light.extras.set(ColorKeys.TEXT_PRIMARY, new HexColor(0xFF2A2929))
    theme.light.extras.set(ColorKeys.TEXT_SECONDARY, new HexColor(0xFF818181))
    theme.light.extras.set(ColorKeys.TEXT_PLACEHOLDER, new HexColor(0xFFC2C1C1))

    theme.light.extras.set(ColorKeys.SUCCESS, new HexColor(0xFF27BA9B))
    theme.light.extras.set(ColorKeys.DANGER, new HexColor(0xFFFF4C4C))
    theme.light.extras.set(ColorKeys.WARNING, new HexColor(0xFFFFAB2E))
  }

  static setDarkExtras(theme: Theme) {
    if (theme.seedColor) {
      theme.dark.extras.set(ColorKeys.DISABLED, theme.seedColor!.withOpacity(0.2))
    }
    theme.dark.extras.set(ColorKeys.VIEW, new HexColor(0xFF1F1F1F))

    theme.dark.extras.set(ColorKeys.TEXT_PRIMARY, new HexColor(0xFFFFFFFF))
    theme.dark.extras.set(ColorKeys.TEXT_SECONDARY, new HexColor(0xFF818181))
    theme.dark.extras.set(ColorKeys.TEXT_PLACEHOLDER, new HexColor(0xFFC2C1C1))

    theme.dark.extras.set(ColorKeys.SUCCESS, new HexColor(0xFF27BA9B))
    theme.dark.extras.set(ColorKeys.DANGER, new HexColor(0xFFFF4C4C))
    theme.dark.extras.set(ColorKeys.WARNING, new HexColor(0xFFFFAB2E))
  }
}