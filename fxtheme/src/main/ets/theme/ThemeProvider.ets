import { Theme } from '.'
import { HexColor } from '../color'

@Component
export struct ThemeProvider {

  @Link theme: Theme
  @BuilderParam builder: () => void
  // @BuilderParam builder: (theme: Theme) => void //theme改变时不能通知下层

  build() {
    Column() {
      this.builder()
    }
  }
}