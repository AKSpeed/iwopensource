////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  unit ArcIWToolWindow                                                      //
//    Copyright 2002 by Arcana Technologies Incorporated                      //
//    Written By Jason Southwell                                              //
//    Based on Javascript written by Jim Silver @ jimsilver47@yahoo.com       //
//                                                                            //
//  Description:                                                              //
//    This component provides an IntraWeb implementation of a tool window.    //
//    This tool window floats on the page.  The user is able to move and      //
//    close the window.  The tool window can contain either HTML text         //
//    or an embedded html page.                                               //
//                                                                            //
//    This component is compatible with both IntraWeb versions 4 and 5,       //
//    though no testing has been performed on IW4.  If you have IW4,          //
//    please let me know if there are any problems.                           //
//
//    To compile for the particular version you have installed, change        //
//    the compiler directive comment in IWVersion.inc.                        //
//                                                                            //
//    Information on IntraWeb can be found at www.atozedsoftware.com          //
//    Arcana Technologies Incorporated has no affilation with IntraWeb        //
//    or Atozed Software with the exception of being a satisfied customer.    //
//                                                                            //
//  Updates:                                                                  //
//    06/12/2002 - Released to TIWToolWindow to Open Source.                  //
//    06/13/2002 - Fixed color properties in the IW4 version                  //
//    07/26/2002 - Changed Prefix from IW to ArcIW.  Added to a package.      //
//                 Moved component registration to common unit for package.   //                            
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

unit ArcIWToolWindow;

interface

{$I IWVersion.inc}

uses
  Windows, Messages, SysUtils, Classes, IWControl,
  {$IF CompilerVersion >= 27.0} Vcl.Graphics, {$ELSE} Graphics, {$ENDIF} //xe10 Graphics = Vcl.Graphics,
  {$IFDEF IWVERCLASS6} IWRenderContext, IWBaseControlInterface, IWScriptEvents, {$ENDIF}
  {$IFDEF IWVERSION70} IWRenderContext, {$ENDIF}
  IWHTMLTag;

type
  TArcIWToolWindow = class(TIWControl)
  private
    FCaption: string;
    FText: string;
    FBackgroundColor: TColor;
    FBorderColor: TColor;
    FURL: string;
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
    property Caption : string read FCaption write FCaption;
    property Text    : string read FText    write FText;
    property URL     : string read FURL     write FURL;
    property BorderColor : TColor read FBorderColor write FBorderColor;
    property BackgroundColor : TColor read FBackgroundColor write FBackgroundColor;
  end;

implementation

{ TArcIWToolWindow }

constructor TArcIWToolWindow.Create(AOwner: TComponent);
begin
  inherited;
  FBackgroundColor := clWhite;
  FBorderColor := clBlue;
end;

{$IFDEF IWVERCLASS5}
function TArcIWToolWindow.RenderHTML : TIWHTMLTag;
var
  table, table2, tag: TIWHTMLTag;
begin
  {$IFNDEF IWVERSION51}
  AddScriptFile(WebApplication.URLBase +'/files/ArcIWToolWindow.js');
  {$ELSE}
  AddScriptFile(WebApplication.AppURLBase +'/files/ArcIWToolWindow.js');
  {$ENDIF}
  Result := TIWHTMLTag.CreateTag('div');
  Result.AddStringParam('id','TheIWToolWindow');
  Result.AddStringParam('style','position:absolute;width:'+IntToStr(Width)+'px;left:'+IntToStr(Left)+';top:'+IntToStr(Top));
  table := Result.Contents.AddTag('table');
  table.AddIntegerParam('border',0);
  table.AddIntegerParam('width',0);
  table.AddColor('bgcolor',FBorderColor);
  table.AddIntegerParam('cellspacing',0);
  table.AddIntegerParam('cellpadding',2);
  tag := table.Contents.AddTag('tr');
  tag := tag.Contents.AddTag('td');
  tag.AddStringParam('width','100%');
  table2 := tag.Contents.AddTag('table');
  table2.AddIntegerParam('border',0);
  table2.AddStringParam('width','100%');
  table2.AddIntegerParam('cellspacing',0);
  table2.AddIntegerParam('cellpadding',0);
  table2.AddIntegerParam('height',36);
  tag := table2.Contents.AddTag('tr');
  with tag.Contents.AddTag('td') do
  begin
    AddStringParam('id','IWToolWindowDragBar');
    AddStringParam('style','cursor:hand');
    AddStringParam('width','100%');
    with Contents.AddTag('ilayer') do
    begin
      AddStringParam('width','100%');
      AddStringParam('onSelectStart','return false');
      with Contents.AddTag('layer') do
      begin
        AddStringParam('width','100%');
        AddStringParam('onMouseover','dragswitch=1;if (ns4) drag_dropns(showimage)');
        AddStringParam('onMouseout','dragswitch=0');
        with Contents.AddTag('font') do
        begin
          AddStringParam('face','Verdana');
          AddColor('color',FBackgroundColor);
          with Contents.AddTag('strong') do
            with Contents.AddTag('small') do
              contents.AddText(FCaption);
        end;
      end;
    end;
  end;
  with tag.Contents.AddTag('td') do
  begin
    AddStringParam('style','cursor:hand');
    with Contents.AddTag('a') do
    begin
      AddStringParam('href','#');
      AddStringParam('onClick','hidebox();return false');
      with Contents.AddTag('img') do
      begin
        {$IFNDEF IWVERSION51}
	AddStringParam('src',WebApplication.URLBase +'/files/ArcIWToolWindowClose.jpg');
        {$ELSE}
        AddStringParam('src',WebApplication.AppURLBase +'/files/ArcIWToolWindowClose.jpg');
        {$ENDIF}
        AddIntegerParam('width',16);
        AddIntegerParam('height',14);
        AddIntegerParam('border',0);
      end;
    end;
  end;
  tag := table2.Contents.AddTag('tr');
  tag.AddIntegerParam('height',Height);
  with tag.Contents.AddTag('td') do
  begin
    AddStringParam('width','100%');
    AddColor('bgcolor',FBackgroundColor);
    AddStringParam('style','padding:4px');
    AddIntegerParam('colspan',2);
    if FURL <>'' then
    begin
      with Contents.AddTag('iframe') do
      begin
        AddStringParam('src',FURL);
        AddIntegerParam('MarginWidth',0);
        AddIntegerParam('MarginHeight',0);
        AddStringParam('Width','100%');
        AddStringParam('Height','100%');
        AddStringParam('Align','top');
        AddStringParam('Scrolling','auto');
      end;
    end else
      Contents.AddText(FText);
  end;
end;
{$ELSE} //IWVERCLASS5
 {$IFDEF IWVERSION150} //15
 function TArcIWToolWindow.RenderHTML(AContext: TIWCompContext): TIWHTMLTag;
  const
   cnFilesPth15 = 'files';
   cnCursHand15 = 'cursor:hand; cursor:pointer'; //pointer.
//v15 root path: \wwwroot\Files\~~~IWFormTest150_ArcIWFilledBox1.jpg
//    web  url:          /files/~~~IWFormTest150_ArcIWFilledBox1.jpg
 {$ELSE}  //15
  {$IFDEF IWVERSION70}
  function TArcIWToolWindow.RenderHTML(AContext: TIWBaseComponentContext): TIWHTMLTag;
  {$ELSE}
  function TArcIWToolWindow.RenderHTML(AContext: TIWBaseHTMLComponentContext): TIWHTMLTag;
  {$ENDIF}
  const
   cnFilesPth15 = '/files';
   cnCursHand15 = 'cursor:hand'; //.
 {$ENDIF} //15
var
  table, table2, tag: TIWHTMLTag;
begin
// http://www.dynamicdrive.com/dynamicindex11/abox.htm

 {$IFDEF IWVERSION150}  Acontext. {$ELSE} TIWComponent40Context(Acontext). {$ENDIF}
  AddScriptFile(Acontext.WebApplication.AppURLBase +cnFilesPth15+ '/ArcIWToolWindow.js');
  Result := TIWHTMLTag.CreateTag('div');
  Result.AddStringParam('id','TheIWToolWindow');
  Result.AddStringParam('style','position:absolute;width:'+IntToStr(Width)+'px;left:'+
			 IntToStr(Left)+'px;top:'+IntToStr(Top)+'px');
  table := Result.Contents.AddTag('table');
  table.AddIntegerParam('border',0);
  table.AddIntegerParam('width',0);
  table.AddColor('bgcolor',FBorderColor);
  table.AddIntegerParam('cellspacing',0);
  table.AddIntegerParam('cellpadding',2);
  tag := table.Contents.AddTag('tr');
  tag := tag.Contents.AddTag('td');
  tag.AddStringParam('width','100%');
  table2 := tag.Contents.AddTag('table');
  table2.AddIntegerParam('border',0);
  table2.AddStringParam('width','100%');
  table2.AddIntegerParam('cellspacing',0);
  table2.AddIntegerParam('cellpadding',0);
  table2.AddIntegerParam('height',36);
  tag := table2.Contents.AddTag('tr');
  with tag.Contents.AddTag('td') do
  begin
    AddStringParam('id','IWToolWindowDragBar');
    AddStringParam('style',cnCursHand15);
    AddStringParam('width','100%');
    AddStringParam('onMousedown','initializedrag(event)');
    with Contents.AddTag('ilayer') do
    begin
      AddStringParam('width','100%');
      AddStringParam('onSelectStart','return false');
      with Contents.AddTag('layer') do
      begin
	AddStringParam('width','100%');
	AddStringParam('onMouseover','dragswitch=1;if (ns4) drag_dropns(TheIWToolWindow)'); //'TheIWToolWindow' showimage
	AddStringParam('onMouseout','dragswitch=0');
	with Contents.AddTag('font') do
	begin
	  AddStringParam('face','Verdana');
	  AddColor('color',FBackgroundColor);
	  with Contents.AddTag('strong') do
	    with Contents.AddTag('small') do
	      contents.AddText(FCaption);
	end;
      end;
    end;
  end;
  with tag.Contents.AddTag('td') do
  begin
    AddStringParam('style',cnCursHand15);
    with Contents.AddTag('a') do
    begin
      AddStringParam('href','#');
      AddStringParam('onClick','hidebox();return false');
      with Contents.AddTag('img') do
      begin
	AddStringParam('src',AContext.WebApplication.AppURLBase +cnFilesPth15+ '/ArcIWToolWindowClose.jpg');
	AddIntegerParam('width',16);
	AddIntegerParam('height',14);
	AddIntegerParam('border',0);
      end;
    end;
  end;
  tag := table2.Contents.AddTag('tr');
  tag.AddStringParam('height',IntToStr(Top)+'px');//  tag.AddIntegerParam('height',Height);
  with tag.Contents.AddTag('td') do
  begin
    AddStringParam('width','100%');
    AddColor('bgcolor',FBackgroundColor);
    AddStringParam('style','padding:4px');
    AddIntegerParam('colspan',2);
    if FURL <>'' then
    begin
      with Contents.AddTag('iframe') do
      begin
	AddStringParam('src',FURL);
	AddIntegerParam('MarginWidth',0);
	AddIntegerParam('MarginHeight',0);
	AddStringParam('Width','100%');
	AddStringParam('Height','100%');
	AddStringParam('Align','top');
	AddStringParam('Scrolling','auto');
      end;
    end else
      Contents.AddText(FText);
  end;
end;
{$ENDIF}

end.
