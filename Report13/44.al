report 50137 "Purchase inv "
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'rehann564t.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Posting_Date; "Posting Date") { }
            column(Nature_of_Supply; "Nature of Supply") { }
            column(Location_State_Code; "Location State Code") { }

            column(Gstno; Gstno) { }
            column(City; City) { }
            column(Pay_to_Contact; "Pay-to Contact") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(vendorgstno; vendor."GST Registration No.") { }
            column(companyinfoname; companyinfo.Name) { }
            column(companyinfoAddress; companyinfo.Address) { }
            column(companyinfogstno; companyinfo."GST Registration No.") { }
            column(companyinfostatecode; companyinfo."State Code") { }
            column(companyinfobankname; companyinfo."Bank Name") { }
            column(companyinfobankaccno; companyinfo."Bank Account No.") { }
            column(companyinfoifsccode; companyinfo."Bank Branch No.") { }
            column(companyinfoSwiftcode; companyinfo."SWIFT Code") { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(ToTalCGST; ToTalCGST) { }
                column(TotalSGST; TotalSGST) { }
                column(TotalIGST; TotalIGST) { }
                column(AmountTovendor; AmountTovendor) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    vendor.Reset();
                    vendor.SetRange("No.", "Buy-from Vendor No.");
                    if vendor.Find('-') then begin
                        Gstno := vendor."GST Registration No.";
                        City := vendor.City;
                    end;
                    Purchaseline.Reset();
                    Purchaseline.SetRange("Document No.", "Purchase Header"."No.");
                    Purchaseline.SetRange("Document Type", "Purchase Header"."Document Type");
                    Purchaseline.SetFilter("GST Group Code", '<>%1', '');
                    if Purchaseline.FindSet() then
                        repeat
                            TaxrecordId := Purchaseline.RecordId;

                            TaxtransactionValue.Reset();
                            TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                            TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                            TaxtransactionValue.SetRange("Visible on Interface", true);
                            TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxtransactionValue.SetRange("Tax Record ID", TaxrecordId);
                            if TaxtransactionValue.FindSet() then begin
                                CGSTRate := TaxtransactionValue.Percent;
                                SGSTRate := TaxtransactionValue.Percent;

                                CGST := TaxtransactionValue.Amount;
                                SGST := TaxtransactionValue.Amount;

                                ToTalCGST += CGST;
                                TotalSGST += SGST;
                            end else begin
                                TaxtransactionValue.Reset();
                                TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
                                TaxtransactionValue.SetFilter("Value ID", '%1', 3);
                                TaxtransactionValue.SetRange("Visible on Interface", true);
                                TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxtransactionValue.SetRange("Tax Record ID", TaxrecordId);
                                if TaxtransactionValue.FindSet() then
                                    IGSTRate := TaxtransactionValue.Percent;
                                IGST := TaxtransactionValue.Amount;

                                TotalIGST += IGST;
                            end;
                            Total := Purchaseline.Amount;
                        until Purchaseline.Next() = 0;
                    AmountTovendor := Total + ToTalCGST + TotalSGST + TotalIGST;

                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(AmountTovendor), "Purchase Header"."Currency Code");
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
        companyinfo.get();
    end;




    var
        myInt: Integer;
        Gstno: Code[20];
        City: Text[30];
        vendor: Record Vendor;
        Purchaseline: Record "Purchase Line";
        TaxtransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        companyinfo: Record "Company Information";
        AmountinWords: array[2] of Text;
        AmntinWrds: Text;
        TaxrecordId: RecordId;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        ToTalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TaxTotal: Decimal;
        Total: Decimal;
        AmountTovendor: Decimal;


}