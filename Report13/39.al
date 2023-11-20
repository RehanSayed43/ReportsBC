report 50144 "POSTED  SALES INVOICE"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Now';
    RDLCLayout = 'Postedsales.rdl';


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Posting_Date; "Posting Date") { }
            column(Nature_of_Supply; "Nature of Supply") { }
            column(Gstno; Gstno) { }
            column(Statesss; Statesss) { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_City; "Ship-to City") { }
            column(companyinfoname; companyinfo.Name) { }
            column(companyinfoaddress; companyinfo.Address) { }
            column(companyinfogstno; companyinfo."GST Registration No.") { }
            column(companyinfostatecode; companyinfo."State Code") { }
            column(companyinfobankname; companyinfo."Bank Name") { }
            column(companyinfobankaccno; companyinfo."Bank Account No.") { }
            column(companyinfobranchno; companyinfo."Bank Branch No.") { }
            column(companyinfoswiftcode; companyinfo."SWIFT Code") { }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Unit_Cost; "Unit Cost") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(ToatlCGST; ToatlCGST) { }
                column(TotalIGST; TotalIGST) { }
                column(ToatalSGST; ToatalSGST) { }
                column(Taxtotal; Taxtotal) { }
                column(Total; Total) { }
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
                        Statesss := customer.City;
                    end;


                    Saleslines.Reset();
                    Saleslines.SetRange("Document No.", "Sales Invoice Header"."No.");
                    Saleslines.SetFilter("GST Group Code", '<>%1', '');
                    if Saleslines.FindSet() then
                        repeat
                            TaxRecordid := "Sales Invoice Header".RecordId;

                            Taxtransactionvalue.Reset();
                            Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordid);
                            Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type");
                            Taxtransactionvalue.SetRange("Visible on Interface", true);
                            Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
                            Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
                            Taxtransactionvalue.SetFilter("Value ID", '%1|%2', 6, 3);
                            IF Taxtransactionvalue.FindSet() then begin
                                CGSTRate := Taxtransactionvalue.Percent;
                                SGSTRate := Taxtransactionvalue.Percent;
                                CGST := Taxtransactionvalue.Amount;
                                SGST := Taxtransactionvalue.Amount;

                                ToatlCGST += CGST;
                                ToatalSGST += SGST;
                            end else begin
                                Taxtransactionvalue.Reset();
                                Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordid);
                                Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
                                Taxtransactionvalue.SetRange("Visible on Interface", true);
                                Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
                                Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
                                Taxtransactionvalue.SetFilter("Value ID", '%1', 3);
                                if Taxtransactionvalue.FindSet() then
                                    IGSTRate := Taxtransactionvalue.Percent;
                                IGST := Taxtransactionvalue.Amount;
                                TotalIGST += IGST;

                            end;
                            Total += Saleslines.Amount;
                            // Total+=ToatlCGST+ToatalSGST+TotalIGST;
                            GrandTotal := Total + ToatlCGST + ToatalSGST + TotalIGST;
                        until Saleslines.Next() = 0;
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(Amountinwords, Round(GrandTotal), "Sales Invoice Header"."Currency Code");
                    AmntinWrds := Amountinwords[1] + Amountinwords[2];




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



    var
        myInt: Integer;
        Gstno: Code[20];
        Statesss: Text[30];
        customer: Record Customer;
        companyinfo: Record "Company Information";
        Amountinwords: array[2] of Text;
        AmntinWrds: Text;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        ToatlCGST: Decimal;
        ToatalSGST: Decimal;
        TotalIGST: Decimal;
        PostedVoucher: Report "Posted Voucher";
        Saleslines: Record "Sales Invoice Line";
        Taxtransactionvalue: Record "Tax Transaction Value";
        TaxRecordid: RecordId;
        Currency: Code[20];
        Taxtotal: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;


}