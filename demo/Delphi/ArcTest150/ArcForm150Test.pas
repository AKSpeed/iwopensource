unit ArcForm150Test;

//https://code.google.com/archive/p/iwopensource/

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, Vcl.Controls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWCompLabel,
  ArcIWEmbeddedHTML, ArcIWPageController, ArcIWFilledBox, ArcIWScreenInfo,
  IWHTMLControls, IWCompButton, IWCompRadioButton, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWLayoutMgrForm, ArcIWToolWindow;

type
  TIWFormTest150 = class(TIWAppForm)
    ArcIWScreenInfo1: TArcIWScreenInfo;
    ArcIWFilledBox1: TArcIWFilledBox;
    ArcIWPageController1: TArcIWPageController;
    ArcIWEmbeddedHTML1: TArcIWEmbeddedHTML;
    ArcIWEmbeddedHTML2: TArcIWEmbeddedHTML;
    ArcIWToolWindow1: TArcIWToolWindow;
    procedure IWAppFormCreate(Sender: TObject);
  public
  end;

implementation

{$R *.dfm}


procedure TIWFormTest150.IWAppFormCreate(Sender: TObject);
var
 ssUrl: string;
 iiPos: integer;
begin
 ssUrl:= GetWebApplication.ApplicationURL;
 iiPos:= ssUrl.LastDelimiter(':'); //LastIndexOf
// ssUrl.Substring :=iiPos; //ssUrl
//Substring(StartIndex: Integer; Length: Integer):
//Title:= ssUrl.Substring(0,iiPos);
// IWURLWindow1.URI := ssUrl.Substring(0,iiPos)+'/tablo/0/display.html';
// self.UpdateMode
// ArcIWFilledBox1.
end;

initialization
  TIWFormTest150.SetAsMainForm;

end.
