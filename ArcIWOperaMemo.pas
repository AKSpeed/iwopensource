////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  unit ArcIWOperaMemo                                                       //
//    Copyright 2002 by Arcana Technologies Incorporated                      //
//    Written By Jason Southwell                                              //
//                                                                            //
//  Description:                                                              //
//    This component provides an Opera friendly version of the TIWMemo        //
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
//    07/27/2002 - Released to TArcIWOperaMemo to Open Source.                //
//    05/12/2003 - Removed support for IW4, Added support for IW6             //
//    10/02/2003 - Added support for IW7                                      //
//    05/06/2019 IW 15.0.1 Opera v17 components not supported! AK'            //
//                                                                            //
//  License:                                                                  //
//    This code is covered by the Mozilla Public License 1.1 (MPL 1.1)        //
//    Full text of this license can be found at                               //
//    http://www.opensource.org/licenses/mozilla1.1.html                      //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

unit ArcIWOperaMemo;

interface

{$I IWVersion.inc}

uses
  Windows, Messages, SysUtils, Classes, IWControl, IWCompMemo, IWTypes,
  {$IF CompilerVersion < 27.0} //CompilerVersion: Extended = 31 Xe10;   VER270 = xe6
   Controls,
  {$IFEND}
  ArcIWOperaFix,
  {$IFDEF IWVERCLASS6} IWRenderContext, IWBaseControlInterface, IWScriptEvents, {$ENDIF}
  {$IFDEF IWVERSION70} IWRenderContext, {$ENDIF}
  IWHTMLTag;

type
  TArcIWOperaMemo = class(TIWMemo)
  private
  protected
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
{$IFNDEF IWVERSION150} // TIWAppForm <<= TIWBaseForm
    constructor Create(AOwner: TComponent); override;
{$ENDIF} //72
  published
  end;

implementation

uses
{$IFDEF IWVERSION150} ArcIWBrowserDummy, IWBaseForm, {$ENDIF} //, IW.Common.SysTools,
IWAppForm;

{ TArcIWOperaMemo }

{$IFNDEF IWVERSION150} // TIWAppForm <<= TIWBaseForm
//v15 deprecated
//    property SupportedBrowsers: TIWBrowsersDummy write SetSupportedBrowsers;
constructor TArcIWOperaMemo.Create(AOwner: TComponent);
var
  browsers : TIWBrowsers;
begin
  inherited;
  if (csDesigning in ComponentState) then
  begin
    if not (brOpera in  TIWAppForm(Owner).SupportedBrowsers) then
    begin
      browsers := TIWAppForm(Owner).SupportedBrowsers;
      Include(browsers,brOpera);
      TIWAppForm(Owner).SupportedBrowsers := browsers;
    end;
  end;
end;
{$ENDIF}

{$IFDEF IWVERCLASS5}
function TArcIWOperaMemo.RenderHTML: TIWHTMLTag;
begin
  if WebApplication.Browser = brOpera then
    Result := RenderHTML5(Self, inherited RenderHTML)
  else
    Result := inherited RenderHTML;
end;
{$ELSE} //IWVERCLASS5
 {$IFDEF IWVERSION150} //15
 function TArcIWOperaMemo.RenderHTML(AContext: TIWCompContext): TIWHTMLTag;
 {$ELSE}  //15
  {$IFDEF IWVERSION70}
  function TArcIWOperaMemo.RenderHTML(AContext: TIWBaseComponentContext): TIWHTMLTag;
  {$ELSE}
  function TArcIWOperaMemo.RenderHTML(AContext: TIWBaseHTMLComponentContext): TIWHTMLTag;
  {$ENDIF}
 {$ENDIF} //15
begin
  Result := inherited RenderHTML(AContext);
end;
{$ENDIF}

end.


