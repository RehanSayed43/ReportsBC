report 50109 "Purchase invoice Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'eeeessssss';

    RDLCLayout = 'purchase3423s.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(EncodeStr; EncodeStr) { }
            column(GSTNO; GSTNO) { }
            column(CITY; CITY) { }
            column(Posting_Date; "Posting Date") { }
            column(Pay_to_Contact; "Pay-to Contact") { }
            column(companyinformationname; companyinformation.Name) { }
            column(companyinformationaddress; companyinformation.Address) { }
            column(companyinformationgstno; companyinformation."GST Registration No.") { }
            column(companyinformationCity; companyinformation.City) { }
            column(companyinformationstatecode; companyinformation."State Code") { }
            column(companyinformationbankname; companyinformation."Bank Name") { }
            column(companyinformationbankaccno; companyinformation."Bank Account No.") { }
            column(companyinformationbankbranchno; companyinformation."Bank Branch No.") { }
            column(companyinformationswiftcode; companyinformation."SWIFT Code") { }
            column(companyinformationpanno; companyinformation."P.A.N. No.") { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(AmntinWrds; AmntinWrds) { }
                column(ToalIGST; ToalIGST) { }
                column(Taxtotal; Taxtotal) { }
                column(Grandtotal; Grandtotal) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;

                    BarcodeStr: Code[20];
                    BarcodeSymbology: Enum "Barcode Symbology";
                    BarcodeFontProvider: Interface "Barcode Font Provider";
                begin
                    BarcodeStr := "No.";
                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                    BarcodeFontProvider.ValidateInput(BarcodeStr, BarcodeSymbology);
                    EncodeStr := BarcodeFontProvider.EncodeFont(BarcodeStr, BarcodeSymbology);

                    Vendor.Reset();
                    Vendor.SetRange("No.", "Buy-from Vendor No.");
                    if Vendor.Find('-') then begin
                        GSTNO := Vendor."GST Registration No.";
                        CITY := Vendor.City;
                    end;

                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                    "Purchase Line".SetRange("Document Type", "Purchase Header"."Document Type");
                    if PurchaseLine.FindSet() then
                        repeat
                            TaxRecordId := PurchaseLine.RecordId;
                            TaxtransactionValue.Reset();
                            TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                            TaxtransactionValue.SetRange("Visible on Interface", true);
                            TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                            TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                            IF TaxtransactionValue.FindSet() then begin
                                CGSTRate := TaxtransactionValue.Percent;
                                SGSTRate := TaxtransactionValue.Percent;

                                CGST := TaxtransactionValue.Amount;
                                SGST := TaxtransactionValue.Amount;


                                TotalCGST += CGST;
                                TotalSGST += SGST;
                            end else begin
                                TaxtransactionValue.Reset();
                                TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                                TaxtransactionValue.SetRange("Visible on Interface", true);
                                TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
                                TaxtransactionValue.SetFilter("Value ID", '%1', 3);
                                IF TaxtransactionValue.FindSet() then
                                    IGSTRate := TaxtransactionValue.Percent;
                                IGST := TaxtransactionValue.Amount;

                                ToalIGST += IGST;


                            end;
                            Total := Total + PurchaseLine.Amount;
                        until PurchaseLine.Next() = 0;
                    Grandtotal := Total + CGST + SGST + IGST;

                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(Grandtotal), "Purchase Header"."Currency Code");
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
        companyinformation.get();
    end;



    var
        myInt: Integer;
        companyinformation: Record "Company Information";
        EncodeStr: Text;
        Vendor: Record Vendor;
        TaxtransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        PurchaseLine: Record "Purchase Line";
        TaxRecordId: RecordId;
        AmountinWords: array[2] of text;
        AmntinWrds: Text;

        GSTNO: Code[20];
        CITY: Text[30];
        Amount: Decimal;
        FractionalAmount: Decimal;
        WholeAmount: Decimal;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        ToalIGST: Decimal;
        Taxtotal: Decimal;
        Total: Decimal;
        Grandtotal: Decimal;
}