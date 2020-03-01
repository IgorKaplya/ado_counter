unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Data.Win.ADODB, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,
  Vcl.ButtonGroup, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    con: TADOConnection;
    tbl: TADOTable;
    dsTbl: TDataSource;
    dbgTbl: TDBGrid;
    cbbTabls: TComboBox;
    imlMain: TImageList;
    amTbl: TActionManager;
    actInsert: TAction;
    actDelete: TAction;
    acttb: TActionToolBar;
    actCancel: TAction;
    actPost: TAction;
    actEdit: TAction;
    qry: TADOQuery;
    procedure actCancelExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actInsertUpdate(Sender: TObject);
    procedure actPostExecute(Sender: TObject);
    procedure actPostUpdate(Sender: TObject);
    procedure cbbTablsChange(Sender: TObject);
    procedure dbgTblKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgTblKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure tblAfterOpen(DataSet: TDataSet);
  private
    FInited: Boolean;
    property Inited: Boolean read FInited;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.actCancelExecute(Sender: TObject);
begin
  tbl.Cancel();
end;

procedure TForm1.actDeleteExecute(Sender: TObject);
begin
  tbl.Delete();
end;

procedure TForm1.actEditExecute(Sender: TObject);
begin
  tbl.Edit();
end;

procedure TForm1.actInsertExecute(Sender: TObject);
begin
  tbl.Append();
  tbl.FieldByName('name').AsString:='new';
end;

procedure TForm1.actInsertUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tbl.State in [dsBrowse]);
end;

procedure TForm1.actPostExecute(Sender: TObject);
begin
  tbl.Post();
end;

procedure TForm1.actPostUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tbl.State in dsEditModes );
end;

procedure TForm1.cbbTablsChange(Sender: TObject);
begin
  tbl.Close();
    tbl.TableName:=(Sender as TComboBox).Text;
  tbl.Open();
end;

procedure TForm1.dbgTblKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_INSERT: Key:=0;
  VK_DOWN:
    if (Sender as TDBGrid).DataSource.DataSet.Eof then
      Key:=0;
  VK_DELETE:
    if ssCtrl in Shift then
      Key:=0;
  end;
end;

procedure TForm1.dbgTblKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_DOWN:
    if (Sender as TDBGrid).DataSource.DataSet.Eof then
      (Sender as TDBGrid).DataSource.DataSet.Cancel;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
if not Inited then
  begin
  con.Connected:=True;
  con.GetTableNames(cbbTabls.Items);
  FInited:=True;
  end;
end;

procedure TForm1.tblAfterOpen(DataSet: TDataSet);
{ikaplya
  Limit of display size for fields
}
const
  C_DisplayWidth_Limiter = 75;
var
  f: TField;
begin
  for f in DataSet.Fields do
    begin
    if f.DisplayWidth>C_DisplayWidth_Limiter then
      f.DisplayWidth:=C_DisplayWidth_Limiter;
    end;
end;

end.
