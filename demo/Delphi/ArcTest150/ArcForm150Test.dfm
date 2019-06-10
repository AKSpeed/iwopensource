object IWFormTest150: TIWFormTest150
  Left = 0
  Top = 0
  Width = 300
  Height = 200
  RenderInvisibleControls = True
  AllowPageAccess = True
  ConnectionMode = cmAny
  OnCreate = IWAppFormCreate
  Background.Fixed = False
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  XPTheme = True
  DesignLeft = 8
  DesignTop = 8
  object ArcIWScreenInfo1: TArcIWScreenInfo
    Left = 104
    Top = 88
    Width = 24
    Height = 24
  end
  object ArcIWFilledBox1: TArcIWFilledBox
    Left = 263
    Top = 215
    Width = 219
    Height = 160
    Friend = ''
  end
  object ArcIWPageController1: TArcIWPageController
    Left = 339
    Top = 99
    Width = 120
    Height = 89
    PopOut = False
    ScreenMinimum.Width = 0
    ScreenMinimum.Height = 0
    ScreenMaximum.Width = 0
    ScreenMaximum.Height = 0
    Maximize = False
  end
  object ArcIWEmbeddedHTML1: TArcIWEmbeddedHTML
    Left = 0
    Top = -8
    Width = 305
    Height = 217
    SourceURL = 'http://192.168.55.62/tablo/'
    MarginWidth = 0
    MarginHeight = 0
    SizeMetrics = smPixels
  end
  object ArcIWEmbeddedHTML2: TArcIWEmbeddedHTML
    Left = 263
    Top = 400
    Width = 219
    Height = 138
    SourceURL = 'http://192.168.55.62:5551'
    MarginWidth = 0
    MarginHeight = 0
    SizeMetrics = smPixels
  end
  object ArcIWToolWindow1: TArcIWToolWindow
    Left = 16
    Top = 313
    Width = 241
    Height = 225
    Caption = 'Tool!'
    Text = '1111111111'
    URL = 'http://192.168.55.62/tablo/'
    BorderColor = clBlue
    BackgroundColor = clWhite
  end
end
