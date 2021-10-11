tableextension 50002 "IMP Tab167-Ext50002" extends Job
{
    fields
    {
        field(50010; "IMP New Cust Short Mark"; Code[3])
        {
            Caption = 'Implevit New Cust Short Mark';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Rec: Record Job;
                lc_Txt1_Txt: Label 'The abbreviation "%1" was already used for the project "%2"!';
            begin
                if (("IMP New Cust Short Mark" <> '') and (Rec."IMP New Cust Short Mark" <> xRec."IMP New Cust Short Mark")) then begin
                    lc_Rec.Reset();
                    lc_Rec.SetRange("IMP New Cust Short Mark", Rec."IMP New Cust Short Mark");
                    lc_Rec.SetFilter("No.", '<>%1', "No.");
                    if lc_Rec.FindFirst() then
                        Error(lc_Txt1_Txt, "IMP New Cust Short Mark", lc_Rec."No.");
                end;
            end;
        }
        field(50020; "IMP Project Manager IMPL"; Code[20])
        {
            Caption = 'Project Manager IMPL';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
        field(50030; "IMP Project Manager Standby"; Code[20])
        {
            Caption = 'Project Manager Standby';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
        field(50040; "IMP Accounting Description"; Text[80])
        {
            Caption = 'Accounting Description';
            DataClassification = CustomerContent;
        }
        field(50050; "IMP Job Task No. Expenses"; Code[20])
        {
            Caption = 'Job Task No. Expenses';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." where("Job No." = Field("IMP Job Task No. Expenses"));
        }
        field(50060; "IMP Internal Job"; Option)
        {
            Caption = 'Internal Job';
            DataClassification = CustomerContent;
            OptionMembers = " ",Vacations,Compensation,Private,Sick,Military,Accident,Education,"Int. Projects","Anniversary Holidays",Miscellaneous,Administration,Acquisition;
            OptionCaption = ' ,Vacations,Compensation,Private,Sick,Military,Accident,Education,Int. Projects,Anniversary Holidays,Miscellaneous,Administration,Acquisition';
        }
        field(50070; "IMP Distance km"; Integer)
        {
            Caption = 'Distance km';
            DataClassification = CustomerContent;
        }
        field(50080; "IMP Travel Time (100er units)"; Decimal)
        {
            Caption = 'Travel Time (100er units)';
            DataClassification = CustomerContent;
        }
        field(50090; "IMP Flat charge"; Boolean)
        {
            Caption = 'Flat charge';
            DataClassification = CustomerContent;
        }
        field(50100; "IMP Bill-Receiver Contact No."; Code[20])
        {
            Caption = 'Bill-Receiver Contact No.';
            DataClassification = CustomerContent;
            TableRelation = Contact."No.";
        }
        field(50110; "IMP No Settlement Statement"; Boolean)
        {
            Caption = 'No Settlement Statement';
            DataClassification = CustomerContent;
        }
        field(50120; "IMP Source Settl. Statement"; Option)
        {
            Caption = 'Source Settlement Statement';
            DataClassification = CustomerContent;
            OptionMembers = Journal,Entry,"Journal+Entry";
            OptionCaption = 'Journal,Entry,Journal + Entry';
        }
    }
}