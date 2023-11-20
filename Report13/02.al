report 50118 "Sales Order Customer"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'RS';
    RDLCLayout = './rsayed.rdl';
    //PERFECT REPORT

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(No_; "No.")
            {

            }
            column(Bill_to_Name; "Bill-to Name")
            {

            }
            column(Bill_to_Address; "Bill-to Address")
            {

            }
            column(gst_no; gst_no)
            {

            }

            column(customergst; customer."GST Registration No.")
            {

            }
            column(Statess; Statess) { }
            column(Location_State_Code; "Location State Code") { }
            column(Nature_of_Supply; "Nature of Supply") { }
            column(Posting_Date; "Posting Date") { }
            column(Amtinwrds; Amtinwrds) { }


            column(companyname; company.Name) { }
            column(companyaddress; company.Address) { }
            column(companygstno; company."GST Registration No.") { }
            column(companypano; company."P.A.N. No.") { }
            column(companystatecode; company."State Code") { }


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(Srno; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Rate; "Unit Cost (LCY)") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Amount; "Line Amount") { }




            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                customer.Reset();
                customer.SetRange("No.", "Sell-to Customer No.");
                if customer.Find('-') then begin
                    gst_no := customer."GST Registration No.";
                    Statess := customer.County;



                    ClearData;
                    sales.Reset();
                    sales.SetRange("Document No.", "Sales Header"."No.");
                    if sales.FindSet() then
                        repeat
                            Total += sales.Amount;
                        until sales.Next() = 0;
                    AmountToVendor := Total;
                    PostedVoucher.InitTextVariable();
                    "Sales Header".CalcFields(Amount);
                    PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Sales Header"."Currency Code");
                    Amtinwrds := AmountinWords[1] + AmountinWords[2];

                end;
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
        company.get();

    end;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        sales.get();
    end;



    var
        myInt: Integer;
        company: Record "Company Information";
        customer: Record Customer;
        sales: Record "Sales Line";
        gst_no: Code[20];
        Statess: Code[10];
        PostedVoucher: Report "Posted Voucher";
        AmountToVendor: Decimal;
        TextAmount: Text;
        NumberWords: Text;
        Amount: Decimal;
        WholeAmount: Decimal;
        FractionAmount: Decimal;
        Amtinwrds: Text;
        AmountinWords: array[2] of Text;
        CGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalIGST: Decimal;
        TotalSGST: Decimal;
        IGSTtxt: text[10];
        CGSTtxt: text[10];
        IGSTRate: Decimal;
        SGST: Decimal;
        Total: Decimal;

    local procedure ClearData()
    Begin
        IGSTRate := 0;
        SGSTRate := 0;
        CGSTRate := 0;

        // TotalCGST := 0;
        // TotalSGST := 0;
        // TotalIGST := 0;

        IGST := 0;
        CGST := 0;
        SGST := 0;
        Clear(AmountinWords);

    End;

}