report 50149 "Sales Order 28/02/23 CR"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'nnnnnnnnnnn';
    RDLCLayout = './salesoredr2T.rdl';

    dataset
    {
        //Sales Order
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(Gstno; Gstno) { }
            column(Statename; Statename) { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(CompanyinfoName; Companyinfo.Name) { }
            column(CompanyinfoAddress; Companyinfo.Address) { }
            column(CompanyinfoCity; Companyinfo.City) { }
            column(Companyinfogstno; Companyinfo."GST Registration No.") { }
            column(CompanyinfoEmail; Companyinfo."E-Mail") { }
            column(CompanyinfoPanno; Companyinfo."P.A.N. No.") { }
            column(CompanyinfoBankname; Companyinfo."Bank Name") { }
            column(CompanyinfoAccoutnno; Companyinfo."Bank Account No.") { }
            column(Companyinfoifsc; Companyinfo."Bank Branch No.") { }
            column(CompanyinfoCin; Companyinfo.IBAN) { }
            column(CompanyinfoSwiftcode; Companyinfo."SWIFT Code") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Cost") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(AmntinWrds; AmntinWrds) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(TaxTotal; TaxTotal) { }
                column(Total; Total) { }
                column(GrandTotal; GrandTotal) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        Gstno := customer."GST Registration No.";
                        Statename := customer.City;

                    end;

                    if "Sales Header"."Currency Code" <> '' then begin
                        Currency := "Sales Header"."Currency Code";
                    end else begin
                        Currency := 'INR';
                    end;

                    Sales.Reset();
                    Sales.SetRange("Document Type", "Sales Header"."Document Type");
                    Sales.SetRange("Document No.", "Sales Header"."No.");
                    Sales.SetFilter("GST Group Code", '<>%1', '');
                    if Sales.FindSet() then
                        repeat
                            TaxRecordId := Sales.RecordId;

                            TaxtransactionValue.Reset();
                            TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                            TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                            TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxtransactionValue.SetRange("Visible on Interface", true);
                            TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                            if TaxtransactionValue.FindSet() then begin
                                CGSTRate := TaxtransactionValue.Percent;
                                SGSTRate := TaxtransactionValue.Percent;
                                CGST := TaxtransactionValue.Amount;
                                SGST := TaxtransactionValue.Amount;

                                TotalCGST += CGST;
                                TotalSGST += SGST;
                            end else begin
                                TaxtransactionValue.Reset();
                                TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                                TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                                TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxtransactionValue.SetRange("Visible on Interface", true);
                                if TaxtransactionValue.FindSet() then
                                    IGSTRate := TaxtransactionValue.Percent;
                                IGST := TaxtransactionValue.Amount;
                                TotalIGST += IGST;
                            end;
                            Total := Total + Sales.Amount;
                            GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                        until Sales.Next() = 0;

                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
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
        Companyinfo.get();
    end;



    var
        myInt: Integer;
        Gstno: Code[20];
        Statename: Text[30];
        TaxRecordId: RecordId;
        customer: Record Customer;
        Companyinfo: Record "Company Information";
        TaxtransactionValue: Record "Tax Transaction Value";
        AmountinWords: array[2] of Text;
        AmntinWrds: Text;
        Sales: Record "Sales Line";
        Currency: Code[20];

        PostedVoucher: Report "Posted Voucher";
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TaxTotal: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;

}