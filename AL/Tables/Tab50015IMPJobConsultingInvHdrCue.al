table 50015 "IMP Job Consulting InvHdr Cue"
{
    Caption = 'IMP Job Consulting InvHdr Cue';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Created My Actul Period"; integer)
        {
            Caption = 'Create My Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(created), "Created by User" = field("Created by User"), "Document Date" = field("Date Filter")));
        }
        field(30; "Checked My All Actul Period"; integer)
        {
            Caption = 'Checked My All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(checked), "Created by User" = field("Created by User"), "Document Date" = field("Date Filter")));
        }
        field(40; "All My Actul Period"; integer)
        {
            Caption = 'All My Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where("Created by User" = field("Created by User"), "Document Date" = field("Date Filter")));
        }
        field(50; "Created All Actul Period"; integer)
        {
            Caption = 'Create All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(created), "Document Date" = field("Date Filter")));
        }
        field(60; "Checked All Actul Period"; integer)
        {
            Caption = 'Checked All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(checked), "Document Date" = field("Date Filter")));
        }
        field(70; "All Actul Period"; integer)
        {
            Caption = 'All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where("Document Date" = field("Date Filter")));
        }
        field(80; "Created All"; integer)
        {
            Caption = 'Create All';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(created)));
        }
        field(90; "Checked All"; integer)
        {
            Caption = 'Checked All';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(checked)));
        }
        field(100; "All"; integer)
        {
            Caption = 'All';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header");
        }

        field(110; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(120; "Created by User"; Code[50])
        {
            Caption = 'Created by User';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}