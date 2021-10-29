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

    procedure AddFileNameToPowerShellPath(_FileName: Text) RetValue: Text
    begin
        RetValue := '\\impfps01\Daten\04_Entwicklung\Kunden\IMP\PS\' + _FileName;
    end;

    procedure AddFileNameToInfoPath(_FileName: Text) RetValue: Text
    begin
        RetValue := '\\impfps01\Daten\04_Entwicklung\Kunden\IMP\Infos\' + _FileName;
    end;

    /*
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
        if ImpMgmt.ImportFile(lc_FullFileName, lc_InStream, TextEncoding::UTF16, true) then begin
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
        if ImpMgmt.ImportFile(lc_FullFileName, lc_InStream, TextEncoding::UTF16, true) then begin
            // Clear List
            lc_SITemp.DeleteAll(true);
            lc_SI.Reset();
            lc_SI.SetRange(Computer, lc_Computer);
            if lc_SI.FindSet() then
                lc_SI.DeleteAll(true);

            // Import List
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
                        lc_SITemp."Service Name" := CopyStr(lc_List.Get(1) + lc_List.Get(2), 1, MaxStrLen(lc_SI."Service Name"));
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

    procedure LoadVersionList(_Server: Text)
    var
        lc_AS: Record "Active Session";
        lc_IC: Record "IMP Connection";
        lc_IA: Record "IMP Authorisation";
        lc_DatMgmt: Codeunit "IMP Data Management";
        lc_Conv: Codeunit "Base64 Convert";
        lc_Object: JsonObject;
        lc_RequestText: Text;
        lc_Url: Text;
    begin
        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get connection
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Computer, "Service Name", "Company Name");
        lc_IC.SetRange("Service Name", lc_AS."Server Instance Name");
        lc_IC.SetRange(Computer, _Server);
        lc_IC.FindFirst();

        // Get authorisation
        lc_IA.Get(lc_IC."Authorisation No.");

        // Set url
        lc_Url := lc_IC.GetUrlOdataService(CompanyName);

        // Call Odata
        clear(lc_Object);
        lc_Object.Add('data', 'LoadVersions');
        lc_Object.Add('companyName', CompanyName);
        lc_Object.Add('computer', _Server);
        lc_Object.WriteTo(lc_RequestText);
        lc_RequestText := lc_Conv.ToBase64(lc_RequestText, TextEncoding::UTF16);
        clear(lc_Object);
        lc_Object.Add('json', lc_RequestText);
        lc_Object.WriteTo(lc_RequestText);
        lc_DatMgmt.APIPost(lc_Url, lc_RequestText, lc_Object, lc_IA.Name, 'Welcome2019$', lc_IA.Token, lc_IA."Client Id", lc_IA."Secret Id", true);
    end;
    */

    procedure CallSQLServerFullList()
    var
        lc_Response: JsonObject;
    begin
        CallSQLServerFullList('IMPSQL01', '', lc_Response);
    end;

    procedure CallSQLServerFullList(_Server: Text; _Instance: Text; var _Response: JsonObject)
    var
        lc_IC: Record "IMP Connection";
        lc_PSR: DotNet PowerShellRunner;
        lc_Response: JsonObject;
        lc_Dia: Dialog;
        lc_URL: Text;
        lc_File: Text;
        lc_IsFile: Boolean;
        lc_ResponseText: Text;
        lc_Txt1_Txt: Label '#1###########################';
        lc_Txt2_Txt: Label 'Start call for sqlserver full list from %1';
        lc_Txt3_Txt: Label 'Process call for sqlserver full list form %1';
    begin
        // Init
        lc_IsFile := true;
        lc_ResponseText := '';

        // Check server
        if (_Server = '') then begin
            _Response.Add('error', 'Server is mandatory');
            exit;
        end;

        // Set file
        lc_File := AddFileNameToInfoPath(_Server + '_SQLServerFullList.json');

        // Open Dia
        if (GuiAllowed()) then begin
            lc_Dia.Open(lc_Txt1_Txt);
            lc_Dia.Update(1, StrSubstNo(lc_Txt2_Txt, _Server));
        end;

        Clear(lc_PSR);
        // Create powershell connection
        lc_Dia.Update(1, 'Create Powershell Sandbox');
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_Dia.Update(1, 'Add SQLServer');
        lc_Dia.Update(1, 'Add AdminFunctions.ps1');
        lc_PSR.ImportModule(AddFileNameToPowerShellPath('AdminFunctions.ps1'));
        // Create powershell command
        if (lc_IsFile) then begin
            lc_Dia.Update(1, 'Load Function F-LoadSQLServerFullIntoFile');
            lc_PSR.AddCommand('F-LoadSQLServerFullIntoFile');
            lc_PSR.AddParameter('Server', _Server);
            lc_PSR.AddParameter('Instance', _Instance);
            lc_PSR.AddParameter('FullFileName', lc_File);
        end else begin
            lc_Dia.Update(1, 'Load Function F-LoadSQLServerFullSendToWebService');
            lc_PSR.AddCommand('F-LoadSQLServerFullSendToWebService');
            lc_PSR.AddParameter('Server', _Server);
            lc_PSR.AddParameter('Instance', _Instance);
            lc_PSR.AddParameter('URL', lc_URL);
            lc_PSR.AddParameter('Username', 'IMPL');
            lc_PSR.AddParameter('Password', 'Welcome2019');
        end;
        // Extecute powershell command
        lc_Dia.Update(1, 'Invoke Command');
        lc_PSR.BeginInvoke();

        // Show Dia
        if (GuiAllowed()) then
            lc_Dia.Update(1, StrSubstNo(lc_Txt3_Txt, _Server));

        // Wait for complition
        if not (lc_PSR.IsCompleted) then begin
            lc_Dia.Update(1, 'Wait for completion');
            repeat
                Sleep(1000);
            until lc_PSR.IsCompleted;
        end;

        // Read file
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Import file');
            // Import file
            lc_ResponseText := ImpMgmt.ImportFile(lc_File, TextEncoding::UTF16, false);
            // Transfer to json
            if not lc_Response.ReadFrom(lc_ResponseText) then
                Message('No json format:\\' + lc_ResponseText)
            else begin
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Import file content');
                // Import content
                lc_IC.ImportSQLServerFull(lc_Response, _Response);
                // Show finished
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Content imported');
            end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();
    end;

    procedure CallVersionList() RetValue: Boolean;
    var
        lc_AS: Record "Active Session";
        lc_Request: JsonObject;
        lc_Response: JsonObject;
        lc_Token: JsonToken;
        lc_List: List of [Text];
        lc_Computer: Text;
    begin
        // Init
        RetValue := false;

        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            lc_Computer := lc_List.Get(1);
        end else
            lc_Computer := lc_AS."Server Computer Name";

        // Create request
        lc_Request.Add('data', 'LoadVersions');
        lc_Request.Add('companyName', CompanyName);
        lc_Request.Add('computer', lc_Computer);

        // Call 
        CallVersionList(lc_Request, lc_Response);

        // Show error
        if lc_Request.Get('error', lc_Token) then
            Error(lc_Token.AsValue().AsText())
        else
            Message('Versionlist importet for the server %1', lc_Computer);

        // Return
        RetValue := true;
    end;

    procedure CallVersionList(_Request: JsonObject; var _Response: JsonObject)
    var
        lc_IC: Record "IMP Connection";
        lc_IS: Record "IMP Server";
        //lc_User: Record User;
        lc_Token: JsonToken;
        lc_PSR: DotNet PowerShellRunner;
        lc_Dia: Dialog;
        lc_Computer: Text;
        lc_URL: Text;
        lc_File: Text;
        lc_AdminTool: Text;
        lc_CompanyName: Text;
        lc_IsFile: Boolean;
        lc_ResponseText: Text;
        lc_Txt1_Txt: Label '#1###########################';
        lc_Txt2_Txt: Label 'Start call for version list from %1';
        lc_Txt3_Txt: Label 'Process call for version list form %1';
    begin
        // Init
        lc_IsFile := true;
        lc_ResponseText := '';

        // Check request companyname
        if not _Request.Get('companyName', lc_Token) then begin
            _Response.Add('error', 'Token companyName is mandatory');
            exit;
        end else
            lc_CompanyName := lc_Token.AsValue().AsText();

        // Check request companyname
        if not _Request.Get('computer', lc_Token) then begin
            _Response.Add('error', 'Token computer is mandatory');
            exit;
        end else
            lc_Computer := lc_Token.AsValue().AsText();

        // Admin Tool
        lc_AdminTool := 'C:\Program Files\Microsoft Dynamics 365 Business Central\140\Service\NAVAdminTool.ps1';

        // Get computer
        lc_Computer := ImpAdmin.GetCurrentComputerName();

        // Set url
        lc_URL := lc_IC.GetUrlOdataIMPProd(CompanyName);

        // Set file
        lc_File := AddFileNameToInfoPath(lc_Computer + '_NAVVersionList.json');

        // Get User
        //lc_User.Get('IMPL');

        // Open Dia
        if (GuiAllowed()) then begin
            lc_Dia.Open(lc_Txt1_Txt);
            lc_Dia.Update(1, StrSubstNo(lc_Txt2_Txt, lc_Computer));
        end;

        Clear(lc_PSR);
        // Create powershell connection
        lc_Dia.Update(1, 'Create Powershell Sandbox');
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        lc_Dia.Update(1, 'Add NAVAdminTool.ps1');
        lc_PSR.ImportModule(lc_AdminTool);
        lc_Dia.Update(1, 'Add AdminFunctions.ps1');
        lc_PSR.ImportModule(AddFileNameToPowerShellPath('AdminFunctions.ps1'));
        // Create powershell command
        if (lc_IsFile) then begin
            lc_Dia.Update(1, 'Load Function F-LoadNAVVersionsIntoFile');
            lc_PSR.AddCommand('F-LoadNAVVersionsIntoFile');
            lc_PSR.AddParameter('FullFileName', lc_File);
        end else begin
            lc_Dia.Update(1, 'Load Function F-LoadNAVVersionsAndSendToWebService');
            lc_PSR.AddCommand('F-LoadNAVVersionsAndSendToWebService');
            lc_PSR.AddParameter('CompanyName', lc_CompanyName);
            lc_PSR.AddParameter('URL', lc_URL);
            lc_PSR.AddParameter('Username', 'IMPL');
            lc_PSR.AddParameter('Password', 'Welcome2019');
        end;
        // Extecute powershell command
        lc_Dia.Update(1, 'Invoke Command');
        lc_PSR.BeginInvoke();

        // Show Dia
        if (GuiAllowed()) then
            lc_Dia.Update(1, StrSubstNo(lc_Txt3_Txt, lc_Computer));

        // Wait for complition
        if not (lc_PSR.IsCompleted) then begin
            lc_Dia.Update(1, 'Wait for completion');
            repeat
                Sleep(1000);
            until lc_PSR.IsCompleted;
        end;

        // Read file
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Import file');
            // Import file
            lc_ResponseText := ImpMgmt.ImportFile(lc_File, TextEncoding::UTF16, true);
            // Transfer to json
            if not _Request.ReadFrom(lc_ResponseText) then
                Message('No json format:\\' + lc_ResponseText)
            else begin
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Import file content');
                // Import content
                lc_IS.Get(lc_Computer);
                lc_IS.NAVVersionsImport(_Request, _Response);
                // Show finished
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Content imported');
            end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();
    end;

    procedure CallServerLists(_WithConfirm: Boolean; _WithMessage: Boolean);
    var
        lc_IC: Record "IMP Connection";
        lc_IS: Record "IMP Server";
        lc_List: List of [Text];
        lc_Entry: Text;
        lc_Int: Integer;
        lc_Computer: Text;
        lc_Conf_Txt: Label 'Do you really want to import selected versions of server instances from the server %1?';
        lc_Msg_Txt: Label 'All selected versions of server instances has been imported from the server %1';
    begin
        // Get computer
        lc_Computer := ImpAdmin.GetCurrentComputerName();

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(StrSubstNo(lc_Conf_Txt, lc_Computer)) then
                exit;

        // Get server
        lc_IC.Reset();
        lc_IC.SetRange(Environment, lc_IC.Environment::Server);
        lc_IC.SetFilter("Environment Name", '%1', '@' + lc_Computer);
        lc_IC.FindFirst();
        lc_IC.TestField("Environment Id");

        // Call selection
        lc_List := lc_IS.NAVVersionsSelect(false);

        // Loop through selected versions
        foreach lc_Entry in lc_List do
            if Evaluate(lc_Int, lc_Entry.Replace('.', '')) then
                CallServerList(lc_Int, false, false);

        // Show Message
        if ((_WithMessage) and (GuiAllowed())) then
            Message(lc_Msg_Txt, lc_Computer);
    end;

    procedure CallServerList(_Version: Integer; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_IC: Record "IMP Connection";
        lc_PSR: DotNet PowerShellRunner;
        lc_Request: JsonObject;
        lc_Response: JsonObject;
        lc_Dia: Dialog;
        lc_URL: Text;
        lc_AdminTool: Text;
        lc_IsFile: Boolean;
        lc_Computer: Text;
        lc_File: Text;
        lc_ResponseText: Text;
        lc_Version: Text;
        lc_Conf_Txt: Label 'Do you really want to import all server instances from the server %1 of the version %2?';
        lc_Msg_Txt: Label 'All server instances has been imported from the server %1 of the version %2';
        lc_Txt1_Txt: Label '#1###########################';
    begin
        // Init 
        lc_IsFile := true;

        // Admin tool
        if (_Version <= 110) then
            lc_AdminTool := 'C:\Program Files\Microsoft Dynamics NAV\' + Format(_Version) + '\Service\NAVAdminTool.ps1'
        else
            lc_AdminTool := 'C:\Program Files\Microsoft Dynamics 365 Business Central\' + Format(_Version) + '\Service\NAVAdminTool.ps1';

        // Set version
        if (_Version < 100) then
            lc_Version := CopyStr(Format(_Version), 1, 1) + '.' + CopyStr(Format(_Version), 2, 1)
        else
            lc_Version := CopyStr(Format(_Version), 1, 2) + '.' + CopyStr(Format(_Version), 3, 1);

        // Get computer
        lc_Computer := ImpAdmin.GetCurrentComputerName();

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(StrSubstNo(lc_Conf_Txt, lc_Computer, lc_Version)) then
                exit;

        // Set url
        lc_URL := lc_IC.GetUrlOdataIMPProd(CompanyName);

        // Set file
        lc_File := AddFileNameToInfoPath(lc_Computer + '_NAVServerList_' + Format(_Version) + '.json');

        // Open Dia
        if GuiAllowed then
            lc_Dia.Open(lc_Txt1_Txt);

        Clear(lc_PSR);
        // Create powershell connection
        if (GuiAllowed()) then
            lc_Dia.Update(1, lc_Version + ' Create Powershell Sandbox');
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        if (GuiAllowed()) then
            lc_Dia.Update(1, lc_Version + ' Add NAVAdminTool.ps1');
        lc_PSR.ImportModule(lc_AdminTool);
        if (GuiAllowed()) then
            lc_Dia.Update(1, lc_Version + ' Add AdminFunctions.ps1');
        lc_PSR.ImportModule(AddFileNameToPowerShellPath('AdminFunctions.ps1'));
        // Create powershell command
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, lc_Version + ' Call Function F-LoadNAVServicesIntoFile');
            lc_PSR.AddCommand('F-LoadNAVServicesIntoFile');
            lc_PSR.AddParameter('Version', _Version);
            lc_PSR.AddParameter('FullFileName', lc_File);
        end else begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, lc_Version + ' Call Function F-LoadNAVServicesIntoFile');
            lc_PSR.AddCommand('F-LoadNAVServicesAndSendToWebService');
            lc_PSR.AddParameter('Version', _Version);
            lc_PSR.AddParameter('URL', lc_URL);
            lc_PSR.AddParameter('Username', 'IMPL');
            lc_PSR.AddParameter('Password', 'Welcome2019');
        end;
        // Extecute powershell command
        if (GuiAllowed()) then
            lc_Dia.Update(1, lc_Version + ' Invoke command: get service list');
        lc_PSR.BeginInvoke();

        // Wait for complition
        if not (lc_PSR.IsCompleted) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, lc_Version + ' Wait for completion');
            repeat
                Sleep(1000);
            until lc_PSR.IsCompleted;
        end;

        // Read file
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, lc_Version + ' Import file');
            // Import file
            lc_ResponseText := ImpMgmt.ImportFile(lc_File, TextEncoding::UTF16, true);
            // Transfer to json
            if not lc_Request.ReadFrom(lc_ResponseText) then
                Message('No json format:\\' + lc_ResponseText)
            else begin
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, lc_Version + ' Import content');
                // Import content
                lc_IC.ImportServerInstances(lc_Request, lc_Response);
                // Show finished
                if (GuiAllowed()) then
                    lc_Dia.Update(1, lc_Version + ' Content imported');
            end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();

        // Show Message
        if ((_WithMessage) and (GuiAllowed())) then
            Message(lc_Msg_Txt, lc_Computer, lc_Version);
    end;

    procedure CallServerDetailEdit(var _IC: Record "IMP Connection")
    var
        lc_Rec: Record "Name/Value Buffer" temporary;
        lc_Page: Page "IMP Selection List";
        lc_Response: JsonObject;
        lc_Services: JsonArray;
        lc_Service: JsonToken;
        lc_Keys: JsonArray;
        lc_Key: JsonToken;
        lc_Token: JsonToken;
        lc_Fields: List of [Integer];
        lc_FullFileName: Text;
        lc_EntryNo: Integer;
    begin
        //{
        //"data":  "ServerInstance",
        //"server":  "IMPENT01",
        //"dns":  "IMPENT01.imp.local",
        //"services":  [
        //                 {
        //                     "environmentid":  "",
        //                     "environmenttype":  "OnPrem",
        //                     "state":  "Running",
        //                     "environment":  "Server",
        //                     "version":  "14.0",
        //                     "environmentname":  "IMPENT01",
        //                     "environmentstate":  "Running",
        //                     "name":  "DynamicsBC140",
        //                     "keys":  [
        //                                  {
        //                                      "key":  "AllowSessionWhileSyncAndDataUpgrade",
        //                                      "value":  "false"
        //                                  },

        // Call detail
        CallServerDetail(_IC, lc_Response, lc_FullFileName);

        // Show error
        if (lc_Response.Get('error', lc_Token)) then begin
            Message(BscMgmt.JsonGetTokenValue(lc_Token, 'error').AsText());
            exit;
        end;

        // Check services
        if not (lc_Response.Get('services', lc_Token)) then begin
            Message('Token "services" missing');
            exit;
        end else
            if not lc_Token.IsArray() then begin
                Message('Token "services" has to be an array');
                exit;
            end else
                lc_Services := lc_Token.AsArray();

        // Init process
        lc_Rec.Reset();
        lc_Rec.DeleteAll();
        lc_EntryNo := 0;
        Clear(lc_Fields);

        // Load services
        //foreach lc_Service in lc_Services do begin
        if lc_Services.Get(0, lc_Service) then begin
            // environment
            if (lc_Service.AsObject().Get('environment', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'environment';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environment').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // environmentid
            if (lc_Service.AsObject().Get('environmentid', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'environmentid';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentid').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // "environmenttype"
            if (lc_Service.AsObject().Get('environmenttype', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'environmenttype';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmenttype').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // environmentname
            if (lc_Service.AsObject().Get('environmentname', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'environmentname';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentname').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // environmentstate
            if (lc_Service.AsObject().Get('environmentstate', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'environmentstate';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentstate').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // name
            if (lc_Service.AsObject().Get('name', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'name';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // version
            if (lc_Service.AsObject().Get('version', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'version';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // state
            if (lc_Service.AsObject().Get('state', lc_Token)) then begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := 'state';
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'state').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
            // Check keys
            if not (lc_Service.AsObject().Get('keys', lc_Token)) then begin
                Message('Token "keys" missing');
                exit;
            end else
                if not lc_Token.IsArray() then begin
                    Message('Token "keys" has to be an array');
                    exit;
                end else
                    lc_Keys := lc_Token.AsArray();
            // Process keys
            foreach lc_Key in lc_Keys do begin
                lc_EntryNo += 1;
                lc_Rec.Init();
                lc_Rec.ID := lc_EntryNo;
                lc_Rec.Name := CopyStr(BscMgmt.JsonGetTokenValue(lc_Key, 'key').AsText(), 1, MaxStrLen(lc_Rec.Name));
                lc_Rec."Value Long" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Key, 'value').AsText(), 1, MaxStrLen(lc_Rec."Value Long"));
                lc_Rec.Insert(true);
            end;
        end;

        // Show data
        lc_Fields.Add(lc_Rec.FieldNo(Name));
        lc_Fields.Add(lc_Rec.FieldNo("Value Long"));

        lc_Page.HideAllEntries();
        lc_Page.SetFields(lc_Fields, false, true);
        lc_Page.SetEditable(lc_Rec.FieldNo("Value Long"), true);
        lc_Page.SetData(lc_Rec);
        lc_Page.LookupMode := true;
        lc_Page.Run();
    end;

    procedure CallServerDetail(var _IC: Record "IMP Connection")
    var
        lc_Response: JsonObject;
        lc_FullFileName: Text;
    begin
        CallServerDetail(_IC, lc_Response, lc_FullFileName);
        BscMgmt.JsonExport(FileMgmt.GetFileName(lc_FullFileName), lc_Response);
    end;

    procedure CallServerDetail(var _IC: Record "IMP Connection"; var _Response: JsonObject; var _FullFileName: Text)
    var
        lc_PSR: DotNet PowerShellRunner;
        lc_Request: JsonObject;
        lc_Dia: Dialog;
        lc_URL: Text;
        lc_AdminTool: Text;
        lc_IsFile: Boolean;
        lc_Computer: Text;
        lc_ResponseText: Text;
        lc_Version: Text;
        lc_IntVersion: Integer;
        lc_Txt1_Txt: Label '#1###########################';
    begin
        // Init 
        lc_IsFile := true;

        // Get powershell settings
        _IC.GetPS(_IC, lc_IntVersion, lc_Version, lc_AdminTool, lc_Computer, lc_URL);

        // Set file
        _FullFileName := AddFileNameToInfoPath(lc_Computer + '_NAVServer_' + _IC."Service Name" + '.json');

        // Open Dia
        if GuiAllowed then
            lc_Dia.Open(lc_Txt1_Txt);

        Clear(lc_PSR);
        // Create powershell connection
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Create Powershell Sandbox');
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Add NAVAdminTool.ps1');
        lc_PSR.ImportModule(lc_AdminTool);
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Add AdminFunctions.ps1');
        lc_PSR.ImportModule(AddFileNameToPowerShellPath('AdminFunctions.ps1'));
        // Create powershell command
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Call Function F-LoadNAVServiceIntoFile');
            lc_PSR.AddCommand('F-LoadNAVServiceIntoFile');
            lc_PSR.AddParameter('ServerInstance', _IC."Service Name");
            lc_PSR.AddParameter('FullFileName', _FullFileName);
        end else begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Call Function F-LoadNAVServiceAndSendToWebService');
            lc_PSR.AddCommand('F-LoadNAVServiceAndSendToWebService');
            lc_PSR.AddParameter('ServerInstance', _IC."Service Name");
            lc_PSR.AddParameter('URL', lc_URL);
            lc_PSR.AddParameter('Username', 'IMPL');
            lc_PSR.AddParameter('Password', 'Welcome2019');
        end;
        // Extecute powershell command
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Invoke Command');
        lc_PSR.BeginInvoke();

        // Wait for complition
        if not (lc_PSR.IsCompleted) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Wait for completion');
            repeat
                Sleep(1000);
            until lc_PSR.IsCompleted;
        end;

        // Read file
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Import file');
            // Import file
            lc_ResponseText := ImpMgmt.ImportFile(_FullFileName, TextEncoding::UTF16, false);
            // Transfer to json
            if not lc_Request.ReadFrom(lc_ResponseText) then
                Message('No json format:\\' + lc_ResponseText)
            else begin
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Import content');
                // Return result
                _Response := lc_Request;
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Content imported');
            end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();
    end;

    procedure CallServiceCreate(var _IC: Record "IMP Connection"; _WithConfirm: Boolean; _WithMessage: Boolean) RetValue: Boolean
    var
        lc_PSR: DotNet PowerShellRunner;
        lc_Request: JsonObject;
        lc_Response: JsonObject;
        lc_Dia: Dialog;
        lc_URL: Text;
        lc_AdminTool: Text;
        lc_IsFile: Boolean;
        lc_Computer: Text;
        lc_ResponseText: Text;
        lc_Version: Text;
        lc_IntVersion: Integer;
        lc_FullFileName: Text;
        lc_Conf_Txt: Label 'Do you really want to create the service "%1"?';
        lc_MsgA_Txt: Label 'The service "%1" has been created successfully';
        lc_MsgB_Txt: Label 'The create of service "%1" terminated with error';
        lc_Txt0_Txt: Label '%1 has to be %2';
        lc_Txt1_Txt: Label '#1###########################';
    begin
        // Init
        RetValue := false;
        lc_IsFile := true;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(StrSubstNo(lc_Conf_Txt, _IC."Service Name")) then
                exit;

        // Get powershell settings
        _IC.GetPS(_IC, lc_IntVersion, lc_Version, lc_AdminTool, lc_Computer, lc_URL);

        // Check environment
        if (_IC.Environment <> _IC.Environment::Service) then
            Error(lc_Txt0_Txt, _IC.FieldCaption(Environment), format(_IC.Environment::Service));

        // Set file
        lc_FullFileName := AddFileNameToInfoPath(lc_Computer + '_NAVServer_' + _IC."Service Name" + '.json');

        // Open Dia
        if GuiAllowed then
            lc_Dia.Open(lc_Txt1_Txt);

        Clear(lc_PSR);
        // Create powershell connection
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Create Powershell Sandbox');
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Add NAVAdminTool.ps1');
        lc_PSR.ImportModule(lc_AdminTool);
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Add AdminFunctions.ps1');
        lc_PSR.ImportModule(AddFileNameToPowerShellPath('AdminFunctions.ps1'));
        // Create powershell command
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Call Function F-CreateServerInstance');
        lc_PSR.AddCommand('F-CreateServerInstance');
        lc_PSR.AddParameter('ServerInstance', _IC."Service Name");
        lc_PSR.AddParameter('ClientPort', _IC.ClientServicesPort);
        lc_PSR.AddParameter('Version', lc_IntVersion);
        lc_PSR.AddParameter('Username', _IC."Service Account");
        lc_PSR.AddParameter('Password', _IC.GetServicePs());
        lc_PSR.AddParameter('DatabaseServer', _IC.DatabaseServer);
        lc_PSR.AddParameter('DatabaseInstance', _IC.DatabaseInstance);
        lc_PSR.AddParameter('DatabaseName', _IC.DatabaseName);
        lc_PSR.AddParameter('CreateWebService', true);
        lc_PSR.AddParameter('ClientServicesCredentialType', _IC.ClientServicesCredentialType);
        lc_PSR.AddParameter('ServicesCertificateThumbprint', _IC.ServicesCertificateThumbprint);
        lc_PSR.AddParameter('DnsIdentity', _IC.Dns);
        lc_PSR.AddParameter('FullFileName', lc_FullFileName);
        // Extecute powershell command
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Invoke Command');
        lc_PSR.BeginInvoke();

        // Wait for complition
        if not (lc_PSR.IsCompleted) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Wait for completion');
            repeat
                Sleep(1000);
            until lc_PSR.IsCompleted;
        end;

        // Read file
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Import file');
            // Import file
            lc_ResponseText := ImpMgmt.ImportFile(lc_FullFileName, TextEncoding::UTF16, false);
            // Transfer to json
            if not lc_Request.ReadFrom(lc_ResponseText) then
                Message('No json format:\\' + lc_ResponseText)
            else begin
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Import content');
                // Import content
                RetValue := _IC.ImportServerInstances(lc_Request, lc_Response);
                // Process import
                if (GuiAllowed()) then
                    lc_Dia.Update(1, 'Content imported');
            end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();

        // Show Message
        if ((_WithMessage) and (GuiAllowed())) then
            if (RetValue) then
                Message(lc_MsgA_Txt, _IC."Service Name")
            else
                Message(lc_MsgB_Txt, _IC."Service Name");
    end;

    procedure CallServiceAction(var _IC: Record "IMP Connection"; _Type: Enum IMPServiceStatus; _WithConfirm: Boolean; _WithMessage: Boolean) RetValue: Boolean
    var
        lc_PSR: DotNet PowerShellRunner;
        lc_Request: JsonObject;
        lc_Response: JsonObject;
        lc_Token: JsonToken;
        lc_Dia: Dialog;
        lc_URL: Text;
        lc_AdminTool: Text;
        lc_IsFile: Boolean;
        lc_Computer: Text;
        lc_ResponseText: Text;
        lc_Version: Text;
        lc_IntVersion: Integer;
        lc_FullFileName: Text;
        lc_Conf_Txt: Text;
        lc_Conf0_Txt: Label 'Do you really want to start the service "%1"?';
        lc_Conf1_Txt: Label 'Do you really want to stop the service "%1"?';
        lc_Conf2_Txt: Label 'Do you really want to remove the service "%1"?';
        lc_Conf3_Txt: Label 'Do you really want to restart the service "%1"?';
        lc_MsgA_Txt: Label 'Process finished successfully';
        lc_MsgB_Txt: Label 'Process terminated with error';
        lc_Txt0b_Txt: Label '%1 has to be %2';
        lc_Txt1_Txt: Label '#1###########################';
        lc_Txt2_Txt: Label 'Start call for %1 service from %2';
        lc_Txt3_Txt: Label 'Process call for %1 service from %2';
    begin
        // Init
        RetValue := false;

        // Set confirm
        case _Type of
            _Type::ToStart:
                lc_Conf_Txt := lc_Conf0_Txt;
            _Type::ToStop:
                lc_Conf_Txt := lc_Conf1_Txt;
            _Type::ToRemove:
                lc_Conf_Txt := lc_Conf2_Txt;
            _Type::ToRestart:
                lc_Conf_Txt := lc_Conf3_Txt;
            else
                exit;
        end;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(StrSubstNo(lc_Conf_Txt, _IC."Service Name")) then
                exit;

        // Get powershell settings
        _IC.GetPS(_IC, lc_IntVersion, lc_Version, lc_AdminTool, lc_Computer, lc_URL);

        // Check environment
        if (_IC.Environment <> _IC.Environment::Service) then
            Error(lc_Txt0b_Txt, _IC.FieldCaption(Environment), format(_IC.Environment::Service));

        // Set file
        lc_FullFileName := AddFileNameToInfoPath(lc_Computer + '_NAVServer_' + _IC."Service Name" + '.json');

        // Open Dia
        if GuiAllowed then begin
            lc_Dia.Open(lc_Txt1_Txt);
            lc_Dia.Update(1, StrSubstNo(lc_Txt2_Txt, lc_IntVersion, lc_Computer));
        end;

        Clear(lc_PSR);
        // Create powershell connection
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Create Powershell Sandbox');
        lc_PSR := lc_PSR.CreateInSandbox();
        lc_PSR.WriteEventOnError := true;
        // Import nav admin tool in powershell
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Add NAVAdminTool.ps1');
        lc_PSR.ImportModule(lc_AdminTool);
        if (GuiAllowed()) then
            lc_Dia.Update(1, 'Add AdminFunctions.ps1');
        lc_PSR.ImportModule(AddFileNameToPowerShellPath('AdminFunctions.ps1'));
        // Create powershell command
        case _Type of
            _Type::ToStart:
                begin
                    if (GuiAllowed()) then
                        lc_Dia.Update(1, 'Call Function F-StartServerInstance');
                    lc_PSR.AddCommand('F-StartServerInstance');
                end;
            _Type::ToRestart:
                begin
                    if (GuiAllowed()) then
                        lc_Dia.Update(1, 'Call Function F-RestartServerInstance');
                    lc_PSR.AddCommand('F-ResartServerInstance');
                end;
            _Type::ToStop:
                begin
                    if (GuiAllowed()) then
                        lc_Dia.Update(1, 'Call Function F-StopServerInstance');
                    lc_PSR.AddCommand('F-StopServerInstance');
                end;
            _Type::ToRemove:
                begin
                    if (GuiAllowed()) then
                        lc_Dia.Update(1, 'Call Function F-RemoveServerInstance');
                    lc_PSR.AddCommand('F-RemoveServerInstance');
                end;
        end;
        lc_PSR.AddParameter('ServerInstance', _IC."Service Name");
        lc_PSR.AddParameter('FullFileName', lc_FullFileName);
        // Extecute powershell command
        if (GuiAllowed()) then
            case _Type of
                _Type::ToStart:
                    lc_Dia.Update(1, 'Invoke Command: ' + Format(_Type::Starting) + '...');
                _Type::ToStop:
                    lc_Dia.Update(1, 'Invoke Command: ' + Format(_Type::Stoping) + '...');
                _Type::ToRestart:
                    lc_Dia.Update(1, 'Invoke Command: ' + Format(_Type::Restarting) + '...');
                _Type::ToRemove:
                    lc_Dia.Update(1, 'Invoke Command: ' + Format(_Type::Removing) + '...');
                else
                    lc_Dia.Update(1, 'Invoke Command');
            end;
        lc_PSR.BeginInvoke();

        // Wait for complition
        if not (lc_PSR.IsCompleted) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Wait for completion');
            repeat
                Sleep(1000);
            until lc_PSR.IsCompleted;
        end;

        // Read file
        if (lc_IsFile) then begin
            if (GuiAllowed()) then
                lc_Dia.Update(1, 'Import file');
            // Import file
            lc_ResponseText := ImpMgmt.ImportFile(lc_FullFileName, TextEncoding::UTF16, false);
            // Transfer to json
            if not lc_Request.ReadFrom(lc_ResponseText) then
                Message('No json format:\\' + lc_ResponseText)
            else
                // Action remove
                if (_Type = _Type::ToRemove) then begin
                    if not (lc_Request.Get('services', lc_Token)) then
                        Message('Token services missing in json')
                    else
                        if not lc_Token.IsArray() then
                            Message('Token services has to an array')
                        else
                            if (lc_Token.AsArray().Count() = 0) then
                                _IC.Delete(false);
                end else begin
                    // Import content                
                    if (GuiAllowed()) then
                        lc_Dia.Update(1, 'Import content');
                    // Process import
                    _IC.ImportServerInstances(lc_Request, lc_Response);
                    // Process import
                    if (GuiAllowed()) then
                        lc_Dia.Update(1, 'Content imported');
                end;
        end;

        // Close Dia
        if (GuiAllowed()) then
            lc_Dia.Close();

        // Show Message
        if ((_WithMessage) and (GuiAllowed())) then
            if (RetValue) then
                Message(lc_MsgA_Txt, _IC."Service Name")
            else
                Message(lc_MsgB_Txt, _IC."Service Name");
    end;

    //#endregion PowerShell

    #region Misc

    procedure GetCurrentComputerName() RetValue: Text
    var
        lc_AS: Record "Active Session";
        lc_List: List of [Text];
    begin
        // Init
        RetValue := '';

        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            RetValue := lc_List.Get(1);
        end else
            RetValue := lc_AS."Server Computer Name";
    end;

    procedure GetServiceActionStart() RetValue: Text
    begin
        RetValue := 'start';
    end;

    procedure GetServiceActionStop() RetValue: Text
    begin
        RetValue := 'stop';
    end;

    procedure GetServiceActionRestart() RetValue: Text
    begin
        RetValue := 'restart';
    end;

    procedure GetServiceActionRemove() RetValue: Text
    begin
        RetValue := 'remove';
    end;

    #endregion Misc

    var
        ImpMgmt: Codeunit "IMP Management";
        ImpAdmin: Codeunit "IMP Administration";
        BscMgmt: Codeunit "IMP Basic Management";
        FileMgmt: Codeunit "File Management";
}