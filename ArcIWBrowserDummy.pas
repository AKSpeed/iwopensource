unit ArcIWBrowserDummy;

// ArcIW browser version check for Intraweb v15.0.10 Depricated TIWBrowserDummy
// Andrey Kolesov  kodemitan@gmail.com
// v0 AK'  5/6/2019   ArcIW Not Supported Browsers:  brNetscape6.


interface

uses IWBaseForm, IW.Browser.Browser;

// IWBaseForm:
//  TIWBrowserDummy = (brUnknown, brNetscape7 , brIE, brGecko, brOpera, brSafari, brChrome, brIE4, brNetscape6, brNetscape4, brOther, brHTML32Test
//    , brWMLTest, brXHTMLMPTest, brWAP, brSearchEngine


function IWBrowserDummyCheck(rBrowser: TBrowser):TIWBrowserDummy;

implementation

uses IW.Browser.Other,
     IW.Browser.InternetExplorer,
     IW.Browser.Firefox, // IW.Browser.FirefoxMobile,
     IW.Browser.Chrome, // IW.Browser.ChromeMobile,  IW.Browser.Android,
     IW.Browser.Opera,  // IW.Browser.OperaMobile, IW.Browser.OperaNext,
     IW.Browser.Safari; // IW.Browser.SafariMobile,

//  IW.Browser.Webkit,
//  IW.Browser.Edge, IW.Browser.SearchEngine,

function IWBrowserDummyCheck(rBrowser: TBrowser):TIWBrowserDummy;
begin
  if (rBrowser is TOther) then
  begin
    // accept the unknown browser as Internet Explorer v10
     result:= brOther //brIE
  end
  // if is Safari, but older version
  else if (rBrowser is TSafari) then  ///and (not rBrowser.IsSupported) then
   begin
     result:= brSafari    // Webkit
   end
  // if is Chrome, but older version
   else
   if (rBrowser is TChrome) then  //and (not rBrowser.IsSupported) then
   begin
     result:= brChrome    // Blink
   end
  // if is Firefox, but older version
   else
   if (rBrowser is TFirefox) then // and (not rBrowser.IsSupported) then
   begin
    // we will create it as the minimum supported version
     result:= brGecko //Firefox Gecko
   end
  // if is IE, but older version
   else
   if (rBrowser is TInternetExplorer) then // and (not rBrowser.IsSupported)
   begin
    // we will create it as the minimum supported version
     result:= brIE //Firefox Gecko
   end
   else
   if (rBrowser is TOpera) then
   begin
     result:= brOpera //Opera Presto ver <=  17
   end
   else result:= brUnknown
end;
end.
