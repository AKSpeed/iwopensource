////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  unit ArcIWEmbeddedHTML                                                    //
//    Copyright 2002 by Arcana Technologies Incorporated                      //
//    Written By Jason Southwell                                              //
//                                                                            //
//  Description:                                                              //
//    This component provides an IntraWeb implementation of the IFRAME html   //
//    tag.  It provides you a way to dynamically link external HTML pages     //
//    inside of your HTML page.  In IntraWeb it is a good way to link in      //
//    static HTML menus or to keep a branded look by incorporating header     //
//    or footer pages dynamically.                                            //
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
//    05/01/2002 - Released to TIWEmbeddedHTML to Open Source.                //
//    07/26/2002 - Changed Prefix from IW to ArcIW.  Added to a package.      //
//                 Moved component registration to common unit for package.   //                            
//    08/02/2002 - Added FrameName property and set the IFRAMEs name property //
//                 accordingly.                                               //
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

unit ArcIWEmbeddedHTML;

interface

{$I IWVersion.inc}

uses
  Windows, Messages, SysUtils, Classes,  IWControl,
  {$IF CompilerVersion < 27.0} //CompilerVersion: Extended = 31 Xe10;   VER270 = xe6
   Controls,
  {$IFEND}
  {$IFDEF IWVERCLASS6} IWRenderContext, IWBaseControlInterface, {$ENDIF}
  {$IFDEF IWVERSION150} IWBaseHTMLComponent, {$ENDIF} //IWBaseRenderContext
  {$IFDEF IWVERSION70} IWRenderContext, {$ENDIF}
  IWHTMLTag;


type
  TFrameAlignment = (faNone, faTop, faMiddle, faBottom, faLeft, faRight);
  TScrollbarStyle = (sbShow, sbHide, sbAuto);
  TBorderStyle = (bsNone, bsSingle);
  TArcSizeMetrics = (smPixels, smPercent);

  TArcIWEmbeddedHTML = class(TIWControl)
  private
    FMarginHeight: integer;
    FMarginWidth: integer;
    FDescriptionURL: string;
    FSourceURL: string;
    FAlignment: TFrameAlignment;
    FScrollBars: TScrollbarStyle;
    FBorderStyle: TBorderStyle;
    FFrameName: string;
    FSizeMetrics: TArcSizeMetrics;
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
    constructor Create(AOwner: TComponent); override;
  published
    property SourceURL : string read FSourceURL write FSourceURL;
    property DescriptionURL : string read FDescriptionURL write FDescriptionURL;
    property Alignment : TFrameAlignment read FAlignment write FAlignment default faNone;
    property BorderStyle : TBorderStyle read FBorderStyle write FBorderStyle default bsSingle;
    property MarginWidth : integer read FMarginWidth write FMarginWidth;
    property MarginHeight : integer read FMarginHeight write FMarginHeight;
    property ScrollBars : TScrollbarStyle read FScrollBars write FScrollBars default sbAuto;
    property FrameName : string read FFrameName write FFrameName;
    property SizeMetrics : TArcSizeMetrics read FSizeMetrics write FSizeMetrics;
  end;

implementation

{ TArcIWEmbeddedHTML }

constructor TArcIWEmbeddedHTML.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := faNone;
  FScrollBars := sbAuto;
  FBorderStyle := bsSingle;
  FMarginHeight := 0;
  FMarginWidth := 0;
end;

{$IFDEF VERCLASS5}
function TArcIWEmbeddedHTML.RenderHTML: TIWHTMLTag;
begin
  Result := TIWHTMLTag.CreateTag('IFRAME');
  Result.AddStringParam('SRC',FSourceURL);
  Result.AddStringParam('NAME',FFrameName);
  Result.AddIntegerParam('MARGINWIDTH',FMarginWidth);
  Result.AddIntegerParam('MARGINHEIGHT',FMarginHeight);
  case FSizeMetrics of
    smPixels:
      begin
        Result.AddIntegerParam('WIDTH',Width);
        Result.AddIntegerParam('HEIGHT',Height);
      end;
    smPercent:
      begin
        Result.AddStringParam('WIDTH',IntToStr(Width)+'%');
        Result.AddStringParam('HEIGHT',IntToStr(Height)+'%');
      end;
  end;
  if FDescriptionURL<>'' then
    Result.AddStringParam('LONGDESC',FDescriptionURL);
  case FAlignment of
    faTop:    Result.AddStringParam('ALIGN','top');
    faMiddle: Result.AddStringParam('ALIGN','middle');
    faBottom: Result.AddStringParam('ALIGN','bottom');
    faLeft:   Result.AddStringParam('ALIGN','left');
    faRight:  Result.AddStringParam('ALIGN','right');
  end;
  if FBorderStyle = bsNone then
    Result.AddIntegerParam('FRAMEBORDER',0);
  case FScrollBars of
    sbShow: Result.AddStringParam('SCROLLING','yes');
    sbHide: Result.AddStringParam('SCROLLING','no');
    sbAuto: Result.AddStringParam('SCROLLING','auto');
  end;
  Result.Contents.AddTag('Your browser does not support IFRAMES...');
end;
{$ELSE} //72
 {$IFDEF IWVERSION150} //15
   function TArcIWEmbeddedHTML.RenderHTML(AContext: TIWCompContext): TIWHTMLTag;
 {$ELSE}  //15
  {$IFDEF IWVERSION70}
    function TArcIWEmbeddedHTML.RenderHTML(AContext: TIWBaseComponentContext): TIWHTMLTag;
  {$ELSE}
    function TArcIWEmbeddedHTML.RenderHTML(AContext: TIWBaseHTMLComponentContext): TIWHTMLTag;
  {$ENDIF}
 {$ENDIF} //15
begin
  Result := TIWHTMLTag.CreateTag('IFRAME');
  Result.AddStringParam('SRC',FSourceURL);
  Result.AddStringParam('NAME',FFrameName);
  Result.AddIntegerParam('MARGINWIDTH',FMarginWidth);
  Result.AddIntegerParam('MARGINHEIGHT',FMarginHeight);
  case FSizeMetrics of
    smPixels:
      begin
        Result.AddIntegerParam('WIDTH',Width);
        Result.AddIntegerParam('HEIGHT',Height);
      end;
    smPercent:
      begin
        Result.AddStringParam('WIDTH',IntToStr(Width)+'%');
        Result.AddStringParam('HEIGHT',IntToStr(Height)+'%');
      end;
  end;
  if FDescriptionURL<>'' then
    Result.AddStringParam('LONGDESC',FDescriptionURL);
  case FAlignment of
    faTop:    Result.AddStringParam('ALIGN','top');
    faMiddle: Result.AddStringParam('ALIGN','middle');
    faBottom: Result.AddStringParam('ALIGN','bottom');
    faLeft:   Result.AddStringParam('ALIGN','left');
    faRight:  Result.AddStringParam('ALIGN','right');
  end;
  if FBorderStyle = bsNone then
    Result.AddIntegerParam('FRAMEBORDER',0);
  case FScrollBars of
    sbShow: Result.AddStringParam('SCROLLING','yes');
    sbHide: Result.AddStringParam('SCROLLING','no');
    sbAuto: Result.AddStringParam('SCROLLING','auto');
  end;
  Result.Contents.AddTag('Your browser does not support IFRAMES...');
end;
{$ENDIF}//72

end.


