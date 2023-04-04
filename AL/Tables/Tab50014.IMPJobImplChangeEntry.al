
table 50014 "IMP Job Impl. Change Entry"
{
    Caption = 'Job Impl. Change Entry';
    LookupPageId = "IMP Job Change Entry List";
    DrillDownPageId = "IMP Job Change Entry List";


    fields
    {

        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job;
        }
        field(2; "Change No."; Code[3])
        {
            Caption = 'Change No.';
            DataClassification = CustomerContent;
        }
        field(3; "User ID"; code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
            TestTableRelation = false;
            ValidateTableRelation = false;
            NotBlank = true;
            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin




            end;


        }

        Field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;

        }
        Field(5; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

        }
        Field(6; "Implevit Cust Short Mark"; Code[10])
        {
            Caption = 'Implevit Cust Short Mark';
            DataClassification = CustomerContent;
        }





    }

    keys
    {
        key(Key1; "Job No.", "Implevit Cust Short Mark", "Change No.")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    var

        lc_Job:  Record Job;
        lc_Rec:  Record "IMP Job Impl. Change Entry";
        lc_Int:  Integer;

        lc_Err1: Label	'Es muss eine Implevitkürzel ausgewählt werden!';
        
        lc_Menu: Text[250];
    begin
        TESTFIELD("Job No.");
        lc_Job.GET("Job No.");

        IF "Implevit Cust Short Mark" = '' THEN BEGIN
            CASE lc_Job."IMP New Cust Short Mark" OF
                'IMXX':
                    BEGIN
                        lc_Menu := 'Implevit (IMPL)';
                        lc_Menu += ',Kasse (IMKA)';
                        lc_Menu += ',Kundenprojekt (IMKP)';
                        lc_Menu += ',Montageartikel (IMMA)';
                        lc_Menu += ',Add-In (IMAI)';
                        lc_Menu += ',Phpeppershop (IMPS)';
                        lc_Menu += ',Zeitplaner (IMZP)';
                        lc_Menu += ',Tools (IMTL)';
                        lc_Menu += ',Projekt (IMPJ)';
                        lc_Menu += ',Workflow (IMWF)';
                        lc_Menu += ',Fertigungsauftrag (IMFA)';
                        lc_Menu += ', E-Billing (IMEB)';
                        lc_Menu += ', Trade (IMTR)';
                        lc_Menu += ',Customer Servie (IMCS),Job (IMJB)';

                        CASE STRMENU(lc_Menu, 1)
                  OF
                            1: // 'Implevit (IMPL)'
                                "Implevit Cust Short Mark" := 'IMPL';
                            2: // 'Kasse (IMKA)'
                                "Implevit Cust Short Mark" := 'IMKA';
                            3: // 'Kundenprojekt (IMKP)'
                                "Implevit Cust Short Mark" := 'IMKP';
                            4: // 'Montageartikel (IMMA)'
                                "Implevit Cust Short Mark" := 'IMMA';
                            5: // 'Add-In (IMAI)'
                                "Implevit Cust Short Mark" := 'IMAI';
                            6: // 'Phpeppershop (IMPS)'
                                "Implevit Cust Short Mark" := 'IMPS';
                            7: // 'Zeitplaner (IMZP)'
                                "Implevit Cust Short Mark" := 'IMZP';
                            8: // 'Tools (IMTL)'
                                "Implevit Cust Short Mark" := 'IMTL';
                            9: // 'Projekt (IMPJ)'
                                "Implevit Cust Short Mark" := 'IMPJ';
                            10: // 'Workflow (IMWF)'
                                "Implevit Cust Short Mark" := 'IMWF';
                            11: // 'Montageauftrag (IMFA)'
                                "Implevit Cust Short Mark" := 'IMFA';
                            12: // 'E-Billing (IMEB)'
                                "Implevit Cust Short Mark" := 'IMEB';
                            13: // 'Trad (IMTR)'
                                "Implevit Cust Short Mark" := 'IMTR';
                            14: // 'Customer Servie (IMCS)'
                                "Implevit Cust Short Mark" := 'IMCS';
                            15: // 'Job (IMJB)'
                                "Implevit Cust Short Mark" := 'IMJB';
                        END;

                        IF "Implevit Cust Short Mark" = 'IMXX' THEN BEGIN
                            ERROR(lc_Err1);
                        END;

                      
                    END;
                'KTAG':
                    BEGIN
                        CASE STRMENU('ERP (KTER),International (KTIN),KTAG (Neues NAV 2017)', 1) OF
                            1: // 'ERP (KTER)'
                                "Implevit Cust Short Mark" := 'KTER';
                            2: // 'International (IMKA)'
                                "Implevit Cust Short Mark" := 'KTIN';
                            3: // 'Neues NAV 2017'
                                "Implevit Cust Short Mark" := 'KTAG';
                        END;
                    END;
                ELSE BEGIN
                    "Implevit Cust Short Mark" := lc_Job."IMP New Cust Short Mark";
                END;
            END;
        END;

        IF "Change No." = '' THEN BEGIN
            lc_Rec.RESET;
            lc_Rec.SETRANGE("Job No.", "Job No.");
            lc_Rec.SETRANGE("Implevit Cust Short Mark", "Implevit Cust Short Mark");
            IF lc_Rec.FINDLAST THEN BEGIN
                EVALUATE(lc_Int, lc_Rec."Change No.");
                "Change No." := FORMAT(lc_Int + 1);
                IF STRLEN("Change No.") = 1 THEN BEGIN
                    "Change No." := '00' + "Change No.";
                END ELSE BEGIN
                    IF STRLEN("Change No.") = 2 THEN BEGIN
                        "Change No." := '0' + "Change No.";
                    END;
                END;
            END ELSE BEGIN
                "Change No." := '001';
            END;
        END;

        "User ID" := USERID;
        "Creation Date" := WORKDATE;


    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}