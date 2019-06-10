////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  unit ArcIWScreenInfo                                                      //
//    Copyright 2002 by Arcana Technologies Incorporated                      //
//    Written By Jason Southwell                                              //
//                                                                            //
//  Description:                                                              //
//    This component allows you to view Browser's screen properties in an     //
//    IntraWeb application.  Drop this component on your IW form.  When the   //
//    form returns to IW, the ClientScreen property will be filled in with    //
//    the values from the DOM document.screen object.                         //
//                                                                            //
//    Note that the values will not be available before the user takes action //
//    on the IW form and it is submitted to IW.  To do something as soon as   //
//    the values are available, use the event handler OnHasData.              //
//                                                                            //
//    This component is compatible with both IntraWeb versions 4 and 5.       //
//    To compile for the particular version you have installed, change        //
//    the compiler directive comment in IWVersion.inc.                        //
//                                                                            //
//    Information on IntraWeb can be found at www.atozedsoftware.com          //
//    Arcana Technologies Incorporated has no affilation with IntraWeb        //
//    or Atozed Software with the exception of being a satisfied customer.    //
//                                                                            //
//  Updates:                                                                  //
//    07/11/2002 - Released to TArcIWScreenInfo to Open Source.               //
//    05/12/2003 - Removed support for IW4, Added support for IW6             //
//    10/02/2003 - Added support for IW7                                      //
//    05/06/2019 - AK' Added IW 15.0.1  & xe10 Berlin                         //
//                                                                            //
//  License:                                                                  //
//    This code is covered by the Mozilla Public License 1.1 (MPL 1.1)        //
//    Full text of this license can be found at                               //
//    http://www.opensource.org/licenses/mozilla1.1.html                      //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

unit ArcIWScreenInfo;

{$I IWVersion.inc}

interface

uses
  Windows, Messages, SysUtils, Classes,
  {$IF CompilerVersion >= 27.0} Vcl.Controls,{$ELSE} Controls, {$ENDIF} //xe10 Graphics
  IWControl, IWTypes,
  {$IFDEF IWVERCLASS6} IWRenderContext, IWBaseControlInterface, IWScriptEvents, {$ENDIF}
  {$IFDEF IWVERSION70} IWRenderContext, {$ENDIF}
  IWHTMLTag;

type
  TArcIWClientScreen = record
    availHeight : integer;
    availLeft   : integer;
    availTop    : integer;
    availWidth  : integer;
    colorDepth  : integer;
    height      : integer;
    pixelDepth  : integer;
    top         : integer;
    width       : integer;
  end;

  TArcIWScreenInfo = class(TIWControl)
  private
    FClientScreen: TArcIWClientScreen;
    FOnHasData: TNotifyEvent;
  protected
    procedure SetValue(const AValue: String); override;
  public
    {$IFDEF IWVERCLASS5}
    function RenderHTML: TIWHTMLTag; override;
    {$ELSE}  //72
     {$IFDEF IWVERSION150} //15
      function RenderHTML(AContext: TIWCompContext): TIWHTMLTag; override;
     {$ELSE}   //15
      {$IFDEF IWVERSION70} //70
       function RenderHTML(AContext: TIWBaseComponentContext): TIWHTMLTag; override;
      {$ELSE}
       function RenderHTML(AContext: TIWBaseHTMLComponentContext): TIWHTMLTag; override;
      {$ENDIF} //70
     {$ENDIF} //15
    {$ENDIF} //72
    constructor Create(AOwner : TComponent); override;
  published
    property ClientScreen : TArcIWClientScreen read FClientScreen;
    property OnHasData : TNotifyEvent read FOnHasData write FOnHasData;
  end;

implementation

{ TArcIWScreenInfo }

constructor TArcIWScreenInfo.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF IWVERCLASS5}
  FSupportsInput := True;
  {$ENDIF}
end;

{$IFDEF IWVERCLASS5}
function TArcIWScreenInfo.RenderHTML: TIWHTMLTag;
var
  sScript : string;
begin
  Result := TIWHTMLTag.CreateTag('INPUT');
  Result.AddStringParam('type','hidden');
  Result.AddStringParam('Value','blankvalue');

  sScript := 'document.SubmitForm.'+Uppercase(Name)+'.value="'+
	     'availHeight="+window.screen.availHeight+",'+
	     'availLeft="+window.screen.availLeft+",'+
	     'availTop="+window.screen.availTop+",'+
	     'availWidth="+window.screen.availWidth+",'+
	     'colorDepth="+window.screen.colorDepth+",'+
	     'height="+window.screen.height+",'+
	     'pixelDepth="+window.screen.pixelDepth+",'+
	     'top="+window.screen.top+",'+
	     'width="+window.screen.width;';

  AddToInitProc(sScript);
end;
{$ELSE} //IWVERCLASS5
 {$IFDEF IWVERSION150} //15
 function TArcIWScreenInfo.RenderHTML(AContext: TIWCompContext): TIWHTMLTag;
 {$ELSE}  //15
  {$IFDEF IWVERSION70}
  function TArcIWScreenInfo.RenderHTML(AContext: TIWBaseComponentContext): TIWHTMLTag;
  {$ELSE}
  function TArcIWScreenInfo.RenderHTML(AContext: TIWBaseHTMLComponentContext): TIWHTMLTag;
  {$ENDIF}
 {$ENDIF} //15
var
  sScript : string;
begin
  Result := TIWHTMLTag.CreateTag('INPUT');
  Result.AddStringParam('type','hidden');
  Result.AddStringParam('Value','blankvalue');

  sScript := 'top.FindElem("' + HTMLName + '").value ="' +
	     'availHeight="+window.screen.availHeight+",'+
	     'availLeft="+window.screen.availLeft+",'+
	     'availTop="+window.screen.availTop+",'+
	     'availWidth="+window.screen.availWidth+",'+
	     'colorDepth="+window.screen.colorDepth+",'+
	     'height="+window.screen.height+",'+
	     'pixelDepth="+window.screen.pixelDepth+",'+
	     'top="+window.screen.top+",'+
	     'width="+window.screen.width;';

//  sScript := sScript+#13+'alert("set value to: "+document.SubmitForm.'+Uppercase(Name)+'.value);';

 {$IFDEF IWVERSION150} //15
//v15 Not used anymore This is ignored, kept only for streaming compat
//    TIWFormUpdateMode = (umAll, umPartial);
    AContext.AddToInitProc(sScript);
 {$ELSE}  //15
  case TIWPageContext40(AContext.PageCOntext).UpdateMode of
    umPartial: TIWComponent40Context(Acontext). .AddToUpdateInitProc(sScript);
    umAll:     TIWComponent40Context(Acontext).AddToInitProc(sScript);
  end;
 {$ENDIF}
end;
{$ENDIF}


procedure TArcIWScreenInfo.SetValue(const AValue: string);
var
  sl : TStringList;
  i : integer;
begin
  inherited;
  sl := TStringList.Create;
  try
    sl.CommaText := AValue;
    for i := 0 to sl.Count-1 do
    begin
      if sl[i]='' then continue;
      case sl[i][1] of
        'a':
          begin
            if length(sl[i]) < 6 then continue;
            case sl[i][6] of
              'H': FClientScreen.availHeight := StrToIntDef(sl.Values[sl.Names[i]],0);
              'L': FClientScreen.availLeft   := StrToIntDef(sl.Values[sl.Names[i]],0);
              'T': FClientScreen.availTop    := StrToIntDef(sl.Values[sl.Names[i]],0);
              'W': FClientScreen.availWidth  := StrToIntDef(sl.Values[sl.Names[i]],0);
            end;
          end;
        'c': FClientScreen.colorDepth := StrToIntDef(sl.Values[sl.Names[i]],0);
        'h': FClientScreen.height     := StrToIntDef(sl.Values[sl.Names[i]],0);
        'p': FClientScreen.pixelDepth := StrToIntDef(sl.Values[sl.Names[i]],0);
        't': FClientScreen.top        := StrToIntDef(sl.Values[sl.Names[i]],0);
        'w': FClientScreen.width      := StrToIntDef(sl.Values[sl.Names[i]],0);
      end;
    end;
  finally
    sl.Free;
  end;
  if Assigned(FOnHasData) then
    FOnHasData(Self);
end;

end.
