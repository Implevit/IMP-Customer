codeunit 50001 "IMP Administration"
{
    trigger OnRun()
    begin
    end;

    //#region PowerShell

    procedure ImportLicense()
    var
        lc_AS: Record "Active Session";
    begin
        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());
        // Import License
        ImportLicense(lc_AS."Server Instance Name", false);
    end;

    procedure ImportLicense(_ServerInstance: Text; _ReStartService: Boolean)
    var
        lc_TempBlob: Codeunit "Temp Blob";
        lc_FileMgmt: Codeunit "File Management";
        lc_PSR: DotNet PowerShellRunner;
        lc_Dia: Dialog;
        lc_FileName: Text;
        lc_FullFileName: Text;
        lc_Txt1_Txt: Label 'Operation cancelled by user.';
        lc_Txt2_Txt: Label 'Busy importing......';
        lc_FileFilter_Txt: Label 'License (*.flf)|*.flf|All Files (*.*)|*.*';
    begin
        // Get file
        lc_FileName := lc_FileMgmt.BLOBImportWithFilter(lc_TempBlob, 'Select License File', '', lc_FileFilter_Txt, '*.*');

        // Check file
        if (lc_FileName = '') then
            Error(lc_Txt1_Txt);

        // Create filename
        lc_FullFileName := TemporaryPath + lc_FileName;

        // Remove current file
        if lc_FileMgmt.ServerFileExists(lc_FullFileName) then
            lc_FileMgmt.DeleteServerFile(lc_FullFileName);

        // Store file on drive
        lc_FileMgmt.BLOBExportToServerFile(lc_TempBlob, lc_FullFileName);

        // Create powershell connection
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_PSR.ImportModule(ApplicationPath + 'NAVAdminTool.ps1');
        // Import License
        lc_PSR.AddCommand('Import-NAVServerLicense');
        lc_PSR.AddParameter('ServerInstance', _ServerInstance);
        lc_PSR.AddParameter('LicenseFile', lc_FullFileName);
        // ReStart Service
        if (_ReStartService) then begin
            lc_PSR.AddCommand('Restart-NAVServerInstance');
            lc_PSR.AddParameter('ServerInstance', _ServerInstance);
        end;

        // Extecute powershell command
        lc_PSR.BeginInvoke();

        // Show Processing
        if GuiAllowed then
            lc_Dia.Open(lc_Txt2_Txt);

        // Wait until complition
        repeat
            Sleep(1000);
        until lc_PSR.IsCompleted;

        if (GuiAllowed()) then begin
            lc_Dia.Close();
            // Show License
            lc_FileMgmt.BLOBExport(lc_TempBlob, 'License.txt', true);
        end;

        // Clean Up
        if lc_FileMgmt.ServerFileExists(lc_FullFileName) then
            lc_FileMgmt.DeleteServerFile(lc_FullFileName);
    end;

    procedure LoadServerInstacesOld()
    var
        lc_AS: Record "Active Session";
        //lc_TempBlob: Codeunit "Temp Blob";
        lc_FileMgmt: Codeunit "File Management";
        lc_PSR: DotNet PowerShellRunner;
        lc_Arr: DotNet StringArray;
        lc_Str: DotNet String;
        lc_Msg: Text;
        lc_Dia: Dialog;
        lc_FullFileName: Text;
        lc_Txt2_Txt: Label 'Processing......';
    begin
        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Create filename
        lc_FullFileName := TemporaryPath + Format(SessionId()) + '.txt';

        // Remove current file
        if lc_FileMgmt.ServerFileExists(lc_FullFileName) then
            lc_FileMgmt.DeleteServerFile(lc_FullFileName);

        // Create powershell connection
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_PSR.ImportModule(ApplicationPath.Replace('180', '170') + 'NAVAdminTool.ps1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-Misc.psm1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-BC.psm1');
        // Create powershell command
        lc_PSR.AddCommand('F-BC-LoadServerList');
        // Extecute powershell command
        lc_PSR.BeginInvoke();

        // Show Processing
        if GuiAllowed then
            lc_Dia.Open(lc_Txt2_Txt);

        // Wait until complition
        repeat
            Sleep(1000);
        until lc_PSR.IsCompleted;

        lc_Arr := lc_PSR.GetLogMessageList();

        lc_Msg := '';
        foreach lc_Str in lc_Arr do
            lc_Msg += lc_Str;

        if (GuiAllowed()) then begin
            lc_Dia.Close();
            // Show Message
            if lc_Msg <> '' then
                if (lc_Msg.Contains('ERROR:')) then
                    Error(lc_Msg)
                else
                    Message(lc_Msg);
            // Show List
            //lc_FileMgmt.BLOBImportFromServerFile(lc_TempBlob, lc_FullFileName);
            //lc_FileMgmt.BLOBExport(lc_TempBlob, 'ServerList.txt', true);
        end;
    end;

    procedure LoadVersionList() RetValue: List of [Text]
    var
        lc_AS: Record "Active Session";
        lc_File: Record "Name/Value Buffer" temporary;
        lc_List: List of [Text];
        lc_PSR: DotNet PowerShellRunner;
        lc_Dia: Dialog;
        lc_InStream: InStream;
        lc_Computer: Text;
        lc_FileName: Text;
        lc_FullFileName: Text;
        lc_Line: Text;
        lc_Txt2_Txt: Label 'Processing......';
    begin
        // Init
        Clear(RetValue);

        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            lc_Computer := lc_List.Get(1);
        end else
            lc_Computer := lc_AS."Server Computer Name";

        // FileName
        lc_FileName := 'NAVVersionList-' + lc_Computer + '.txt';
        lc_FullFileName := '\\impfps01\Daten\04_Entwicklung\Kunden\IMP\Infos\' + lc_FileName;

        // Show Dia
        if GuiAllowed then
            lc_Dia.Open(lc_Txt2_Txt);

        // Create powershell connection
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_PSR.ImportModule(ApplicationPath + 'NAVAdminTool.ps1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-Misc.psm1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-BC.psm1');
        // Create powershell command
        lc_PSR.AddCommand('F-BC-LoadVersionList');
        lc_PSR.AddParameter('FullFileName', lc_FullFileName);
        // Extecute powershell command
        lc_PSR.BeginInvoke();

        // Wait until complition
        repeat
            Sleep(1000);
        until lc_PSR.IsCompleted;

        // Load File
        lc_File.Init();
        lc_File.Name := CopyStr(lc_FullFileName, 1, MaxStrLen(lc_File.Name));
        lc_File.CalcFields("Value BLOB");
        lc_File."Value BLOB".Import(lc_FullFileName);
        if (lc_File."Value BLOB".Length <> 0) then begin
            // Import List
            lc_File."Value BLOB".CreateInStream(lc_Instream, TextEncoding::UTF16);
            while not lc_InStream.EOS() do begin
                lc_InStream.ReadText(lc_Line);
                RetValue.Add(lc_Line);
            end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();
    end;

    procedure LoadFullServerList(_WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_List: List of [Text];
        lc_Entry: Text;
        lc_Int: Integer;
        lc_Dia: Dialog;
        lc_Counter: Integer;
        lc_Confirm_Txt: Label 'Do you really want to load the full server list';
        lc_Message_Txt: Label '%1 server instances has been imported';
        lc_Dia_Txt: Label '#1############################################';
        lc_Dia1_Txt: Label 'Import list of versions';
        lc_Dia2_Txt: Label 'Import list of servers for version %1';
    begin
        // Init
        lc_Counter := 0;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(lc_Confirm_Txt) then
                exit;

        // Open Dia
        if ((_WithMessage) and (GuiAllowed())) then begin
            lc_Dia.Open(lc_Dia_Txt);
            lc_Dia.Update(1, lc_Dia1_Txt);
        end;

        // Load version list
        lc_List := LoadVersionList();

        // Loop through version list
        foreach lc_Entry in lc_List do begin
            // Show Dialog
            if ((_WithMessage) and (GuiAllowed())) then
                lc_Dia.Update(1, StrSubstNo(lc_Dia2_Txt, lc_Entry));
            // Load server list per version
            if Evaluate(lc_Int, lc_Entry) then
                lc_Counter += LoadFullServerList(lc_Int, false, false, true);
        end;

        // Close Dialog
        if ((_WithMessage) and (GuiAllowed())) then begin
            lc_Dia.Close();
            Message(lc_Message_Txt, lc_Counter);
        end;
    end;

    procedure LoadFullServerList(_Version: Integer; _WithConfirm: Boolean; _WithMessage: Boolean; _ShowDia: Boolean) RetValue: Integer
    var
        lc_AS: Record "Active Session";
        lc_File: Record "Name/Value Buffer" temporary;
        lc_SI: Record "IMP Connection";
        lc_List: List of [Text];
        lc_PSR: DotNet PowerShellRunner;
        lc_Dia: Dialog;
        lc_InStream: InStream;
        lc_Computer: Text;
        lc_FileName: Text;
        lc_FullFileName: Text;
        lc_AppPath: Text;
        lc_Line: Text;
        lc_Methode: Text;
        lc_Conf_Txt: Label 'Do you really want to load the full server list of version %1';
        lc_Msg_Txt: Label '%1 server instances has been importet';
        lc_Txt2_Txt: Label '#1############################################';
        lc_Txt2a_Txt: Label 'Create process and call %1 for version %2';
        lc_Txt2b_Txt: Label 'Import service %1';
    begin
        // Init
        RetValue := 0;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(StrSubstNo(lc_Conf_Txt, _Version)) then
                exit;

        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            lc_Computer := lc_List.Get(1);
        end else
            lc_Computer := lc_AS."Server Computer Name";

        // FileName
        lc_FileName := 'NAV' + Format(_Version) + 'Services-' + lc_Computer + '.txt';
        lc_FullFileName := '\\impfps01\Daten\04_Entwicklung\Kunden\IMP\Infos\' + lc_FileName;

        // Set current version
        if (_Version < 140) then
            lc_AppPath := 'C:\Program Files\Microsoft Dynamics NAV\' + Format(_Version) + '\Service\'
        else
            lc_AppPath := 'C:\Program Files\Microsoft Dynamics 365 Business Central\' + Format(_Version) + '\Service\';

        // Set Methode
        lc_Methode := 'F-BC-LoadFullServerList';

        // Open Dia
        if ((_ShowDia)) and (GuiAllowed()) then begin
            lc_Dia.Open(lc_Txt2_Txt);
            lc_Dia.Update(1, StrSubstNo(lc_Txt2a_Txt, lc_Methode, _Version));
        end;

        // Create powershell connection
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell        
        lc_PSR.ImportModule(lc_AppPath + 'NAVAdminTool.ps1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-Misc.psm1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-BC.psm1');
        // Create powershell command
        lc_PSR.AddCommand(lc_Methode);
        lc_PSR.AddParameter('FullFileName', lc_FullFileName);
        lc_PSR.AddParameter('Version', _Version);
        // Extecute powershell command
        lc_PSR.BeginInvoke();

        // Wait until complition
        repeat
            Sleep(1000);
        until lc_PSR.IsCompleted;

        // Load File
        lc_File.Init();
        lc_File.Name := CopyStr(lc_FullFileName, 1, MaxStrLen(lc_File.Name));
        lc_File.CalcFields("Value BLOB");
        lc_File."Value BLOB".Import(lc_FullFileName);
        if (lc_File."Value BLOB".Length <> 0) then begin
            // Clear List
            lc_SI.Reset();
            lc_SI.SetRange(Computer, lc_Computer);
            if (StrLen(Format(_Version)) > 2) then
                lc_SI.SetFilter("Service Version", '%1', CopyStr(Format(_Version), 1, 2) + '.*')
            else
                lc_SI.SetFilter("Service Version", '%1', CopyStr(Format(_Version), 1, 1) + '.*');
            if lc_SI.FindSet() then
                lc_SI.DeleteAll(true);

            // Import List
            lc_File."Value BLOB".CreateInStream(lc_Instream, TextEncoding::UTF16);
            while not lc_InStream.EOS() do begin
                lc_InStream.ReadText(lc_Line);
                Clear(lc_List);
                if lc_Line.Contains(';') then begin
                    lc_List := lc_Line.Split(';');
                    lc_SI.Init();
                    lc_SI.Computer := CopyStr(lc_List.Get(1), 1, MaxStrLen(lc_SI.Computer));
                    lc_SI."Service Name" := CopyStr(lc_List.Get(2), 1, MaxStrLen(lc_SI."Service Name"));
                    lc_SI."Service State" := CopyStr(lc_List.Get(3), 1, MaxStrLen(lc_SI."Service State"));
                    lc_SI."Service Account" := CopyStr(lc_List.Get(4), 1, MaxStrLen(lc_SI."Service Account"));
                    lc_SI."Service Version" := CopyStr(lc_List.Get(5), 1, MaxStrLen(lc_SI."Service Version"));
                    Evaluate(lc_SI.ManagementServicesPort, lc_List.Get(6));
                    Evaluate(lc_SI.ClientServicesPort, lc_List.Get(7));
                    Evaluate(lc_SI.SOAPServicesPort, lc_List.Get(8));
                    Evaluate(lc_SI.ODataServicesPort, lc_List.Get(9));
                    lc_SI.DatabaseServer := CopyStr(lc_List.Get(10), 1, MaxStrLen(lc_SI.DatabaseServer));
                    lc_SI.DatabaseInstance := CopyStr(lc_List.Get(11), 1, MaxStrLen(lc_SI.DatabaseInstance));
                    lc_SI.DatabaseName := CopyStr(lc_List.Get(12), 1, MaxStrLen(lc_SI.DatabaseName));
                    if lc_SI.Insert(true) then
                        RetValue += 1;
                    // Open Dia
                    if ((_ShowDia)) and (GuiAllowed()) then
                        lc_Dia.Update(1, StrSubstNo(lc_Txt2b_Txt, lc_SI."Service Name"));
                end;
            end;
        end;

        // Close Dia
        if ((_WithMessage)) and (GuiAllowed()) then begin
            lc_Dia.Close();
            Message(lc_Msg_Txt, RetValue);
        end;
    end;

    procedure LoadSimpleServerList()
    var
        lc_AS: Record "Active Session";
        lc_File: Record "Name/Value Buffer" temporary;
        lc_SI: Record "IMP Connection";
        lc_SITemp: Record "IMP Connection" temporary;
        lc_List: List of [Text];
        lc_PSR: DotNet PowerShellRunner;
        lc_Dia: Dialog;
        lc_InStream: InStream;
        lc_Computer: Text;
        lc_FileName: Text;
        lc_FullFileName: Text;
        lc_Line: Text;
        lc_CrLf: Text;
        lc_Msg: Text;
        lc_Txt2_Txt: Label 'Processing......';
    begin
        // Init
        lc_CrLf[1] := 13;
        lc_CrLf[2] := 10;

        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            lc_Computer := lc_List.Get(1);
        end else
            lc_Computer := lc_AS."Server Computer Name";

        // FileName
        lc_FileName := 'NAVSimpleServices-' + lc_Computer + '.txt';
        lc_FullFileName := '\\impfps01\Daten\04_Entwicklung\Kunden\IMP\Infos\' + lc_FileName;

        // Create powershell connection
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_PSR.ImportModule(ApplicationPath + 'NAVAdminTool.ps1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-Misc.psm1');
        lc_PSR.ImportModule('\\impent01\Tools\PowerShell\Library\Functions-BC.psm1');
        // Create powershell command
        lc_PSR.AddCommand('F-BC-LoadSimpleServerList');
        lc_PSR.AddParameter('FullFileName', lc_FullFileName);
        // Extecute powershell command
        lc_PSR.BeginInvoke();

        // Show Dia
        if GuiAllowed then
            lc_Dia.Open(lc_Txt2_Txt);

        // Wait until complition
        repeat
            Sleep(1000);
        until lc_PSR.IsCompleted;

        // Load File
        lc_File.Init();
        lc_File.Name := CopyStr(lc_FullFileName, 1, MaxStrLen(lc_File.Name));
        lc_File.CalcFields("Value BLOB");
        lc_File."Value BLOB".Import(lc_FullFileName);
        if (lc_File."Value BLOB".Length <> 0) then begin
            // Clear List
            lc_SITemp.DeleteAll(true);
            lc_SI.Reset();
            lc_SI.SetRange(Computer, lc_Computer);
            if lc_SI.FindSet() then
                lc_SI.DeleteAll(true);

            // Import List
            lc_File."Value BLOB".CreateInStream(lc_Instream, TextEncoding::UTF16);
            while not lc_InStream.EOS() do begin
                lc_InStream.ReadText(lc_Line);
                Clear(lc_List);
                if lc_Line.Contains(';') then begin
                    lc_List := lc_Line.Split(';');
                    lc_SI.Init();
                    lc_SI.Computer := CopyStr(lc_List.Get(1), 1, MaxStrLen(lc_SI.Computer));
                    lc_SI."Service Name" := CopyStr(lc_List.Get(2), 1, MaxStrLen(lc_SI."Service Name"));
                    lc_SI."Service State" := CopyStr(lc_List.Get(3), 1, MaxStrLen(lc_SI."Service State"));
                    lc_SI."Service Account" := CopyStr(lc_List.Get(4), 1, MaxStrLen(lc_SI."Service Account"));
                    lc_SI."Service Version" := CopyStr(lc_List.Get(5), 1, MaxStrLen(lc_SI."Service Version"));
                    lc_SI.Insert(true);
                    // Add Version 
                    lc_SITemp.Init();
                    lc_SITemp.Computer := lc_SI.Computer;
                    if lc_SI."Service Version".Contains('.') then begin
                        lc_List := lc_SI."Service Version".Split('.');
                        lc_SITemp."Service Name" := CopyStr(lc_List.Get(1) + lc_List.Get(2), 1, MaxStrLen(lc_SI.Computer));
                    end else
                        lc_SITemp."Service Name" := lc_SI."Service Version";
                    if lc_SITemp.Insert(true) then;
                end;
            end;

            lc_Msg := Format(lc_SITemp.Count) + '\\';
            if lc_SITemp.Find('-') then
                repeat
                    lc_Msg += '\' + lc_SITemp.Computer + '.' + lc_SITemp."Service Name";
                until lc_SITemp.Next() = 0;

            Message(lc_Msg);

            //DownloadFromStream(lc_InStream, 'Export', '', '', lc_FileName);
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();
    end;

    procedure CallServerList(_Version: Text);
    var
        lc_Int: Integer;
    begin
        if Evaluate(lc_Int, _Version.Replace('.', '')) then
            CallServerList(lc_Int);
    end;

    procedure CallServerList(_Version: Integer);
    var
        lc_AS: Record "Active Session";
        lc_IC: Record "IMP Connection";
        lc_List: List of [Text];
        lc_PSR: DotNet PowerShellRunner;
        lc_Dia: Dialog;
        lc_Computer: Text;
        lc_URL: Text;
        lc_AdminTool: Text;
        lc_Txt1_Txt: Label '#1###########################';
        lc_Txt2_Txt: Label 'Start call for %1 services at %2';
        lc_Txt3_Txt: Label 'Process call for %1 services at %2';
    begin
        // Admin Tool
        if (_Version <= 110) then
            lc_AdminTool := 'C:\Program Files\Microsoft Dynamics NAV\' + Format(_Version) + '\Service\NAVAdminTool.ps1'
        else
            lc_AdminTool := 'C:\Program Files\Microsoft Dynamics 365 Business Central\' + Format(_Version) + '\Service\NAVAdminTool.ps1';

        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            lc_Computer := lc_List.Get(1);
        end else
            lc_Computer := lc_AS."Server Computer Name";

        // Get connection
        lc_IC.Reset();
        lc_IC.SetCurrentKey("List Name");
        lc_IC.SetRange("List Name", lc_AS."Server Instance Name");
        if lc_IC.FindFirst() then
            lc_URL := lc_IC.GetUrlOdata().Replace('impent02', 'impent01')
        else
            lc_URL := 'http://impent01.imp.local:8348/IMP-BC180-PROD/';
        if not lc_URL.EndsWith('/') then
            lc_URL += '/';
        lc_URL += 'ODataV4/IMPWebService_odata?Company=' + '''' + CompanyName + '''';

        // Open Dia
        if GuiAllowed then begin
            lc_Dia.Open(lc_Txt1_Txt);
            lc_Dia.Update(1, StrSubstNo(lc_Txt2_Txt, _Version, lc_Computer));
        end;

        Clear(lc_PSR);
        // Create powershell connection
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_PSR.ImportModule(lc_AdminTool);
        lc_PSR.ImportModule('\\impfps01\Daten\04_Entwicklung\Kunden\IMP\PS\AdminFunctions.ps1');
        // Create powershell command
        lc_PSR.AddCommand('F-LoadNAVServicesAndSendToWebService');
        lc_PSR.AddParameter('Version', _Version);
        lc_PSR.AddParameter('URL', lc_URL);
        lc_PSR.AddParameter('Username', 'IMPL');
        lc_PSR.AddParameter('Password', 'Welcome2019');
        // Extecute powershell command
        lc_PSR.BeginInvoke();

        // Show Dia
        if GuiAllowed then
            lc_Dia.Update(1, StrSubstNo(lc_Txt3_Txt, _Version, lc_Computer));

        // Wait until complition
        repeat
            Sleep(1000);
        until lc_PSR.IsCompleted;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();
    end;

    //#endregion PowerShell

}