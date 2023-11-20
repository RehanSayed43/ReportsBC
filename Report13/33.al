report 50142 "Salesss"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './rehnnn99999yyy.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Location_State_Code; "Location State Code") { }
            column(Posting_Date; "Posting Date") { }


            column(Companyinfoname; Companyinfo.Name) { }
            column(Companyinfoaddress; Companyinfo.Address) { }
            column(Companyinfogstno; Companyinfo."GST Registration No.") { }
            column(Companyinfostatecode; Companyinfo."State Code") { }
            column(CompanyinfoCity; Companyinfo.City) { }


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(CGST; CGST) { }
                column(SGST; SGST) { }
                column(IGST; IGST) { }
                column(CGSTRTE; CGSTRTE) { }
                column(SGSTRTE; SGSTRTE) { }
                column(IGSTRTE; IGSTRTE) { }
                column(Total; Total) { }
                column(GrandTotal; GrandTotal) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.Find('-') then begin
                        gstno := customer."GST Registration No.";
                    end;

                    Salesline.Reset();
                    Salesline.SetRange("Document Type", "Sales Header"."Document Type");
                    Salesline.SetRange("Document No.", "Sales Header"."No.");
                    Salesline.SetFilter("GST Group Code", '<>%1', '');
                    if Salesline.FindSet() then
                        repeat
                            TaxRecordid := Salesline.RecordId;

                            Taxtransactionvalue.Reset();
                            Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordid);
                            Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
                            Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
                            Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
                            Taxtransactionvalue.SetRange("Visible on Interface", true);
                            if Taxtransactionvalue.FindSet() then begin
                                CGST := Taxtransactionvalue.Amount;
                                SGST := Taxtransactionvalue.Amount;
                                CGSTRTE := Taxtransactionvalue.Percent;
                                SGSTRTE := Taxtransactionvalue.Percent;

                                TOTALCGST += CGST;
                                TOTALSGST += SGST;

                            end else begin
                                Taxtransactionvalue.Reset();
                                Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordid);
                                Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
                                Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
                                Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
                                Taxtransactionvalue.SetRange("Visible on Interface", true);
                                Taxtransactionvalue.SetFilter("Value ID", '%1|%2', 6, 3);
                                IF Taxtransactionvalue.FindSet() then
                                    IGST := Taxtransactionvalue.Amount;
                                IGSTRTE := Taxtransactionvalue.Percent;
                                TOTALIGST += IGST;
                            end;
                            Total := Total + Salesline.Amount;
                            GrandTotal := Total + TOTALCGST + TOTALSGST + TOTALIGST;
                        until Salesline.Next() = 0;
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
                    Amntinwrds := AmountinWords[1] + AmountinWords[2];


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
        gstno: Code[20];
        StatesS: Text[30];
        customer: Record Customer;
        Companyinfo: Record "Company Information";
        Taxtransactionvalue: Record "Tax Transaction Value";
        TaxRecordid: RecordId;
        Salesline: Record "Sales Line";
        PostedVoucher: Report "Posted Voucher";
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRTE: Decimal;
        SGSTRTE: Decimal;
        IGSTRTE: Decimal;
        TOTALCGST: Decimal;
        TOTALSGST: Decimal;
        TOTALIGST: Decimal;
        AmountinWords: array[2] of text;
        Amntinwrds: Text;
        Taxtotal: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;


}