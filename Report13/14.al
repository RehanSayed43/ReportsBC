report 50128 "Sales Orders"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Araaaaaa';
    RDLCLayout = './sraaaaaa.rdl';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Gstnoo; Gstnoo) { }
            column(PhoneNo; PhoneNo) { }
            column(Email; Email) { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Location_State_Code; "Location State Code") { }
            column(SOCODE; "Sell-to Customer No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Panno; Panno) { }

            column(Amntinwrds; Amntinwrds) { }






            column(companyName; company.Name) { }
            column(companyAddress; company.Address) { }
            column(companyGstno; company."GST Registration No.") { }
            column(companyPanno; company."P.A.N. No.") { }
            column(companyState; company.City) { }
            column(company; company."State Code") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");

                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Cost") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Line_Amount; "Line Amount") { }
                // column(HSN_SAC_Code;"HSN/SAC Code"){}
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTRate; IGSTRate) { }
                column(ToatlSGST; ToatlSGST) { }
                column(TotalCGST; TotalCGST) { }
                column(TotalIGST; TotalIGST) { }
                column(TaxTotal; TaxTotal) { }
                column(Total; Total) { }
                column(GrandTotal; GrandTotal) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        Gstnoo := customer."GST Registration No.";
                        PhoneNo := customer."Phone No.";
                        Email := customer."E-Mail";
                        Panno := customer."P.A.N. No.";
                    end;

                    if "Sales Header"."Currency Code" <> '' then begin
                        Currency := "Sales Header"."Currency Code";
                    end else begin
                        Currency := 'INR';
                    end;


                    Sales.Reset();
                    Sales.SetRange("Document Type", "Sales Header"."Document Type");
                    Sales.SetRange("Document No.", "Sales Header"."No.");
                    Sales.SetFilter("GST Group Code", '<>%1', '');
                    if Sales.FindSet() then
                        repeat
                            TaxRecordId := Sales.RecordId;


                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
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
                                ToatlSGST += SGST;



                            end else begin
                                TaxTransactionValue.Reset();
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
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
                            Total := Total + "Sales Line".Amount;
                            TaxTotal += TotalCGST + ToatlSGST + TotalIGST;
                            GrandTotal := TaxTotal + Total;
                        until sales.Next() = 0;

                    if "Sales Header"."Currency Code" <> '' then begin
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.FormatNoText(AmountInWords, Round(GrandTotal), "Sales Header"."Currency Code");
                        Amntinwrds := AmountInWords[1] + AmountInWords[2];
                    end else begin
                        PostedVoucher.InitTextVariable();
                        PostedVoucher.FormatNoText(AmountInWords, Round(GrandTotal), '');
                        Amntinwrds := AmountInWords[1] + AmountInWords[2];
                    end;


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
        company.get();
    end;



    var
        Gstnoo: Code[20];
        PhoneNo: Text[30];
        Email: Text[80];
        Panno: Code[20];
        myInt: Integer;
        customer: Record Customer;
        company: Record "Company Information";
        TaxTransactionValue: Record "Tax Transaction Value";
        PostedVoucher: Report "Posted Voucher";
        Sales: Record "Sales Line";
        AmountInWords: array[2] of Text;
        Amntinwrds: Text;
        TaxRecordId: RecordId;
        Amount: Decimal;
        WholeAmount: Decimal;
        FracTionalamount: Decimal;
        Currency: Code[20];
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalCGST: Decimal;
        ToatlSGST: Decimal;
        TotalIGST: Decimal;
        TaxTotal: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;



    local procedure ClearAll()
    var
        myInt: Integer;
    begin
        CGST := 0;
        IGST := 0;
        SGST := 0;

        CGSTRate := 0;
        SGSTRate := 0;
        IGSTRate := 0;

        TotalCGST := 0;
        ToatlSGST := 0;
        TotalIGST := 0;
    end;

}