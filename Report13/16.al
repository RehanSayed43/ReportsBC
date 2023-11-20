report 50126 "Purchase Order"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'ooooooooooo';
    RDLCLayout = './purchaseee.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
            column(Location_State_Code; "Location State Code") { }
            column(Posting_Date; "Posting Date") { }
            column(States; States) { }
            column(PostCode; PostCode) { }

            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoGst; CompanyInfo."GST Registration No.") { }
            column(CompanyInfoCity; CompanyInfo.City) { }
            column(CompanyInfoPanno; CompanyInfo."P.A.N. No.") { }
            column(AmntinWrds; AmntinWrds) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(SGSTRate; SGSTRate) { }
                column(CGSTRate; CGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(TaxTotal; TaxTotal) { }
                column(Total; Total) { }
                column(AmounToVendors; AmounToVendors) { }

                // column(GrandTotal; GrandTotal) { }


                trigger OnAfterGetRecord()
                var
                    // if "Purchase Header"."Currency Code" <> '' then begin
                    //     currency := "Purchase Header"."Currency Code";
                    // end else begin
                    //     currency := 'INR';
                    // end;
                    myInt: Integer;
                begin
                    if "Purchase Header"."Currency Code" <> '' then begin
                        currency := "Purchase Header"."Currency Code";
                    end else begin
                        currency := 'INR';
                    end;



                    Vendor.Reset();
                    Vendor.SetRange("No.", "Buy-from Vendor No.");
                    if Vendor.Find('-') then begin
                        States := Vendor.City;
                        PostCode := Vendor."Post Code";
                    end;

                    // if "Purchase Header"."Currency Code" <> '' then begin
                    //     Currency := "Purchase Header"."Currency Code";

                    // end else begin
                    //     Currency := 'INR';
                    // end;
                    clearData();

                    Purchase.Reset();
                    Purchase.SetRange("Document Type", "Purchase Header"."Document Type");
                    Purchase.SetRange("Document No.", "Purchase Header"."No.");
                    Purchase.SetFilter("GST Group Code", '<>%1', '');
                    if Purchase.FindSet() then
                        repeat
                            TaxRecordID := Purchase.RecordId;

                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
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
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
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
                            Total += "Purchase Line".Amount;
                        until Purchase.Next() = 0;

                    //TaxTotal += TotalCGST + TotalIGST + TotalSGST;
                    AmounToVendors := Total + TotalCGST + TotalIGST + TotalSGST;
                    // until Purchase.Next() = 0;


                    PostedVoucher.InitTextVariable();
                    "Purchase Header".CalcFields(Amount);
                    PostedVoucher.FormatNoText(Amountinwords, Round(AmounToVendors), "Purchase Header"."Currency Code");
                    AmntinWrds := Amountinwords[1] + Amountinwords[2];
                    // end else begin
                    //     PostedVoucher.InitTextVariable();
                    //     PostedVoucher.FormatNoText(Amountinwords, Round(GrandTotal), '');
                    //     AmntinWrds := Amountinwords[1] + Amountinwords[2];
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
        CompanyInfo.get();
    end;
    // procedure CalculateGST(PL: Record "Purchase Line")
    // var
    // begin


    //     Purchase: Record "Purchase Line";
    //     TaxRecordID: RecordId;
    //     TaxTransactionValue: Record "Tax Transaction Value";
    //     TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
    //     ComponentAmt: Decimal;
    // end;



    var
        myInt: Integer;
        Vendor: Record Vendor;

        CompanyInfo: Record "Company Information";
        TaxTransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        Amountinwords: array[2] of Text;
        AmntinWrds: Text;
        TaxRecordID: RecordId;
        Amount: Decimal;
        States: Text[30];
        PostCode: Code[20];
        Currency: Code[20];
        Purchase: Record "Purchase Line";

        WholeAmount: Decimal;
        FractionlAmount: Decimal;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TaxTotal: Decimal;
        Total: Decimal;
        AmounToVendors: Decimal;


    local procedure clearData()
    var
        myInt: Integer;
    begin
        CGST := 0;
        IGST := 0;
        SGST := 0;

        CGSTRate := 0;
        IGSTRate := 0;
        SGSTRate := 0;

        TotalCGST := 0;
        TotalIGST := 0;
        TotalSGST := 0;
        Clear(Amountinwords);
        AmounToVendors := 0;

    end;

}