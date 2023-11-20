report 50146 "Sales Credit memo"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'poooooo';
    RDLCLayout = './salescreditmemo.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Ship_to_Address; "Ship-to Address") { }

            column(gstno; gstno) { }

            column(ComapnyinfoName; Comapnyinfo.Name) { }
            column(ComapnyinfoAddress; Comapnyinfo.Address) { }
            column(Comapnyinfogstno; Comapnyinfo."GST Registration No.") { }
            column(ComapnyinfoCity; Comapnyinfo.City) { }
            column(ComapnyinfoPhoneno; Comapnyinfo."Phone No.") { }
            column(ComapnyinfoEmail; Comapnyinfo."E-Mail") { }
            column(ComapnyinfoBankname; Comapnyinfo."Bank Name") { }
            column(ComapnyinfoAccountno; Comapnyinfo."Bank Account No.") { }
            column(Comapnyinfoifsccode; Comapnyinfo."Bank Branch No.") { }
            column(Comapnyinfopanno; Comapnyinfo."P.A.N. No.") { }
            column(Comapnyinfo; Comapnyinfo."SWIFT Code") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(TaxTotal; TaxTotal) { }
                column(CGSTtxt; CGSTtxt) { }
                column(SGSTtxt; SGSTtxt) { }
                column(IGSTtxt; IGSTtxt) { }
                column(Total; Total) { }
                column(AmninWrds; AmninWrds) { }
                column(GrandTotal; GrandTotal) { }





                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        gstno := customer."GST Registration No.";
                    end;
                    if "Sales Header"."Currency Code" <> '' then begin
                        Currency := "Sales Header"."Currency Code";
                    end else begin
                        Currency := 'INR';
                    end;

                    sales.Reset();
                    sales.SetRange("Document Type", "Sales Header"."Document Type");
                    sales.SetRange("Document No.", "Sales Header"."No.");
                    sales.SetFilter("GST Group Code", '<>%1', '');
                    if sales.FindSet() then
                        repeat
                            TaxRecordId := "Sales Line".RecordId;
                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                            TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionValue.SetRange("Visible on Interface", true);
                            TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                            if TaxTransactionValue.FindSet() then begin
                                CGSTRate := TaxTransactionValue.Percent;
                                SGSTRate := TaxTransactionValue.Percent;

                                CGSTtxt := 'CGST';
                                SGSTtxt := 'SGST';
                                CGST := TaxTransactionValue.Amount;
                                SGST := TaxTransactionValue.Amount;
                                TotalCGST += CGST;
                                TotalSGST += SGST;

                            end else begin
                                TaxTransactionValue.Reset();
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                                TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxTransactionValue.SetRange("Visible on Interface", true);
                                TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                                if TaxTransactionValue.FindSet() then
                                    IGSTRate := TaxTransactionValue.Percent;
                                IGSTtxt := 'IGST';
                                IGST := TaxTransactionValue.Amount;

                                TotalIGST := IGST;
                            end;
                            Total := Total + sales.Amount;
                            TaxTotal += TotalCGST + TotalSGST + TotalIGST;
                            GrandTotal := Total + TaxTotal;
                        until sales.Next() = 0;

                    // if "Sales Header"."Currency Code" <> '' then begin
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmntinWords, Round(GrandTotal), "Sales Header"."Currency Code");
                    AmninWrds := AmntinWords[1] + AmntinWords[2];
                    // end else begin
                    //     PostedVoucher.InitTextVariable();
                    //     PostedVoucher.FormatNoText(AmntinWords, Round(GrandTotal), '');
                    // end;

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
        Comapnyinfo.get();
    end;



    var
        myInt: Integer;
        gstno: Code[20];
        Currency: Code[20];
        customer: Record Customer;
        Comapnyinfo: Record "Company Information";
        PostedVoucher: Report "Posted Voucher";
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxRecordId: RecordId;
        sales: Record "Sales Line";
        Amount: Decimal;
        WholeAmount: Decimal;
        FractionalAmount: Decimal;
        AmntinWords: array[2] of Text;
        AmninWrds: Text;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        SGSTRate: Decimal;
        CGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        IGSTtxt: text[10];
        CGSTtxt: text[10];
        SGSTtxt: text[10];
        TotalIGST: Decimal;
        Total: Decimal;
        TaxTotal: Decimal;
        GrandTotal: Decimal;


}