unit FRichViewPDF;

interface

uses
  Classes, ComCtrls, Controls, RichView, SynCommons, SynPdf, mORMotReport;

procedure SaveRVEditToPDF(AOwner:TWinControl; ARichView:TRichView;
  const AOutPDFFileName: string);

implementation

procedure SaveRVEditToPDF(AOwner:TWinControl; ARichView:TRichView;
  const AOutPDFFileName: string);
var
  ms:TMemoryStream;
  re:TRichEdit;
begin
   re:=TRichEdit.Create(AOwner);
   ms:=TMemoryStream.Create();
   try
     re.Visible:=False;
     re.Parent:=AOwner;
     ARichView.SaveRTFToStream(ms,False);
     ms.Seek(0, soFromBeginning);
     re.Lines.LoadFromStream(ms);

    with TGDIPages.Create(AOwner) do begin
     try
       BeginDoc;
       AppendRichEdit(re.Handle);
       EndDoc;
       ExportPDF(AOutPDFFileName,true,false);
     finally
       Free;
     end;
    end;
   finally
     ms.Free;
     re.Free;
   end;
end;

(*
procedure SaveRVEditToPDF(AOwner:TWinControl; ARichView:TRichView;
  const AOutPDFFileName: string);
var
  ms:TMemoryStream;
  re:TRichEdit;
begin
   re:=TRichEdit.Create(AOwner);
   ms:=TMemoryStream.Create();
   try
     re.Visible:=False;
     re.Parent:=AOwner;
     ARichView.SaveRTFToStream(ms,False);
     ms.Seek(0, soFromBeginning);
     re.Lines.LoadFromStream(ms);

    with TGDIPages.Create(AOwner) do begin
     try
       BeginDoc;
       AppendRichEdit(re.Handle);
       EndDoc;
       ExportPDF(AOutPDFFileName,true,false);
     finally
       Free;
     end;
    end;
   finally
     ms.Free;
     re.Free;
   end;
end;
*)

end.
