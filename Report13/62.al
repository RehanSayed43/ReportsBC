report 50121 "Sales Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'rrss';
    RDLCLayout = 'Sales9999999.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Nature_of_Supply; "Nature of Supply") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(GSTNO; GSTNO) { }

            
            column(CITY; CITY) { }

            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Location_State_Code; "Location State Code") { }
            column(Companyinfoname; Companyinfo.Name) { }
            column(CompanyinfoAddress; Companyinfo.Address) { }
            column(Companyinfogstno; Companyinfo."GST Registration No.") { }
            column(Companyinfocity; Companyinfo.City) { }
            column(Companyinfobankname; Companyinfo."Bank Name") { }
            column(Companyinfoaccno; Companyinfo."Bank Account No.") { }
            column(CompanyinfoIFSCCode; Companyinfo."Bank Branch No.") { }
            column(CompanyinfoSwiftcode; Companyinfo."SWIFT Code") { }
            column(CompanyinfoPANNO; Companyinfo."P.A.N. No.") { }


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRATE; CGSTRATE) { }
                column(SGSTRATE; SGSTRATE) { }
                column(IGSTRATE; IGSTRATE) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(AmninWrds; AmninWrds) { }
                column(GrandTotal; GrandTotal) { }


                // trigger OnAfterGetRecord()
                // var
                //     myInt: Integer;
                // begin
                //     customer.Reset();
                //     customer.SetRange("No.", "Sell-to Customer No.");
                //     if customer.Find('-') then begin
                //         GSTNO := customer."GST Registration No.";
                //         CITY := customer.City;
                //     end;

                //     SalesLines.Reset();
                //     SalesLines.SetRange("Document No.", "Sales Header"."No.");
                //     SalesLines.SetRange("Document Type", "Sales Header"."Document Type");
                //     "Sales Line".SetFilter("GST Group Code", '<>%1', '');
                //     if SalesLines.FindSet() then
                //         repeat
                //             //         TaxRecordId := "Sales Header".RecordId;


                //             //         TaxtransactionValue.Reset();
                //             //         TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                //             //         TaxtransactionValue.SetRange("Visible on Interface", true);
                //             //         TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                //             //         TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                //             //         TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                //             //         TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                //             //         if TaxtransactionValue.FindSet() then begin
                //             //             CGST := TaxtransactionValue.Amount;
                //             //             SGST := TaxtransactionValue.Amount;

                //             //             CGSTRATE := TaxtransactionValue.Percent;
                //             //             SGSTRATE := TaxtransactionValue.Percent;

                //             //             TotalCGST += CGST;
                //             //             TotalSGST += SGST;
                //             //         end else begin
                //             //             TaxtransactionValue.Reset();
                //             //             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                //             //             TaxtransactionValue.SetRange("Visible on Interface", true);
                //             //             TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                //             //             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                //             //             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                //             //             TaxtransactionValue.SetFilter("Value ID", '%1', 3);
                //             //             if TaxtransactionValue.FindSet() then
                //             //                 IGST := TaxtransactionValue.Amount;
                //             //             IGSTRATE := TaxtransactionValue.Percent;
                //             //             TotalIGST += IGST;

                //             //         end;
                //             //         Total += SalesLines.Amount;
                //             //         GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                //             //     until SalesLines.Next() = 0;
                //             // PostedVoucher.InitTextVariable();
                //             // PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
                //             // AmninWrds := AmountinWords[1] + AmountinWords[2];

                //             TaxTransactionValue.Reset();
                //             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                //             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                //             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                //             TaxTransactionValue.SetRange("Visible on Interface", true);
                //             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                //             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);

                //             if TaxTransactionValue.FindSet() then begin
                //                 CGSTRate := TaxTransactionValue.Percent;
                //                 SGSTRate := TaxTransactionValue.Percent;
                //                 CGST := TaxTransactionValue.Amount;
                //                 SGST := TaxTransactionValue.Amount;

                //                 TotalCGST += CGST;
                //                 TotalSGST += SGST;

                //             end else begin
                //                 TaxTransactionValue.Reset();
                //                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                //                 TaxTransactionValue.SetRange("Tax Type", '=%1', 'GST');
                //                 TaxTransactionValue.SetRange("Visible on Interface", true);
                //                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                //                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                //                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);

                //                 IF TaxTransactionValue.FindSet() then
                //                     IGSTRate := TaxTransactionValue.Percent;
                //                 IGST := TaxTransactionValue.Amount;

                //             end;
                //             Total += SalesLines.Amount;
                //             Taxtotal := TotalCGST + TotalSGST + TotalIGST;
                //             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                //         until SalesLines.Next() = 0;
                //     PostedVoucher.InitTextVariable();
                //     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
                //     AmninWrds := AmountinWords[1] + AmountinWords[2];



                // end;
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

                    SalesLines.Reset();
                    SalesLines.SetRange("Document No.", "Sales Header"."No.");
                    SalesLines.SetRange("Document Type", "Sales Header"."Document Type");
                    SalesLines.SetFilter("GST Group Code", '<>%1', '');
                    if SalesLines.FindSet() then
                        repeat
                            TaxRecordId := SalesLines.RecordId;


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

                                TotalCGST += CGST;
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
                            Total += SalesLines.Amount;
                            Taxtotal := TotalCGST + TotalSGST + TotalIGST;
                            GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                        until SalesLines.Next() = 0;
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
                    AmninWrds := AmountinWords[1] + AmountinWords[2];
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
        customer: Record Customer;
        SalesLines: Record "Sales Line";
        Sales: Record "Sales Header";

        GSTNO: Code[20];
        CITY: Text[30];
        Companyinfo: Record "Company Information";
        PostedVoucher: Report "Posted Voucher";
        TaxtransactionValue: Record "Tax Transaction Value";

        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRATE: Decimal;
        SGSTRATE: Decimal;
        IGSTRATE: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        AmountinWords: array[2] of Text;
        AmninWrds: Text;
        TaxRecordId: RecordId;
        Total: Decimal;
        Taxtotal: Decimal;
        GrandTotal: Decimal;

}