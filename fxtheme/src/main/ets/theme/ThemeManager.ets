import { Theme, ThemeMode, DEFAULT_THEME } from '.'
import { AbilityConstant, ConfigurationConstant, EnvironmentCallback } from '@kit.AbilityKit'
import { Configuration } from '@ohos.app.ability.Configuration'
import { ThemeStorage } from './ThemeStorage'

export class ThemeManager {
  private static currentTheme?: Theme

  /// ******************** Initial ********************

  static init(context: Context) {
    ThemeManager.currentTheme = ThemeStorage.loadLastTheme(context)

    let onConfigurationUpdated: EnvironmentCallback = {
      onConfigurationUpdated(config: Configuration): void {
        if (ThemeManager.theme.mode === ThemeMode.auto) {
          switch (config.colorMode) {
            case ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET:
            case ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT:
              ThemeManager.theme.mode = ThemeMode.light
            case ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT:
              ThemeManager.theme.mode = ThemeMode.dark
          }
        }
      },
      onMemoryLevel(_level: AbilityConstant.MemoryLevel): void {}
    }
    context.getApplicationContext().on('environment', onConfigurationUpdated)
  }

  /// ******************** ThemeMode ********************

  static setThemeMode(mode: ThemeMode, context: Context) {
    let newTheme = Theme.copyWith(ThemeStorage.theme)
    newTheme.mode = mode
    ThemeManager.setTheme(newTheme, context)
  }

  /// ******************** Theme ********************

  static get theme() {
    return this.currentTheme ?? DEFAULT_THEME
  }

  static setTheme(theme: Theme, context: Context) {
    ThemeManager.currentTheme = theme
    ThemeStorage.theme = theme
    ThemeStorage.saveTheme(context, theme)
  }
}