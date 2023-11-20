report 50114 Report31
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'saless009.rdl';
    Caption = 'Sales7861';
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(GstNo; GstNo) { }
            column(Cityname; Cityname) { }
            column(Posting_Date; "Posting Date") { }
            column(Nature_of_Supply; "Nature of Supply") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(CompanyInformationname; CompanyInformation.Name) { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationStateCode; CompanyInformation."State Code") { }

            column(CompanyInformationaddress; CompanyInformation.Address) { }
            column(CompanyInformationgstno; CompanyInformation."GST Registration No.") { }
            column(CompanyInformationBankname; CompanyInformation."Bank Name") { }
            column(CompanyInformationBankAccno; CompanyInformation."Bank Account No.") { }
            column(CompanyInformationBranchno; CompanyInformation."Bank Branch No.") { }
            column(CompanyInformationSWIFTCode; CompanyInformation."SWIFT Code") { }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
                column(CGSTRATE; CGSTRATE) { }
                column(SGSTRATE; SGSTRATE) { }
                column(IGSTRATE; IGSTRATE) { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(TOTALCGST; TOTALCGST) { }
                column(TOTALSGST; TOTALSGST) { }
                column(TOTALIGST; TOTALIGST) { }
                column(AmntinWrds; AmntinWrds) { }
                column(GrandTotal; GrandTotal) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Customer.Reset();
                    Customer.SetRange("No.", "Sell-to Customer No.");
                    if Customer.Find() then begin
                        GstNo := Customer."GST Registration No.";
                        Cityname := Customer.City;
                    end;
                    Sales.Reset();
                    Sales.SetRange("Document No.", "Sales Invoice Header"."No.");
                    Sales.SetFilter("GST Group Code", '<>%1', '');
                    if Sales.FindSet() then
                        repeat
                            TaxRecordid := "Sales Invoice Header".RecordId;

                            Tax.Reset();
                            Tax.SetRange("Tax Record ID", TaxRecordid);
                            Tax.SetRange("Value Type", Tax."Value Type"::COMPONENT);
                            Tax.SetRange("Visible on Interface", true);
                            Tax.SetFilter("Tax Type", '=%1', 'GST');
                            Tax.SetFilter(Percent, '<>%1', 0);
                            Tax.SetFilter("Value ID", '%1|%2', 6, 2);
                            if Tax.FindSet() then begin
                                CGST := Tax.Amount;
                                SGST := Tax.Amount;
                                CGSTRATE := Tax.Percent;
                                SGSTRATE := Tax.Percent;
                                TOTALCGST += CGST;
                                TOTALSGST += SGST;
                            end else begin
                                Tax.Reset();
                                Tax.SetRange("Tax Record ID", TaxRecordid);
                                Tax.SetRange("Value Type", Tax."Value Type"::COMPONENT);
                                Tax.SetRange("Visible on Interface", true);
                                Tax.SetFilter("Tax Type", '=%1', 'GST');
                                Tax.SetFilter(Percent, '<>%1', 0);
                                Tax.SetFilter("Value ID", '%1', 3);
                                if Tax.FindSet() then
                                    IGSTRATE := Tax.Percent;
                                IGST := Tax.Amount;
                                TOTALIGST += IGST;
                            end;

                            Total += Sales.Amount;
                            GrandTotal := Total + TOTALCGST + TOTALSGST + TOTALIGST;
                        until Sales.Next() = 0;
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Invoice Header"."Currency Code");
                    AmntinWrds := AmountinWords[1] + AmountinWords[2];




                end;

            }

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
        CompanyInformation.get();

    end;



    var
        myInt: Integer;
        Customer: Record Customer;
        GstNo: Code[20];
        Cityname: Text[30];
        TaxRecordid: RecordId;
        PostedVoucher: Report "Posted Voucher";
        Tax: Record "Tax Transaction Value";
        Sales: Record "Sales Invoice Line";
        CompanyInformation: Record "Company Information";
        CGSTRATE: Decimal;
        SGSTRATE: Decimal;
        IGSTRATE: Decimal;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        TOTALCGST: Decimal;
        TOTALSGST: Decimal;
        TOTALIGST: Decimal;
        AmountinWords: array[2] of Text;
        AmntinWrds: Text;
        TaxTotal: Decimal;
        Total: Decimal;

        GrandTotal: Decimal;
}
