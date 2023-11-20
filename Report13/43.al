report 50130 "salesheader"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'rehna.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(GSTno; GSTno) { }
            column(Posting_Date; "Posting Date") { }
            column(Nature_of_Supply; "Nature of Supply") { }

            column(City; City) { }
            column(Location_State_Code; "Location State Code") { }
            column(companyname; company.Name) { }
            column(companyaddress; company.Address) { }
            column(companygstno; company."GST Registration No.") { }
            column(companyStateCode; company."State Code") { }
            column(companybankname; company."Bank Name") { }
            column(companyAccno; company."Bank Account No.") { }
            column(companyBankBranchno; company."Bank Branch No.") { }
            column(companySwiftcode; company."SWIFT Code") { }
            column(companypanno; company."P.A.N. No.") { }
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
                column(TotlCGST; TotlCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(AmntinWrds; AmntinWrds) { }
                column(Taxtotal; Taxtotal) { }
                column(TotalIGST; TotalIGST) { }
                column(GrandTotal; GrandTotal) { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        GSTno := customer."GST Registration No.";
                        City := customer.City;
                    end;

                    salesline.Reset();
                    salesline.SetRange("Document No.", "Sales Header"."No.");
                    salesline.SetRange("Document Type", "Sales Header"."Document Type");
                    salesline.SetFilter("GST Group Code", '<>%1', '');
                    if salesline.FindSet() then
                        repeat
                            TaxRecordId := salesline.RecordId;


                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                            TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionValue.SetRange("Visible on Interface", true);
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                            TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);

                            if TaxTransactionValue.FindSet() then begin
                                CGSTRate := TaxTransactionValue.Percent;
                                SGSTRate := TaxTransactionValue.Percent;
                                CGST := TaxTransactionValue.Amount;
                                SGST := TaxTransactionValue.Amount;

                                TotlCGST += CGST;
                                TotalSGST += SGST;

                            end else begin
                                TaxTransactionValue.Reset();
                                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                                TaxTransactionValue.SetRange("Tax Type", '=%1', 'GST');
                                TaxTransactionValue.SetRange("Visible on Interface", true);
                                TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);

                                IF TaxTransactionValue.FindSet() then
                                    IGSTRate := TaxTransactionValue.Percent;
                                IGST := TaxTransactionValue.Amount;

                            end;
                            Total += salesline.Amount;
                            Taxtotal := TotlCGST + TotalSGST + TotalIGST;
                            GrandTotal := Total + TotlCGST + TotalSGST + TotalIGST;
                        until salesline.Next() = 0;
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmnountinWrds, Round(GrandTotal), "Sales Header"."Currency Code");
                    AmntinWrds := AmnountinWrds[1] + AmnountinWrds[2];
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
        company.get();
    end;



    var
        myInt: Integer;
        company: Record "Company Information";
        salesline: Record "Sales Line";
        TaxRecordId: RecordId;
        GSTno: Code[20];
        City: Text[30];
        customer: Record Customer;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        TotlCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        AmntinWrds: Text;
        AmnountinWrds: array[2] of text;
        TaxTransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        Taxtotal: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;

}