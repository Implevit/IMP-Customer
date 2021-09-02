codeunit 50000 "IMP Management"
{
    //#region Translations

    procedure TranslateXlfFile(_WithConfirm: Boolean; _WithMessage: Boolean)
    begin
        TranslateXlfFile('', _WithConfirm, _WithMessage);
    end;

    procedure TranslateXlfFile(_FullFileName: Text; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_TempSource: Record "Name/Value Buffer" temporary;
        lc_InStream: InStream;
        lc_FileName: Text;
        lc_Txt0_Txt: Label 'Select file';
    begin
        if (_FullFileName = '') then begin
            // Upload File
            if UploadIntoStream(lc_Txt0_Txt, '', BscMgmt.GetFileFilterAll(), lc_FileName, lc_InStream) then
                // Translate
                TranslateXlfFile(lc_InStream, lc_FileName, true, _WithConfirm, _WithMessage);
        end else begin
            // Process
            lc_TempSource.Init();
            lc_TempSource.Name := CopyStr(_FullFileName, 1, MaxStrLen(lc_TempSource.Name));
            lc_TempSource.CalcFields("Value BLOB");
            lc_TempSource."Value BLOB".Import(_FullFileName);
            if (lc_TempSource."Value BLOB".Length <> 0) then begin
                // Import Source
                lc_TempSource."Value BLOB".CreateInStream(lc_Instream, TextEncoding::UTF8);
                // Translate
                TranslateXlfFile(lc_InStream, lc_TempSource.Name, false, _WithConfirm, _WithMessage);
            end;
        end;
    end;

    procedure TranslateXlfFile(var _InStream: InStream; _FullFileName: Text; _ShowFile: Boolean; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_TempTarget: Record "Name/Value Buffer" temporary;
        lc_FielMgmt: Codeunit "File Management";
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
        lc_TempTarget.Init();
        lc_TempTarget."Value BLOB".CreateOutStream(lc_OutStream, TextEncoding::UTF8);

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
        if (_ShowFile) then begin
            lc_TempTarget."Value BLOB".CreateInStream(lc_InStream, TextEncoding::UTF8);
            DownloadFromStream(lc_InStream, 'Export', '', '', lc_NewFullFileName);
        end else
            lc_TempTarget."Value BLOB".Export(lc_NewFullFileName);

        // Show Message
        if ((_WithMessage) and (GuiAllowed())) then
            if (lc_Counter = 0) then
                Message(lc_Msg1_Txt)
            else
                Message(lc_Msg2_Txt, lc_FileName + '.' + lc_FileExtension, lc_Counter, lc_SourceLang, lc_TargetLang);
    end;

    //#endregion Translations

    var
        BscMgmt: Codeunit "IMP Basic Management";
}