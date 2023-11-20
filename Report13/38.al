report 50125 "Purchase Reportss"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'ryyy';
    RDLCLayout = 'purchaser345.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Posting_Date; "Posting Date") { }
            column(Barcode; Encodestr) { }

            column(Location_GST_Reg__No_; "Location GST Reg. No.") { }
            column(Location_State_Code; "Location State Code") { }
            column(Nature_of_Supply; "Nature of Supply") { }
            column(Compnayinfoname; Compnayinfo.Name) { }
            column(Compnayinfoaddress; Compnayinfo.Address) { }
            column(Compnayinfogstno; Compnayinfo."GST Registration No.") { }
            column(Compnayinfostatecode; Compnayinfo."State Code") { }
            column(Compnayinfobankname; Compnayinfo."Bank Name") { }
            column(Compnayinfobankaccno; Compnayinfo."Bank Account No.") { }
            column(Compnayinfobankbranchnno; Compnayinfo."Bank Branch No.") { }
            column(Compnayinfoswiftcode; Compnayinfo."SWIFT Code") { }
            column(Compnayinfocity; Compnayinfo.City) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(Amninwrds; Amninwrds) { }
                column(Amouninvendor; Amouninvendor) { }


                trigger OnAfterGetRecord()
                var


                begin
                    Recpurchaseline.Reset();
                    Recpurchaseline.SetRange("Document No.", "Purchase Header"."No.");
                    Recpurchaseline.SetRange("Document Type", "Purchase Header"."Document Type");
                    Recpurchaseline.SetFilter("GST Group Code", '<>%1', '');
                    if Recpurchaseline.FindSet() then
                        repeat
                            TaxRcordid := "Purchase Line".RecordId;

                            TaxTransactionvalue.Reset();
                            TaxTransactionvalue.SetRange("Value Type", TaxTransactionvalue."Value Type"::COMPONENT);
                            TaxTransactionvalue.SetRange("Visible on Interface", true);
                            TaxTransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxTransactionvalue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionvalue.SetRange("Tax Record ID", TaxRcordid);
                            TaxTransactionvalue.SetFilter("Value ID", '%1|%2', 6, 2);
                            IF TaxTransactionvalue.FindSet() then begin
                                CGSTRate := TaxTransactionvalue.Percent;
                                SGSTRate := TaxTransactionvalue.Percent;

                                CGST := TaxTransactionvalue.Amount;
                                SGST := TaxTransactionvalue.Amount;

                                TotalCGST += CGST;
                                TotalSGST += SGST;
                            end else begin

                                TaxTransactionvalue.Reset();
                                TaxTransactionvalue.SetRange("Value Type", TaxTransactionvalue."Value Type"::COMPONENT);
                                TaxTransactionvalue.SetRange("Visible on Interface", true);
                                TaxTransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxTransactionvalue.SetFilter(Percent, '<>%1', 0);
                                TaxTransactionvalue.SetRange("Tax Record ID", TaxRcordid);
                                TaxTransactionvalue.SetFilter("Value ID", '%1', 3);
                                if TaxTransactionvalue.FindSet() then
                                    IGSTRate := TaxTransactionvalue.Percent;
                                IGST := TaxTransactionvalue.Amount;
                                TotalIGST += IGST;
                            end;

                            Total += RecPurchaseLine.Amount;
                        //TotalIGST + TotalCGST + TotalSGST;
                        until RecPurchaseLine.Next() = 0;
                    Amouninvendor := Total + CGST + SGST + IGST;
                    //Naveen--
                    PostedVoucher.InitTextVariable();
                    "Purchase Header".CalcFields(Amount);
                    // PostedVoucher.FormatNoText(AmountinWords, Round("Purchase Header".Amount), "Purchase Header"."Currency Code");
                    PostedVoucher.FormatNoText(AmountinWords, Round(Amouninvendor), "Purchase Header"."Currency Code");
                    Amninwrds := AmountinWords[1] + AmountinWords[2];
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
        Compnayinfo.get();
    end;



    var
        myInt: Integer;
        vendor: Record Vendor;
        Encodestr: Text;
        Compnayinfo: Record "Company Information";
        Recpurchaseline: Record "Purchase Line";
        TaxTransactionvalue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        TaxRcordid: RecordId;
        Amountinwords: array[2] of Text;
        Amninwrds: Text;
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
        Amouninvendor: Decimal;

}