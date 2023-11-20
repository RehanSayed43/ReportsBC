report 50136 "Posted Sales Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'RehannSayed.rdl';
    Caption = 'Rehaaaaaaa';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(BillGstno; gstno) { }
            column(BillPhnono; phoneno) { }
            column(Posting_Date; "Posting Date") { }


            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Location_State_Codes; "Location State Code") { }
            column(Invoiceno; "Order No.") { }

            column(Amntinwrds; Amntinwrds) { }
            column(salesamount; salesamount) { }



            column(companyinfoname; companyinfo.Name) { }
            column(companyinfoaddress; companyinfo.Address) { }
            column(companyinfogst; companyinfo."GST Registration No.") { }
            column(companyinfocity; companyinfo.city) { }
            column(companyinfophoneno; companyinfo."Phone No.") { }
            column(companyinfoFSSAi; companyinfo."Giro No.") { }
            column(companyinfoCinno; companyinfo.IBAN) { }
            column(companyinfostatecodeS; companyinfo."State Code") { }

            column(companyinfoemail; companyinfo."E-Mail") { }

            // dataitem("Item Ledger Entry"; "Item Ledger Entry")
            // {
            //     DataItemLinkReference = "Sales Invoice Header";
            //     DataItemLink = "Document No." = FIELD("No.");
            //     column(Sales_Amount__Actual_; "Sales Amount (Actual)") { }


            // }





            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = FIELD("No.");

                column(Noo; "No.") { }
                column(Quantity; Quantity) { }
                column(Description; Description) { }
                column(Rate; "Unit Cost") { }
                column(Duedate; "Posting Date") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Amount; "Line Amount") { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(DepartmentCode; "Shortcut Dimension 1 Code") { }

                column(Per; "Unit of Measure Code") { }
                column(CGST; CGST) { }
                column(IGST; IGST) { }
                column(SGST; SGST) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalIGST; TotalIGST) { }
                column(TotalSGST; TotalSGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(Item_Category_Code; "Item Category Code") { }
                column(TaxTotal; TaxTotal) { }
                column(GrandTotal; GrandTotal) { }
                column(Total; Total) { }


            }

            // dataitem("Item Ledger Entry"; "Item Ledger Entry")
            // {
            //     DataItemLinkReference = "Sales Invoice Header";
            //     DataItemLink = "Entry No." = field("No."), "Document No."=field("No.");
            //     column(Sales_Amount__Actual_; "Sales Amount (Actual)") { }


            // }


            trigger OnAfterGetRecord()
            var
                myInt: Integer;

            begin

                customer.Reset();
                customer.SetRange("No.", "Sell-to Customer No.");
                if customer.Find('-') then begin
                    gstno := customer."GST Registration No.";
                    phoneno := customer."Phone No.";
                end;
                items.Reset();
                items.SetRange("Item No.", "No.");
                if items.Find('-') then begin
                    salesamount := items."Sales Amount (Actual)";
                end;


                ClearMyData();
                sales.Reset();
                sales.SetRange("Document No.", "Sales Invoice Header"."No.");
                //  sales.SetRange("Document No.","Sales Invoice Header".documne);
                sales.SetRange("Document No.", "Sales Invoice Header"."No.");
                sales.SetFilter("GST Group Code", '<>%1', '');
                if sales.FindSet() then
                    repeat
                        TaxTransactionValue.Reset();
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                        if TaxTransactionValue.FindSet() then
                            repeat
                                if ("Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Interstate)
                                then begin
                                    CGSTRate := TaxTransactionValue.Percent;
                                    SGSTRate := TaxTransactionValue.Percent;
                                    CGST := TaxTransactionValue.Amount;
                                    SGST := TaxTransactionValue.Amount;



                                end
                                else
                                    IF ("Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                                        IGSTRate := TaxTransactionValue.Percent;
                                        IGST := TaxTransactionValue.Amount;
                                    end;
                            until TaxTransactionValue.Next() = 0;
                        TotalCGST += CGST;
                        TotalSGST += SGST;
                        TotalIGST += IGST;
                        Total := Total + "Sales Invoice Line".Amount;
                        TaxTotal += TotalIGST + TotalCGST + TotalSGST;
                        GrandTotal := Total + TaxTotal;

                    //     Total := sales.Amount;
                    until sales.Next() = 0;
                // sales.SetRange(doc);
                // if sales.FindSet() then
                //     repeat
                //         Total += sales.Amount;
                //     until sales.Next() = 0;
                // AmountinVendors := Total;
                // PostedVoucher.InitTextVariable();
                // "Sales Invoice Header".CalcFields(Amount);
                // PostedVoucher.FormatNoText(AmountinWords, Round(AmountinVendors), "Sales Invoice Header"."Currency Code");
                // Amntinwrds := AmountinWords[1] + AmountinWords[2];


                ClearMyData();
                sales.Reset();
                sales.SetRange("Document No.", "Sales Invoice Header"."No.");
                if sales.FindSet() then
                    repeat
                        Total += sales.Amount;
                    until sales.Next() = 0;
                AmountinVendors := Total;
                PostedVoucher.InitTextVariable();
                "Sales Invoice Header".CalcFields(Amount);
                PostedVoucher.FormatNoText(AmountinWords, Round(AmountinVendors), "Sales Invoice Header"."Currency Code");
                Amntinwrds := AmountinWords[1] + AmountinWords[2];

            end;









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
        companyinfo.get()
    end;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        sales.get();
        // items.get();
    end;


    var
        myInt: Integer;
        customer: Record Customer;
        companyinfo: Record "Company Information";
        gstno: Code[20];
        salesamount: Decimal;
        phoneno: Text[30];
        sales: Record "Sales Invoice Line";
        items: Record "Item Ledger Entry";


        PostedVoucher: Report "Posted Voucher";
        AmountinVendors: Decimal;
        TextAmount: Text;
        NumberWords: Text;
        TaxTransactionValue: Record "Tax Transaction Value";

        Amount: Decimal;
        WholeAmount: Decimal;
        FractionalAmount: Decimal;
        Amntinwrds: Text;
        AmountinWords: array[2] of Text;
        CGST: Decimal;
        IGST: Decimal;
        SGST: Decimal;

        CGSTRate: Decimal;
        IGSTRate: Decimal;
        SGSTRate: Decimal;

        TotalIGST: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;

        IGSTtxt: Text[10];
        SGSTtxt: Text[10];
        CGSTtxt: Text[10];
        Total: Decimal;
        GrandTotal: Decimal;
        TaxTotal: Decimal;


        RecState: Record State;
        CmpStateName: Text;
        BankAcc: Record "Bank Account";
        BankBrach: Text;
        SWIFTCode: Code[20];
        NoLbl: Label 'SR No.';
        DesLbl: Label 'Product Description';
        HSNLbl: Label 'HSN Code';
        DueLbl: Label 'Due On';
        qtyLbl: Label 'Qty';
        RateLbl: Label 'Rate';
        AmtLbl: Label 'Amount';
        DisLbl: Label 'Discount';
        TaxValLbl: Label 'Taxable Value';
        TotLbl: Label 'Total';

        Notext: array[2] of Text;


    local procedure ClearMyData()
    begin
        IGSTRate := 0;
        CGSTRate := 0;
        SGSTRate := 0;

        TotalCGST := 0;
        TotalIGST := 0;
        TotalSGST := 0;

        IGST := 0;
        CGST := 0;
        SGST := 0;

    end;





}