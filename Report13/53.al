report 50120 "Purchase_Order"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'PO11';
    DefaultLayout = RDLC;

    RDLCLayout = 'PurchaseOR.rdl';

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
            column(Pay_to_Post_Code; "Pay-to Post Code") { }
            column(Pay_to_City; "Pay-to City") { }
            column(Location_State_Code; "Location State Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Posting_Date; "Posting Date") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Pay_to_Contact; "Pay-to Contact") { }

            column(compnayinfoName; compnayinfo.Name) { }
            column(compnayinfoAddress; compnayinfo.Address) { }
            column(compnayinfogstno; compnayinfo."GST Registration No.") { }
            column(compnayinfoCIN; compnayinfo.IBAN) { }
            column(compnayinfoCity; compnayinfo.City) { }
            column(compnayinfoemail; compnayinfo."E-Mail") { }
            column(compnayinfobankname; compnayinfo."Bank Name") { }
            column(compnayinfoaccno; compnayinfo."Bank Account No.") { }
            column(compnayinfoIFSCcode; compnayinfo."Bank Branch No.") { }
            column(compnayinfoswiftcode; compnayinfo."SWIFT Code") { }
            column(compnayinfopanno; compnayinfo."P.A.N. No.") { }
            column(compnayinfostatecode; compnayinfo."State Code") { }



            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Unit_Cost; "Unit Cost") { }

                column(Line_Amount; "Line Amount") { }
                column(Order_Date; "Order Date") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(Total; Total) { }
                column(AmounttoVendor; AmounttoVendor) { }
                column(AmntinWrds; AmntinWrds) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
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

                                TotalIGST += IGST;
                            end;
                            Total := Total + PurchaseLine.Amount;
                        until PurchaseLine.Next() = 0;
                    AmounttoVendor := Total + CGST + SGST + IGST;

                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(AmounttoVendor), "Purchase Header"."Currency Code");
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
        compnayinfo.get();
    end;



    var
        myInt: Integer;
        compnayinfo: Record "Company Information";
        TaxTransactionValue: Record "Tax Transaction Value";
        Purchaseline: Record "Purchase Line";
        PostedVoucher: Report "Posted Voucher";
        Vendor: Record Vendor;
        TaxRecordId: RecordId;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        IGSTRate: Decimal;
        SGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        Taxtotal: Decimal;
        Total: Decimal;
        AmounttoVendor: Decimal;
        Amountinwords: array[2] of Text;
        AmntinWrds: Text;

}