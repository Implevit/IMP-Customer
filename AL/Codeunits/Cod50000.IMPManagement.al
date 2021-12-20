codeunit 50000 "IMP Management"
{
    #region Translations

    procedure TranslateXlfFile(_WithConfirm: Boolean; _WithMessage: Boolean)
    begin
        TranslateXlfFile('', _WithConfirm, _WithMessage);
    end;

    [Scope('OnPrem')]
    procedure TranslateXlfFile(_FullFileName: Text; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_TempSource: Record "Name/Value Buffer" temporary;
        lc_InStream: InStream;
        lc_FileName: Text;
        lc_Txt0_Txt: Label 'Select file';
    begin
        if (_FullFileName <> '') then begin
            if ImportFile(_FullFileName, lc_Instream, TextEncoding::UTF8, false) then
                TranslateXlfFile(lc_InStream, lc_TempSource.Name, _WithConfirm, _WithMessage);
        end else
            if UploadIntoStream(lc_Txt0_Txt, '', BscMgmt.GetFileFilterAll(), lc_FileName, lc_InStream) then
                TranslateXlfFile(lc_InStream, lc_FileName, _WithConfirm, _WithMessage);
    end;

    [Scope('OnPrem')]
    procedure TranslateXlfFile(var _InStream: InStream; _FullFileName: Text; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        //lc_TempTarget: Record "Name/Value Buffer" temporary;
        lc_FielMgmt: Codeunit "File Management";
        lc_TempBlob: Codeunit "Temp Blob";
        lc_InStream: InStream;
        lc_OutStream: OutStream;
        lc_FilePath: Text;
        lc_FileName: Text;
        lc_FileExtension: Text;
        lc_NewFullFileName: Text;
        lc_SourceText: Text;
        lc_TargetStart: Text;
        lc_TargetText: Text;
        lc_Translation: Text;
        lc_Line: Text;
        lc_CrLf: Text;
        lc_SourceLang: Text;
        lc_TargetLang: Text;
        lc_TagSourceLang: Text;
        lc_TagSourceStart: Text;
        lc_TagSourceEnd: Text;
        lc_TagTargetLang: Text;
        lc_TagTargetStart: Text;
        lc_TagTargetEnd: Text;
        lc_TagTransUnitStart: Text;
        lc_TagTransUnitEnd: Text;
        lc_Counter: Integer;
        lc_SkipLine: Boolean;
        lc_TransUnit: Boolean;
        lc_TransUnitCounter: Integer;
        lc_Usage: Integer;
        lc_Conf_Txt: Label 'Do you really want to start the translation of the file "%1"?';
        lc_Msg0_Txt: Label 'No more characters available for translation at DeepL';
        lc_Msg1_Txt: Label 'There was nothing to translate';
        lc_Msg2_Txt: Label 'In the file "%1" there were %2 texts to translate from "%3" to "%4"';
    begin
        //<?xml version="1.0" encoding="utf-8"?>
        //<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:tc:xliff:document:1.2 xliff-core-1.2-transitional.xsd">
        //  <file datatype="xml" source-language="en-US" target-language="de-CH" original="IMP-Basic">
        //    <body>
        //      <group id="body">
        //        <trans-unit id="Table 3452873508 - Property 2879900210" size-unit="char" translate="yes" xml:space="preserve">
        //          <source>Implevit Documents</source>
        //          <target>Implevit Dokumente</target>
        //          <note from="NAB AL Tool Refresh Xlf" annotates="general" priority="3">Suggested translation inserted.</note>
        //          <note from="Developer" annotates="general" priority="2"></note>
        //          <note from="Xliff Generator" annotates="general" priority="3">Table IMP Documents - Property Caption</note>
        //        </trans-unit>

        // Get Usage
        lc_Usage := BscMgmt.DeepLUsageGet();
        if lc_Usage <= 0 then
            if ((_WithMessage) and (GuiAllowed())) then begin
                Message(lc_Msg0_Txt);
                exit;
            end;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(StrSubstNo(lc_Conf_Txt, lc_FielMgmt.GetFileName(_FullFileName))) then
                exit;

        // Init
        lc_Counter := 0;
        lc_CrLf[1] := 13;
        lc_CrLf[2] := 10;
        lc_TransUnit := false;
        lc_TransUnitCounter := 0;
        lc_TagTransUnitStart := '<trans-unit ';
        lc_TagTransUnitEnd := '</trans-unit>';
        lc_SourceLang := '';
        lc_TagSourceLang := 'source-language="';
        lc_TagSourceStart := '<source>';
        lc_TagSourceEnd := '</source>';
        lc_TargetLang := '';
        lc_TagTargetLang := 'target-language="';
        lc_TagTargetStart := '<target>';
        lc_TagTargetEnd := '</target>';

        // Set New File Name
        lc_FileName := lc_FielMgmt.GetFileNameWithoutExtension(_FullFileName);
        lc_FileExtension := lc_FielMgmt.GetExtension(_FullFileName);
        lc_FilePath := CopyStr(_FullFileName, 1, StrLen(_FullFileName) - StrLen(lc_FileName) - StrLen(lc_FileExtension) - 1);
        lc_NewFullFileName := lc_FilePath + lc_FileName + '.new.' + lc_FileExtension;

        // Create Target
        lc_TempBlob.CreateOutStream(lc_OutStream, TextEncoding::UTF8);
        //lc_TempTarget.Init();
        //lc_TempTarget."Value BLOB".CreateOutStream(lc_OutStream, TextEncoding::UTF8);

        // Read Source
        while not _InStream.EOS() do begin
            // Read Line
            _InStream.ReadText(lc_Line);
            lc_SkipLine := false;

            // Langauges
            if ((lc_Line.Contains(lc_TagSourceLang)) and (lc_Line.Contains(lc_TagTargetLang))) then begin
                lc_SourceLang := CopyStr(lc_Line, StrPos(lc_Line, lc_TagSourceLang) + StrLen(lc_TagSourceLang), 2).ToUpper();
                lc_TargetLang := CopyStr(lc_Line, StrPos(lc_Line, lc_TagTargetLang) + StrLen(lc_TagTargetLang), 2).ToUpper();
            end;

            // Trans-Unit
            if lc_Line.Contains(lc_TagTransUnitStart) then begin
                lc_TransUnit := true;
                lc_TransUnitCounter := 0;
            end else
                if lc_Line.Contains(lc_TagTransUnitEnd) then
                    lc_TransUnit := false;

            // Source
            if ((lc_Line.Contains(lc_TagSourceStart)) and (lc_Line.Contains(lc_TagSourceEnd))) then begin
                lc_SourceText := CopyStr(lc_Line, StrPos(lc_Line, lc_TagSourceStart) + StrLen(lc_TagSourceStart));
                lc_SourceText := CopyStr(lc_SourceText, 1, StrLen(lc_SourceText) - StrLen(lc_TagSourceEnd));
                lc_TargetText := '';
            end;

            // Target
            if (lc_TransUnit) then
                if ((lc_Line.Contains(lc_TagTargetStart)) and (lc_Line.Contains(lc_TagTargetEnd))) then begin
                    lc_TargetStart := CopyStr(lc_Line, 1, StrPos(lc_Line, lc_TagTargetStart) + StrLen(lc_TagTargetStart) - 1);
                    lc_TargetText := CopyStr(lc_Line, StrPos(lc_Line, lc_TagTargetStart) + StrLen(lc_TagTargetStart));
                    lc_TargetText := CopyStr(lc_TargetText, 1, StrLen(lc_TargetText) - StrLen(lc_TagTargetEnd));

                    if lc_TargetText.StartsWith('[NAB:') then begin
                        lc_TransUnitCounter += 1;
                        if ((lc_Usage - StrLen(lc_SourceText)) >= 0) then
                            if (lc_TransUnitCounter > 1) then
                                lc_SkipLine := true
                            else
                                if BscMgmt.DeepLTranslateGet(lc_SourceText, lc_Translation, lc_SourceLang, lc_TargetLang) then begin
                                    lc_Usage -= StrLen(lc_SourceText);
                                    lc_Line := lc_TargetStart + lc_Translation + lc_TagTargetEnd;
                                    lc_Counter += 1;
                                end;
                    end;
                end;

            // Write Output
            if not (lc_SkipLine) then
                lc_OutStream.WriteText(lc_Line + lc_CrLf)
        end;

        // Export Output
        //lc_TempTarget."Value BLOB".CreateInStream(lc_InStream, TextEncoding::UTF8);
        lc_TempBlob.CreateInStream(lc_InStream, TextEncoding::UTF8);
        DownloadFromStream(lc_InStream, 'Export', '', '', lc_NewFullFileName);

        // Show Message
        if ((_WithMessage) and (GuiAllowed())) then
            if (lc_Counter = 0) then
                Message(lc_Msg1_Txt)
            else
                Message(lc_Msg2_Txt, lc_FileName + '.' + lc_FileExtension, lc_Counter, lc_SourceLang, lc_TargetLang);
    end;

    #endregion Translations

    #region Misc

    procedure T210_OnBeforeValidateJobTaskNo(var _JobJournalLine: Record "Job Journal Line"; var _xJobJournalLine: Record "Job Journal Line"; var _IsHandled: Boolean)
    var
        lc_JobTask: Record "Job Task";
    begin
        if (_JobJournalLine."Job Task No." = '') then
            _JobJournalLine.Validate("No.", '')
        else
            if lc_JobTask.Get(_JobJournalLine."Job Task No.") then
                _JobJournalLine."IMP All Inclusive" := lc_JobTask."IMP All Inclusive";
        _IsHandled := true;
    end;

    procedure T210_OnAfterSetUpNewLine(var _JobJournalLine: Record "Job Journal Line"; _LastJobJournalLine: Record "Job Journal Line"; _JobJournalTemplate: Record "Job Journal Template"; _JobJournalBatch: Record "Job Journal Batch")
    var
        lc_NosMgmt: Codeunit NoSeriesManagement;
    begin
        _JobJournalLine."Job No." := _LastJobJournalLine."Job No.";
        _JobJournalLine."Job Task No." := _LastJobJournalLine."Job Task No.";
        //_JobJournalLine."Job Planningline Line No." := _LastJobJournalLine."Job Planningline Line No.";

        if (_JobJournalLine."Document No." = '') and (_JobJournalBatch."IMP Line Nos." <> '') then begin
            CLEAR(lc_NosMgmt);
            _JobJournalLine."Document No." := lc_NosMgmt.TryGetNextNo(_JobJournalBatch."IMP Line Nos.", _JobJournalLine."Posting Date");
        end;
    end;

    procedure C70025_OnDataSelectEntry(var _List: Record "Name/Value Buffer"; _Fields: List of [Integer]; _SingleSelection: Boolean);
    var
        lc_Page: Page "IMP Selection List";
    begin
        lc_Page.HideAllEntries();
        lc_Page.SetFields(_Fields, false, _SingleSelection);
        lc_Page.SetData(0, _List);
        lc_Page.LookupMode := true;
        if lc_Page.RunModal() = Action::LookupOK then
            lc_Page.GetSelection(_List);
    end;

    procedure C70026_OnODataBeforeProcess(_Request: JsonObject; var _Response: JsonObject; var _Skip: Boolean)
    var
        lc_IS: Record "IMP Server";
        lc_IC: Record "IMP Connection";
        lc_Token: JsonToken;
    begin
        if not _Request.Get('data', lc_Token) then
            exit;

        case BscMgmt.JsonGetTokenValue(lc_Token, 'data').AsText().ToLower() of
            'serverversions':
                lc_IS.NAVVersionsImport(_Request, _Response);
            'serverinstance', 'serverinstances':
                lc_IC.ImportServerInstances(_Request, _Response);
            'loadversions':
                AdmMgmt.CallVersionList(_Request, _Response);
        end;
    end;

    procedure C70026_OnODataAfterProcess(_Request: JsonObject; var _Response: JsonObject)
    begin
    end;

    procedure C70025_OnGetConnection(var _Object: JsonObject; var _ConnectionNo: Code[20]; var _Url: Text; var _Tenant: Text; var _CustomerNo: Text; var _CompanyName: Text; var _CompanyId: Text; var _AuthNo: Integer; var _Username: Text; var _Password: Text; var _Token: Text; var _ClientId: Text; var _SecretId: Text; var _Found: Boolean)
    var
        lc_IC: Record "IMP Connection";
    begin
        // Init
        _Found := false;
        _ConnectionNo := '';
        _Url := '';
        _AuthNo := 0;
        // Get
        _Found := lc_IC.Get(_ConnectionNo);
        // Found
        if (_Found) then begin
            _AuthNo := lc_IC."Authorisation No.";
            _Url := lc_IC.Url;
            _Tenant := lc_IC."Environment Id";
            if (lc_IC.Environment <> lc_IC.Environment::Cloud) then begin
                _Url := 'http://' + lc_IC."Environment Name".ToLower() + ':' + Format(lc_IC.ODataServicesPort) + '/' + lc_IC."Service Name";
                _Tenant := 'default';
            end;
        end;
    end;

    procedure C70025_OnSelectConnection(var _Object: JsonObject; var _ConnectionNo: Code[20]; var _Url: Text; var _Tenant: Text; var _CustomerNo: Text; var _CompanyName: Text; var _CompanyId: Text; var _AuthNo: Integer; var _Username: Text; var _Password: Text; var _Token: Text; var _ClientId: Text; var _SecretId: Text; var _Selected: Boolean; var _Skip: Boolean)
    var
        lc_IC: Record "IMP Connection";
        lc_ConnectionNo: Code[20];
        lc_Found: Boolean;
    begin
        // Save key
        lc_ConnectionNo := _ConnectionNo;
        // Init
        _Selected := false;
        _Skip := false;
        _ConnectionNo := '';
        _Url := '';
        _AuthNo := 0;
        // Select entry
        lc_IC.Reset();
        if (lc_ConnectionNo <> '') then
            lc_IC.SetRange("No.", lc_ConnectionNo);
        if lc_IC.FindSet() then;
        lc_IC.SetRange("No.");
        // Lookup page
        if not (Page.RunModal(Page::"IMP Connection List", lc_IC) = Action::LookupOK) then
            _Skip := true
        else begin
            _Selected := true;
            // Fill parameters
            _ConnectionNo := lc_IC."No.";
            _CustomerNo := lc_IC."Customer No.";
            _CompanyName := lc_IC."Company Name";
            _CompanyId := lc_IC."Company Id";
            // Set url
            if (lc_IC.Environment = lc_IC.Environment::Cloud) then begin
                _Url := lc_IC.GetUrlOdata();
                _Tenant := lc_IC."Environment Id";
            end else begin
                _Url := lc_IC.GetUrlOdata();
                _Url := _Url.ToLower();
                _Tenant := 'default';
            end;
            // Load authorisation
            _AuthNo := lc_IC."Authorisation No.";
            C70025_OnGetAuthorisation(_AuthNo, _Username, _Password, _Token, _ClientId, _SecretId, lc_Found);
        end;
    end;

    procedure C70025_OnGetAuthorisation(_AuthNo: Integer; var _Username: Text; var _Password: Text; var _Token: Text; var _ClientId: Text; var _SecretId: Text; var _Found: Boolean);
    var
        lc_IA: Record "IMP Authorisation";
    begin
        // Init
        _Found := false;
        _Username := '';
        _Password := '';
        _ClientId := '';
        _SecretId := '';
        _Token := '';
        // Get
        _Found := lc_IA.Get(_AuthNo);
        // Fill parameters
        if (_Found) then begin
            _Username := lc_IA.Name;
            _Password := lc_IA.Password;
            _ClientId := lc_IA."Client Id";
            _SecretId := lc_IA."Secret Id";
            _Token := lc_IA.Token;
        end;
    end;

    procedure C70025_OnSelectAuthorisation(_CustomerNo: Text; var _AuthNo: Integer; var _Username: Text; var _Password: Text; var _Token: Text; var _ClientId: Text; var _SecretId: Text; var _Selected: Boolean; var _Skip: Boolean);
    var
        lc_IA: Record "IMP Authorisation";
        lc_AuthNo: Integer;
    begin
        // Save key
        lc_AuthNo := _AuthNo;
        // Init
        _Selected := false;
        _Skip := false;
        _AuthNo := 0;
        _AuthNo := lc_IA."Entry No.";
        _Username := lc_IA.Name;
        _Password := lc_IA.Password;
        _ClientId := lc_IA."Client Id";
        _SecretId := lc_IA."Secret Id";
        _Token := lc_IA.Token;
        // Select entry
        lc_IA.Reset();
        if (lc_AuthNo <> 0) then
            lc_IA.SetRange("Entry No.", lc_AuthNo);
        lc_IA.SetCurrentKey("Customer No.");
        lc_IA.SetRange("Customer No.", _CustomerNo);
        if lc_IA.FindSet() then;
        lc_IA.SetRange("Entry No.");
        // Lookup page
        if not (Page.RunModal(Page::"IMP Authorisation List", lc_IA) = Action::LookupOK) then
            _Skip := true
        else begin
            _Selected := true;
            // Fill parameters
            _AuthNo := lc_IA."Entry No.";
            _Username := lc_IA.Name;
            _Password := lc_IA.Password;
            _ClientId := lc_IA."Client Id";
            _SecretId := lc_IA."Secret Id";
            _Token := lc_IA.Token;
        end;
    end;

    procedure GetODataConnection(var _Result: JsonObject; _ConnectionNo: Code[20]; _CompanyName: Text; _CompanyId: Text; _Convert: Boolean) RetValue: Boolean
    var
        lc_IC: Record "IMP Connection";
        //lc_CrpMgmt: Codeunit "Cryptography Management";
        lc_Base64: Codeunit "Base64 Convert";
        lc_Object: JsonObject;
        lc_JsonText: Text;
        lc_Txt0_Txt: Label 'Server No. %1 not found';
        lc_Txt1_Txt: Label 'Company Name is mandatory!';
        lc_Txt2_Txt: Label 'Customer No. is mandatory!';
    begin
        // Init
        RetValue := false;
        clear(_Result);

        // Get server
        if not lc_IC.Get(_ConnectionNo) then begin
            _Result.Add('error', 'Connection no. ' + _ConnectionNo + ' not found');
            if (GuiAllowed()) then
                Message(lc_Txt0_Txt, _ConnectionNo);
            exit;
        end;

        // Check company name
        if (lc_IC."Company Name" = '') then begin
            _Result.Add('error', 'Company name is mandantory');
            if (GuiAllowed()) then
                Message(lc_Txt1_Txt);
            exit;
        end;

        // Check customer no
        if (lc_IC."Customer No." = '') then begin
            _Result.Add('error', 'Customer no is mandantory');
            if (GuiAllowed()) then
                Message(lc_Txt2_Txt);
            exit;
        end;

        // Set server
        lc_Object.Add('data', 'ServerConnection');
        lc_Object.Add('connectionNo', lc_IC."No.");
        if (lc_IC.Environment = lc_IC.Environment::Cloud) then
            lc_Object.Add('tenant', lc_IC."Environment Id")
        else
            lc_Object.Add('tenant', 'default');
        lc_Object.Add('url', lc_IC.GetUrlOdata());
        lc_Object.Add('customerNo', lc_IC."Customer No.");
        // Company
        lc_Object.Add('companyName', _CompanyName);
        _CompanyId := _CompanyId.Replace('{', '');
        _CompanyId := _CompanyId.Replace('}', '');
        lc_Object.Add('companyId', _CompanyId);

        // Set authorisation
        if (lc_IC."Authorisation No." <> 0) then
            if not AddODataAuthorisation(lc_Object, lc_IC."Authorisation No.") then
                exit;

        // Convert
        lc_Object.WriteTo(lc_JsonText);
        if (_Convert) then begin
            lc_JsonText := lc_Base64.ToBase64(lc_JsonText, TextEncoding::UTF16);
            _Result.Add('json', lc_JsonText)
        end else
            _Result.Add('json', lc_Object);

        // Return
        RetValue := true;
    end;

    procedure GetODataAuthorisation(_Result: JsonObject; _AuthNo: Integer; _Convert: Boolean) RetValue: Boolean
    var
        lc_Base64: Codeunit "Base64 Convert";
        lc_Object: JsonObject;
        lc_JsonText: Text;
    begin
        // Init
        RetValue := false;
        clear(_Result);

        // Set
        lc_Object.Add('data', 'ServerAuthorisation');

        // Add
        if not AddODataAuthorisation(lc_Object, _AuthNo) then
            exit;

        // Convert
        lc_Object.WriteTo(lc_JsonText);
        if (_Convert) then begin
            lc_JsonText := lc_Base64.ToBase64(lc_JsonText, TextEncoding::UTF16);
            _Result.Add('json', lc_JsonText)
        end else
            _Result.Add('json', lc_Object);

        // Return
        RetValue := true;
    end;

    procedure AddODataAuthorisation(var _Result: JsonObject; _AuthNo: Integer) RetValue: Boolean
    var
        lc_IA: Record "IMP Authorisation";
    begin
        // Init
        RetValue := false;

        // Get 
        if not lc_IA.Get(_AuthNo) then begin
            _Result.Add('error', 'Authorisation no. ' + Format(_AuthNo) + ' not found');
            exit;
        end;

        // Set 
        _Result.Add('authNo', lc_IA."Entry No.");
        _Result.Add('userName', lc_IA.Name);
        _Result.Add('passowrd', lc_IA.Password);
        _Result.Add('token', lc_IA.Token);
        _Result.Add('clientId', lc_IA."Client Id");
        _Result.Add('secretId', lc_IA."Secret Id");

        // Return
        RetValue := true;
    end;

    procedure ImportFile(_FileName: Text; var _InStream: InStream; _TextEncoding: TextEncoding; _DeleteAfterImport: Boolean) RetValue: Boolean
    var
        lc_Buff: Record "Name/Value Buffer" temporary;
        lc_FileMgmt: Codeunit "File Management";
    begin
        // Init
        RetValue := false;
        lc_Buff.Init();

        // Import            
        if ImportFileFromBuffer(lc_Buff, _FileName) then begin
            lc_Buff."Value BLOB".CreateInStream(_InStream, _TextEncoding);
            RetValue := (lc_Buff."Value BLOB".Length <> 0);
        end;

        // Remove file
        if (_DeleteAfterImport) then
            if lc_FileMgmt.DeleteServerFile(_FileName) then;
    end;

    procedure ImportFile(_FileName: Text; _TextEncoding: TextEncoding; _DeleteAfterImport: Boolean) RetValue: Text
    var
        lc_Buff: Record "Name/Value Buffer" temporary;
        lc_FileMgmt: Codeunit "File Management";
        lc_InStream: InStream;
        lc_Temptext: Text[1000];
    begin
        // Init
        RetValue := '';
        lc_Buff.Init();

        // Import            
        if ImportFileFromBuffer(lc_Buff, _FileName) then begin
            lc_Buff."Value BLOB".CreateInStream(lc_InStream, _TextEncoding);
            while not lc_InStream.EOS() do begin
                lc_InStream.Read(lc_Temptext, 1000);
                RetValue += lc_Temptext;
            end;
        end;

        // Remove file
        if (_DeleteAfterImport) then
            if lc_FileMgmt.DeleteServerFile(_FileName) then;
    end;

    procedure ImportFileFromBuffer(var _Buffer: Record "Name/Value Buffer"; _FileName: Text) RetValue: Boolean
    begin
        if (_Buffer."Value BLOB".Import(_FileName) <> '') then
            RetValue := true
        else
            RetValue := false;
    end;

    procedure SelectEntry(var _List: Record "Name/Value Buffer"; _Fields: List of [Integer]; _SingleSelection: Boolean) RetValue: Boolean
    var
        lc_Page: Page "IMP Selection List";
    begin
        RetValue := false;
        lc_Page.HideAllEntries();
        lc_Page.SetFields(_Fields, false, _SingleSelection);
        lc_Page.SetData(0, _List);
        lc_Page.LookupMode := true;
        if lc_Page.RunModal() = Action::LookupOK then begin
            lc_Page.GetSelection(_List);
            RetValue := true;
        end;
    end;

    procedure LoadFolders(var _Rec: Record "Name/Value Buffer"; _Root: Text; _InclSubFolders: Boolean)
    var
        lc_FileMgmt: Codeunit "File Management";
        lc_ServerDirectoryHelper: DotNet Directory;
        lc_ArrayHelper: DotNet Array;
        lc_FileSystemEntry: Text;
        lc_Index: Integer;
        lc_NextId: Integer;
    begin
        // Check Root
        if not lc_FileMgmt.ServerDirectoryExists(_Root) then
            exit;

        // Clean Root
        if not _Root.EndsWith('\') then
            _Root += '\';

        // Get Next Id
        if _Rec.FindLast() then
            lc_NextId := _Rec.ID;

        // Load Folder
        lc_ArrayHelper := lc_ServerDirectoryHelper.GetFileSystemEntries(_Root);
        for lc_Index := 1 to lc_ArrayHelper.GetLength(0) do begin
            Evaluate(lc_FileSystemEntry, lc_ArrayHelper.GetValue(lc_Index - 1));
            if lc_FileMgmt.ServerDirectoryExists(lc_FileSystemEntry) then begin
                lc_NextId += 1;
                _Rec.Init();
                _Rec.ID := lc_NextId;
                _Rec.Name := CopyStr(CopyStr(lc_FileSystemEntry, StrLen(_Root) + 1), 1, MaxStrLen(_Rec.Name));
                _Rec.Value := CopyStr(lc_FileSystemEntry, 1, MaxStrLen(_Rec.Value));
                _Rec.Insert();
                // Load Sub Folder
                if (_InclSubFolders) then
                    LoadFolders(_Rec, lc_FileSystemEntry, _InclSubFolders)
            end;
        end;
    end;

    procedure LoadFiles(var _Rec: Record "Name/Value Buffer"; _Root: Text; _InclSubFolders: Boolean)
    var
        lc_FileMgmt: Codeunit "File Management";
        lc_ServerDirectoryHelper: DotNet Directory;
        lc_ArrayHelper: DotNet Array;
        lc_FileSystemEntry: Text;
        lc_Index: Integer;
        lc_NextId: Integer;
    begin
        // Check Root
        if not lc_FileMgmt.ServerDirectoryExists(_Root) then
            exit;

        // Clean Root
        if not _Root.EndsWith('\') then
            _Root += '\';

        // Get Next Id
        if _Rec.FindLast() then
            lc_NextId := _Rec.ID;

        // Load Folder
        lc_ArrayHelper := lc_ServerDirectoryHelper.GetFileSystemEntries(_Root);
        for lc_Index := 1 to lc_ArrayHelper.GetLength(0) do begin
            Evaluate(lc_FileSystemEntry, lc_ArrayHelper.GetValue(lc_Index - 1));
            if lc_FileMgmt.ServerDirectoryExists(lc_FileSystemEntry) then
                // Load Sub Folder
                if (_InclSubFolders) then
                    LoadFiles(_Rec, lc_FileSystemEntry, _InclSubFolders)
                else begin
                    lc_NextId += 1;
                    _Rec.Init();
                    _Rec.ID := lc_NextId;
                    _Rec.Name := CopyStr(CopyStr(lc_FileSystemEntry, StrLen(_Root) + 1), 1, MaxStrLen(_Rec.Name));
                    _Rec.Value := CopyStr(lc_FileSystemEntry, 1, MaxStrLen(_Rec.Value));
                    _Rec.Insert();
                end;
        end;
    end;

    #endregion Misc

    #region BC Administaion

    procedure CreateRequest(RequestUrl: Text; AccessToken: Text): Text
    var
        lc_TempBlob: Codeunit "Temp Blob";
        lc_HttpClient: HttpClient;
        lc_HttpHeaders: HttpHeaders;
        lc_HttpResponse: HttpResponseMessage;
        lc_HttpRequest: HttpRequestMessage;
        lc_ResponsJson: JsonObject;
        lc_Instream: InStream;
        lc_ResponseMessage: Text;
    begin

        lc_HttpRequest.GetHeaders(lc_HttpHeaders);
        lc_HttpHeaders.Add('Authorization', 'Bearer ' + AccessToken);
        lc_HttpRequest.SetRequestUri(RequestUrl);
        lc_HttpRequest.Method('GET');

        Clear(lc_TempBlob);
        lc_TempBlob.CreateInStream(lc_Instream);

        if not lc_HttpClient.Send(lc_HttpRequest, lc_HttpResponse) then
            exit('An API call with the provided header has failed.');

        if not lc_HttpResponse.IsSuccessStatusCode() then
            exit('The request has failed with status code ' + Format(lc_HttpResponse.HttpStatusCode()));

        if not lc_HttpResponse.Content().ReadAs(lc_Instream) then
            exit('The response message cannot be processed.');

        if not lc_ResponsJson.ReadFrom(lc_Instream) then
            exit('Cannot read JSON response.');

        lc_ResponsJson.WriteTo(lc_ResponseMessage);
        lc_ResponseMessage := lc_ResponseMessage.Replace(',', '\');
        exit(lc_ResponseMessage);
    end;

    procedure CallAPI(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        ResponseHeader: HttpResponseMessage;
        MailContentHeaders: HttpHeaders;
        Content: HttpContent;
        HttpHeadersContent: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        JObject: JsonObject;
        ResponseStream: InStream;
        APICallResponseMessage: Text;
        StatusCode: Text;
        IsSuccessful: Boolean;
        postData: Text;
        RequestUrl: Text;
        AccessToken: Text;
    begin
        RequestUrl := 'https://api.businesscentral.dynamics.com/admin/v2.7/applications/businesscentral/environments/Sandbox_yma/apps';
        AccessToken := 'VF36TjkVuR7CewrPu+xVF42ZKKg8bapThhBAILcs7vs=';

        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
        RequestHeaders.Add('Accept', 'application/json');
        Content.WriteFrom(postData);

        //GET HEADERS
        Content.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Clear();
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/json; charset=UTF-8');

        //POST METHOD
        RequestMessage.Content := Content;
        RequestMessage.SetRequestUri(RequestUrl);
        RequestMessage.Method := 'GET';

        Clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);

        //IsSuccessful := Client.Send(RequestMessage, ResponseMessage);
        IsSuccessful := Client.Get(RequestUrl, ResponseMessage);

        if not IsSuccessful then exit('An API call with the provided header has failed.');
        if not ResponseMessage.IsSuccessStatusCode() then begin
            StatusCode := Format(ResponseMessage.HttpStatusCode()) + ' - ' + ResponseMessage.ReasonPhrase;
            exit('The request has failed with status code ' + StatusCode);
        end;

        if not ResponseMessage.Content().ReadAs(ResponseStream) then exit('The response message cannot be processed.');
        if not JObject.ReadFrom(ResponseStream) then exit('Cannot read JSON response.');

        //API response
        JObject.WriteTo(APICallResponseMessage);
        APICallResponseMessage := APICallResponseMessage.Replace(',', '\');
        exit(APICallResponseMessage);
    end;

    #endregion BC Administaion

    #region Events

    #endregion Events

    var
        BscMgmt: Codeunit "IMP Basic Management";
        AdmMgmt: Codeunit "IMP Administration";
}