unit unitVegatestSelector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls;

type

  { TFormVegatestSelector }

  TFormVegatestSelector = class(TForm)
    btnVegatestDelete: TButton;
    btnVegatestNew: TButton;
    btnVegatestNewGroup: TButton;
    ButtonSave: TButton;
    ButtonClose: TButton;
    Panel1: TPanel;
    TreeViewSelector: TTreeView;
    procedure btnVegatestDeleteClick(Sender: TObject);
    procedure btnVegatestNewClick(Sender: TObject);
    procedure btnVegatestNewGroupClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FormVegatestSelector: TFormVegatestSelector;

implementation

uses unitMain;

{$R *.lfm}

{ TFormVegatestSelector }

procedure TFormVegatestSelector.btnVegatestNewGroupClick(Sender: TObject);
begin
    TreeViewSelector.Items.Add(nil,'New group');
end;

procedure TFormVegatestSelector.ButtonSaveClick(Sender: TObject);
begin

  TreeViewSelector.SaveToFile(ExtractFilePath(Application.ExeName)+'qiWELLNESS.sel');
  frmMain.SelectorLoad;
  //ExtractFilePath(Application.ExeName)
  Close;
end;

procedure TFormVegatestSelector.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormVegatestSelector.FormShow(Sender: TObject);
var s: string;
begin
   //Load user veagtest selector
  s:= ExtractFilePath(Application.ExeName)+'qiWELLNESS.sel';
  if FileExists(s)then
     TreeViewSelector.LoadFromFile(s);

end;

procedure TFormVegatestSelector.btnVegatestNewClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  // Set up a simple text for each new node - Node1 , Node2 etc
  i := TreeViewSelector.Items.Count;
  s := 'New ' + inttostr(i);

  //Add a new node to the currently selected node
  if TreeViewSelector.Selected <> nil then begin
    TreeViewSelector.Items.AddChild(TreeViewSelector.Selected ,s);
    TreeViewSelector.Selected.Expand(true);
  end;

end;

procedure TFormVegatestSelector.btnVegatestDeleteClick(Sender: TObject);
    //Procedure to recursively delete nodes
    procedure DeleteNode(Node:TTreeNode);
    begin
         while Node.HasChildren do
               DeleteNode(node.GetLastChild);
         TreeViewSelector.Items.Delete(Node) ;
    end;

begin
   if TreeViewSelector.Selected = nil then  exit;

   //If selected node has child nodes, first ask for confirmation
   if TreeViewSelector.Selected.HasChildren then
      if MessageDlg( 'Delete selected group and all children?',mtConfirmation, [mbYes,mbNo],0 ) <> mrYes then
         exit;
      DeleteNode(TreeViewSelector.Selected);
end;

end.

