import { DEFAULT_THEME, Theme } from './'
import { Context } from '@kit.AbilityKit'
import preferences from '@ohos.data.preferences'
import { HexColor } from '../color'

export const THEME_KEY = 'FXTheme'

export const THEME_SEED_KEY = 'FXThemeSeed'

export const THEME_MODE_KEY = 'FXThemeMode'

export const THEME_JSON_KEY = 'FXThemeJSON'

export class ThemeStorage {
  /// ******************** Preferences ********************

  // 优先使用primary色值存储，若使用自定义主题色则不要设置seedColor
  static loadLastTheme(context: Context): Theme {
    const store = preferences.getPreferencesSync(context, { name: THEME_KEY })
    const argb = store.getSync(THEME_SEED_KEY, '') as string

    let theme: Theme | undefined = undefined
    if (argb !== '') {
      theme = Theme.fromSeedColor(HexColor.fromStoreARGB(argb))
    } else {
      const json = store.getSync(THEME_JSON_KEY, '') as string
      theme = json === '' ? DEFAULT_THEME : Theme.fromJSON(json)
    }
    theme!.mode = store.getSync(THEME_MODE_KEY, 0) as number
    return theme
  }

  static saveTheme(context: Context, theme: Theme) {
    const store = preferences.getPreferencesSync(context, { name: THEME_KEY })

    if (theme.seedColor) {
      store.putSync(THEME_SEED_KEY, theme.seedColor!.formatToStoreARGB())
    } else {
      store.putSync(THEME_JSON_KEY, theme.toJSON())
    }
    store.putSync(THEME_MODE_KEY, theme.mode.valueOf())
    store.flush()
  }

  /// ******************** Theme ********************

  static get theme(): Theme {
    if (!AppStorage.has(THEME_KEY)) {
      AppStorage.setOrCreate(THEME_KEY, DEFAULT_THEME)
    }
    return AppStorage.get<Theme>(THEME_KEY) ?? DEFAULT_THEME
  }

  static set theme(value: Theme) {
    AppStorage.setOrCreate(THEME_KEY, value)
  }
}