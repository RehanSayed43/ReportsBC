report 50145 "Sales Invoices 27/02  Reports"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Ttttt';
    RDLCLayout = './SalesInvoicesReports1T.rdl';

    dataset
    {
        //SALES INVOICE ORDER REPORT
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Posting_Date; "Posting Date") { }
            column(Location_State_Code; "Location State Code") { }
            column(Gstno; Gstno) { }
            column(StateName; StateName) { }


            column(companyinfoname; companyinfo.Name) { }
            column(companyinfoAddress; companyinfo.Address) { }
            column(companyinfoCity; companyinfo.City) { }
            column(companyinfogstno; companyinfo."GST Registration No.") { }
            column(companyinfopanno; companyinfo."P.A.N. No.") { }
            column(companyinfoBankname; companyinfo."Bank Name") { }
            column(companyinfobankaccno; companyinfo."Bank Account No.") { }
            column(companyinfoifssccode; companyinfo."Bank Branch No.") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Line_Amount; "Line Amount") { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(SGST; SGST) { }
                column(CGST; CGST) { }
                column(IGST; IGST) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(TaxTotal; TaxTotal) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(AmntinWrds; AmntinWrds) { }
                column(GrandTotal; GrandTotal) { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        Gstno := customer."GST Registration No.";
                        StateName := customer.City;
                    end;
                    if "Sales Header"."Currency Code" <> '' then begin
                        Currency := "Sales Header"."Currency Code";
                    end else begin
                        Currency := 'INR';
                    end;

                    RecSales.Reset();
                    RecSales.SetRange("Document Type", "Sales Header"."Document Type");
                    RecSales.SetRange("Document No.", "Sales Header"."No.");
                    RecSales.SetFilter("GST Group Code", '<>%1', '');
                    if RecSales.FindSet() then
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
                                IGST := TaxTransactionValue.Amount;
                                TotalIGST += IGST;
                            end;
                            Total := Total + RecSales.Amount;
                            TaxTotal += TotalCGST + TotalSGST + TotalIGST;
                            GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                        until RecSales.Next() = 0;


                    if "Sales Header"."Currency Code" <> '' then begin
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.FormatNoText(Amountinwords, Round(GrandTotal), "Sales Header"."Currency Code");
                        AmntinWrds := Amountinwords[1] + Amountinwords[2];
                    end else begin
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.FormatNoText(Amountinwords, Round(GrandTotal), '');
                        AmntinWrds := Amountinwords[1] + Amountinwords[2];
                    end;








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
        companyinfo.get();
    end;



    var
        myInt: Integer;
        customer: Record Customer;
        Currency: Code[20];
        companyinfo: Record "Company Information";
        RecSales: Record "Sales Line";
        TaxTransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        TaxRecordId: RecordId;
        Gstno: Code[20];
        StateName: Text[30];
        Amount: Decimal;
        WholeAmount: Decimal;
        FractionalAmount: Decimal;
        Amountinwords: array[2] of Text;
        AmntinWrds: Text;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        SGSTRate: Decimal;
        CGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalIGST: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TaxTotal: Decimal;
        GrandTotal: Decimal;
        Total: Decimal;


}