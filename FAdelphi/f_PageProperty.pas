unit f_PageProperty;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, Buttons, Spin;

type
  TFPageProperty = class(TForm)
    RadioGroup1: TRadioGroup;
    btn1: TBitBtn;
    btn2: TBitBtn;
    GroupBox1: TGroupBox;
    qwer: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    ListPaper: TComboBox;
    Label2: TLabel;
    PageTop: TEdit;
    PageLeft: TEdit;
    PageBottom: TEdit;
    PageRight: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPageProperty: TFPageProperty;

implementation

{$R *.dfm}

end.
