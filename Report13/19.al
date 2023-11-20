report 50148 "Posted Purchase 27/02 Invoices"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'UUUUUUUU';
    RDLCLayout = './purchaseinvoice1t.rdl';

    dataset
    {
        //POSTED PURCHASE INVOICES NOT DONE
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'posted purchase invoice';
            column(No_; "No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
            column(Location_State_Code; "Location State Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }


            column(CompanyInfoname; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfogstno; CompanyInfo."GST Registration No.") { }
            column(CompanyInfocity; CompanyInfo.City) { }
            column(CompanyInfoPhoneno; CompanyInfo."Phone No.") { }
            column(CompanyInfoEmail; CompanyInfo."E-Mail") { }
            column(CompanyInfocin; CompanyInfo.IBAN) { }
            column(CompanyInfoBankname; CompanyInfo."Bank Name") { }
            column(CompanyInfoBankAccno; CompanyInfo."Bank Account No.") { }
            column(CompanyInfoifsccode; CompanyInfo."Bank Branch No.") { }
            column(CompanyInfoSwiftcode; CompanyInfo."SWIFT Code") { }


            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Purch. Inv. Header";
                DataItemLink = "Document No." = field("No.");

                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Posting_Date; "Posting Date") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(SGSTRate; SGSTRate) { }
                column(CGSTRate; CGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(Amntinwrds; Amntinwrds) { }
                column(AmountinVendors; AmountinVendors) { }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    ClearData();
                    RecPurchase.Reset();
                    RecPurchase.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    RecPurchase.SetFilter("GST Group Code", '<>%1', '');
                    // RecPurchase.SetRange("Source Document Type","Purch. Inv. Header"."Applies-to Doc. Type");
                    if RecPurchase.FindSet() then
                        repeat
                            TaxRecordId := RecPurchase.RecordId;

                            TaxtransactionValue.Reset();
                            TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                            TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                            TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxtransactionValue.SetRange("Visible on Interface", true);
                            TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6.2);
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
                                TaxtransactionValue.SetFilter("Value ID", '%1', 3);
                            end;
                            Total := RecPurchase.Amount;
                        Until RecPurchase.Next() = 0;
                    AmountinVendors := Total + CGST + SGST + IGST;

                    PostedVoucher.InitTextVariable();
                    "Purch. Inv. Header".CalcFields(Amount);
                    PostedVoucher.FormatNoText(AmntinWords, Round(AmountinVendors), "Purch. Inv. Header"."Currency Code");
                    Amntinwrds := AmntinWords[1] + AmntinWords[2];


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
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        RecPurchase: Record "Purch. Inv. Line";
        Amount: Decimal;
        WholeAmount: Decimal;
        FractionalAmount: Decimal;
        Amntinwrds: Text;
        AmntinWords: array[2] of Text;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        Taxtotal: Decimal;
        Currency: code[20];
        TaxRecordId: RecordId;
        TaxtransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        AmountinVendors: Decimal;
        Total: Decimal;



    local procedure ClearData()
    var
        myInt: Integer;
    begin
        CGSTRate := 0;
        SGSTRate := 0;
        IGSTRate := 0;

        CGST := 0;
        SGST := 0;
        IGST := 0;

        TotalCGST := 0;
        TotalSGST := 0;
        TotalIGST := 0;

    end;



}