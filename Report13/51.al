report 50107 gk
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    RDLCLayout = 'fagrp.rdl';


    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = sorting("No.");
            column(DescriptionTitle; Description) { }
            column(FA_Subclass_Code; "FA Subclass Code") { }
            column(companyinfoname; companyinfo.Name) { }



            dataitem("FA Depreciation Book"; "FA Depreciation Book")
            {
                DataItemLinkReference = "Fixed Asset";
                DataItemLink = "FA No." = field("No.");
                column(FA_No_; "FA No.") { }
                column(Descriptions; Description) { }
                column(Acquisition_Cost; "Acquisition Cost") { }
                column(Depreciation; Depreciation) { }
                column(Book_Value; "Book Value") { }
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                AccuistionCost := glAcc.Balance;
                if not FADeprBook.Get("No.", DeprBookCode) then
                    CurrReport.Skip();



            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date when you want the report to start.';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date when you want the report to end.';
                    }
                    field(GroupTotals; GroupTotals)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Group Totals';
                        OptionCaption = ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group';
                        ToolTip = 'Specifies if you want the report to group fixed assets and print totals using the category defined in this field. For example, maintenance expenses for fixed assets can be shown for each fixed asset class.';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        companyinfo.get();
    end;


    var
        myInt: Integer;
        glAcc: Record "G/L Account";
        FAS: Record "FA Posting Group";
        Text007: Label '%1 has been modified in fixed asset %2.';
        companyinfo: Record "Company Information";
        Text1: Label 'Fixed Asset Report';
        AccuistionCost: Decimal;
        PrintDetails: Boolean;
        StartingDate: Date;
        EndingDate: Date;
        GroupTotals: Option " ","FA Class","FA Subclass","FA Location","Main Asset","Global Dimension 1","Global Dimension 2","FA Posting Group";
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FA: Record "Fixed Asset";
        FAPostingTypeSetup: Record "FA Posting Type Setup";
        FAGenReport: Codeunit "FA General Report";
        BudgetDepreciation: Codeunit "Budget Depreciation";
        DeprBookCode: Code[10];
        FAFilter: Text;
        BookValueAtStartingDate: Decimal;
        BookValueAtEndingDate: Decimal;
        i: Integer;
        j: Integer;
        NumberOfTypes: Integer;
        PostingType: Integer;
        Period1: Option "Before Starting Date","Net Change","at Ending Date";
        Period2: Option "Before Starting Date","Net Change","at Ending Date";

        BudgetReport: Boolean;
        BeforeAmount: Decimal;
        EndingAmount: Decimal;
        AcquisitionDate: Date;
        DisposalDate: Date;
        StartText: Text[30];
        EndText: Text[30];

}