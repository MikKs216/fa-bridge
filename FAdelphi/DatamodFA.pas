{ 22.3.2016 13:31:05 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1215 - nove DatamodFA  }
{ 22.3.2016 9:59:41 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in Datamodul pro FA  }
unit DatamodFA;

interface

uses
  SysUtils, Classes, cxClasses, cxLookAndFeels, dxSkinsForm,

  dxSkinFoggy, dxSkinOffice2007Green,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinVS2010
  ;

type
  TdmFA = class(TDataModule)
    dxSkinController1: TdxSkinController;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmFA: TdmFA;

implementation

{$R *.dfm}

end.
