report 50112 "SalesReport_PagarriyaDemo"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'pagariya.rdl';
    Caption = 'ps5';






    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Posting_Dates; "Posting Date") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(Gstno; Gstno) { }
            column(Cityss; Cityss) { }
            column(Phonenoo; Phonenoo) { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_City; "Ship-to City") { }

            column(Companyinfoname; Companyinfo.Name) { }
            column(Companyinfoaddress; Companyinfo.Address) { }
            column(Companyinfogstno; Companyinfo."GST Registration No.") { }
            column(CompanyinfoCity; Companyinfo.City) { }
            column(CompanyinfoAddreess2; Companyinfo."Address 2") { }
            column(CompanyinfoPhone; Companyinfo."Phone No.") { }
            column(Companyinfoffsai; Companyinfo."VAT Registration No.") { }
            column(Companyinfoemail; Companyinfo."E-Mail") { }
            column(Companyinfostatecode; Companyinfo."State Code") { }
            column(Companyinfobankname; Companyinfo."Bank Name") { }
            column(Companyinfoaccno; Companyinfo."Bank Account No.") { }
            column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
            column(CompanyinfoSWIFTCode; Companyinfo."SWIFT Code") { }
            column(Companyinfoirnno; Companyinfo.IBAN) { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Posting_Date; "Posting Date") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }

                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRATE; CGSTRATE) { }
                column(SGSTRATE; SGSTRATE) { }
                column(IGSTRATE; IGSTRATE) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(Total; Total) { }
                column(AmntinWrds; AmntinWrds) { }
                column(Taxtotal; Taxtotal) { }
                column(Grandtotal; Grandtotal) { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        Gstno := customer."GST Registration No.";
                        Cityss := customer.City;
                        Phonenoo := customer."Phone No.";
                    end;

                    // Salesline.Reset();
                    // Salesline.SetRange("Document Type", "Sales Header"."Document Type");
                    // Salesline.SetRange("Document No.", "Sales Header"."No.");
                    // Salesline.SetFilter("GST Group Code", '<>%1', '');
                    // if Salesline.FindSet() then
                    //     repeat
                    //         TaxRecordId := "Sales Header".RecordId;

                    //         TaxTransactionValue.Reset();
                    //         TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    //         TaxTransactionValue.SetRange("Visible on Interface", true);
                    //         TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                    //         TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                    //         TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    //         TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                    //         if TaxTransactionValue.FindSet() then begin
                    //             CGSTRATE := TaxTransactionValue.Percent;
                    //             SGSTRATE := TaxTransactionValue.Percent;
                    //             CGST := TaxTransactionValue.Amount;
                    //             SGST := TaxTransactionValue.Amount;

                    //             TotalCGST += CGST;
                    //             TotalSGST += SGST;
                    //         end else begin
                    //             TaxTransactionValue.Reset();
                    //             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    //             TaxTransactionValue.SetRange("Visible on Interface", true);
                    //             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
                    //             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                    //             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    //             TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                    //             if TaxTransactionValue.FindSet() then
                    //                 IGST := TaxTransactionValue.Amount;
                    //             IGSTRATE := TaxTransactionValue.Percent;
                    //             TotalIGST += IGST;

                    //         end;
                    //         Total += salesline.Amount;
                    //         Taxtotal := TotalCGST + TotalSGST + TotalIGST;
                    //         GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                    //     until salesline.Next() = 0;
                    // PostedVoucher.InitTextVariable();
                    // PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
                    // AmntinWrds := AmountinWords[1] + AmountinWords[2];
                    Salesline.Reset();
                    Salesline.SetRange("Document No.", "Sales Header"."No.");
                    Salesline.SetRange("Document Type", "Sales Header"."Document Type");
                    Salesline.SetFilter("GST Group Code", '<>%1', '');
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
                            Total += salesline.Amount;
                            Taxtotal := TotalCGST + TotalSGST + TotalIGST;
                            GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
                        until salesline.Next() = 0;
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
        customer: Record Customer;
        Phonenoo: text[20];
        Cityss: Text[20];
        TaxTransactionValue: Record "Tax Transaction Value";
        AmntinWrds: Text;
        AmountinWords: array[2] of Text;
        Gstno: Code[20];
        Companyinfo: Record "Company Information";
        Salesline: Record "Sales Line";
        TaxRecordId: RecordId;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRATE: Decimal;
        SGSTRATE: Decimal;
        IGSTRATE: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        Taxtotal: Decimal;
        Total: Decimal;
        Grandtotal: Decimal;
        PostedVoucher: Report "Posted Voucher";
}