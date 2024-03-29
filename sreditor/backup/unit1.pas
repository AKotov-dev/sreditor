unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Process, FileUtil, DefaultTranslator;

type

  { TMainForm }

  TMainForm = class(TForm)
    Label1: TLabel;
    DevListBox: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    AddBtn: TSpeedButton;
    AboutBtn: TSpeedButton;
    StaticText1: TStaticText;
    UpdateBtn: TSpeedButton;
    DefaultBtn: TSpeedButton;
    procedure AddBtnClick(Sender: TObject);
    procedure DevListBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure UpdateBtnClick(Sender: TObject);
    procedure DefaultBtnClick(Sender: TObject);
    procedure StartScan;
    procedure UdevReload;
    procedure RestoreDefault;

  private

  public

  end;

resourcestring
  SNoAction = 'The device is already in the list of rules. No action is needed.';
  SFileNotFound =
    'The main rules file was not found:' + #10#13 +
    '/lib/udev/rules.d/60-libsane.rules or ' + #10#13 +
    '/usr/lib/udev/rules.d/60-libsane.rules!';
  SNoDevices = 'No devices were found...';
  SRestoreDefault = 'Your changes will be reset! Continue?';
  SReconnectDevice = 'Restart your computer.';

var
  MainForm: TMainForm;

  //Основной конфиг 60-libsane.rules (ROSA/Mageia - разный путь)
  config: string;

implementation

uses Udev_TRD, About_Unit;

{$R *.lfm}

{ TMainForm }

//Restore Default
procedure TMainForm.RestoreDefault;
begin
  UdevReload;
  UpdateBtn.Click;
end;

//udev reload
procedure TMainForm.UdevReload;
var
  FUdevReloadThread: TThread;
begin
  //Запуск потока udev
  FUdevReloadThread := StartUdevReload.Create(False);
  FUdevReloadThread.Priority := tpNormal;
end;

//StartScan (Update usb-devices list)
procedure TMainForm.StartScan;
var
  ExProcess: TProcess;
begin
  ExProcess := TProcess.Create(nil);
  try
    ExProcess.Executable := 'bash';
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add(
      'lsusb | grep -vE "hub|Hub|Reader|Keyboard|Mouse|VirtualBox"');
    ExProcess.Options := [poUsePipes, poStderrToOutPut];
    ExProcess.Execute;

    DevListBox.Items.LoadFromStream(ExProcess.Output);

    if DevListBox.Count <> 0 then
    begin
      DevListBox.ItemIndex := 0;
      DevListBox.Click;
    end
    else
    begin
      Memo2.Text := SNoDevices;
      AddBtn.Enabled := False;
    end;

  finally
    ExProcess.Free;
  end;
end;

procedure TMainForm.UpdateBtnClick(Sender: TObject);
begin
  Memo1.Lines.LoadFromFile('/etc/udev/rules.d/60-libsane.rules');
  StartScan;
end;

//Resore Default
procedure TMainForm.DefaultBtnClick(Sender: TObject);
begin
  if MessageDlg(SRestoreDefault, mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    //Copy Default rules
    CopyFile(config, '/etc/udev/rules.d/60-libsane.rules', [cffOverwriteFile]);

    Application.ProcessMessages;
    RestoreDefault;
  end;
end;

//Есть ли основной файл правил? Нет - Выход! (ROSA/Mageia)
procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Определяем путь к правилам
  config := '';
  if FileExists('/usr/lib/udev/rules.d/60-libsane.rules') then
    config := '/usr/lib/udev/rules.d/60-libsane.rules'
  else
  if FileExists('/lib/udev/rules.d/60-libsane.rules') then
    config := '/lib/udev/rules.d/60-libsane.rules';

  //Если правил нет - отбой
  if config = '' then
  begin
    MessageDlg(SFileNotFound, mtError, [mbOK], 0);
    Application.Terminate;
  end
  else
  //Если default ещё не копировался - копируем
  if not FileExists('/etc/udev/rules.d/60-libsane.rules') then
    CopyFile(config, '/etc/udev/rules.d/60-libsane.rules', [cffOverwriteFile]);

  MainForm.Caption := Application.Title;
end;

//Загружаем файл 60-libsane.rules и перечитываем устройства
procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateBtn.Click;
end;

//О программе
procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutForm := TAboutForm.Create(Self);
  AboutForm.ShowModal;
end;

//Поиск idVerndor:idProduct и установка курсора + select
procedure TMainForm.DevListBoxClick(Sender: TObject);
var
  v: integer;
  idVendor, idProduct, Description: string;
begin
  if DevListBox.Count = 0 then
    Exit;

  idVendor := '"' + Copy(DevListBox.Items[DevListBox.ItemIndex], 24, 4) + '"';
  idProduct := '"' + Copy(DevListBox.Items[DevListBox.ItemIndex], 29, 4) + '"';
  Description := Copy(DevListBox.Items[DevListBox.ItemIndex], 34,
    Length(DevListBox.Items[DevListBox.ItemIndex]));

  //Ищем значения вендора и продукт
  v := Pos('ATTRS{idVendor}==' + idVendor + ', ' + 'ATTRS{idProduct}==' +
    idProduct, Memo1.Text);

  if v <> 0 then
  begin
    Memo2.Text := SNoAction;
    Memo1.SelStart := v - 1;
    Memo1.SelLength := Length(Memo1.Lines[Memo1.CaretPos.Y]) + 1;
    AddBtn.Enabled := False;
  end
  else
  begin
    Memo2.Clear;
    Memo2.Lines.Add('# ' + Description);
    Memo2.Lines.Add('ATTRS{idVendor}==' + idVendor + ', ' +
      'ATTRS{idProduct}==' + idProduct +
      ', MODE="0644", GROUP="usb", ENV{libsane_matched}="yes"');
    Memo1.SelStart := 0;
    AddBtn.Enabled := True;
  end;
end;

//Добавляем правила устройства
procedure TMainForm.AddBtnClick(Sender: TObject);
begin
  //Insert Rule
  with Memo1 do
  begin
    SetFocus;
    SelStart := Pos('# The following rule will disable USB autosuspend for the device',
      Text);
    //Lines.Insert(CaretPos.Y - 1, '');
    Lines.Insert(CaretPos.Y + 0, Memo2.Lines[0]);
    Lines.Insert(CaretPos.Y + 1, Memo2.Lines[1]);
    Lines.Insert(CaretPos.Y + 2, '');
  end;
  //Сохраняем новые правила
  Memo1.Lines.SaveToFile('/etc/udev/rules.d/60-libsane.rules');

  //Курсор и Select
  DevListBox.Click;

  //Перименяем новые правила
  UdevReload;

  MessageDlg(SReconnectDevice, mtInformation, [mbOK], 0);
end;

end.
