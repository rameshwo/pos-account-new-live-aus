enum TaxType { Inclusive, Exclusive, NoTax }

class AmountClass {
  /// static tax percentage
  double taxPercent;

  /// total product's tax amount with charges and discount of selected items
  double totalTax;

  /// total product's price only of selected items based on tax type either inc or excl
  double itemPrice;

// total product's price of selected items only
  // double itemPriceWithOutTax;

  /// total product's price with tax, charges and discount of selected items
  double totalPrice;

  /// just tax type
  TaxType taxType;

  /// discount amount of selected item's total based on tax type  either inc or excl
  double discount;

  ///[pHSurCharge] public holiday surcharge of selected items based on tax type  either inc or excl
  double pHSurCharge;

  /// credit card surcharge of selected items based on tax type  either inc or excl
  double ccSurCharge;

  /// serviceCharge of selected items based on tax type  either inc or excl
  double serviceCharge;

  /// public holiday surcharge of selected items without tax
  // double pHSurChargeWOutT;

  /// credit card surcharge of selected items without tax
  // double ccSurChargeWOutT;

  /// discount amount of selected items without tax
  // double discountWithoutTax;

  /// discount amount of selected items with tax
  double discountWithTax;

  /// total product's price with tax, charges and discount even it's diselected
  double finalPrice;

  /// total tax of product's price, charges and discount even it's diselected
  // double finalPriceTax;

  /// paid amount includes item's price with tax and discount with tax only
  double paidAmount;

  /// total product's price with tax only (not include discount and charges) for update items however item selected or not
  double finalItemPriceWithTax;

  /// item's tax only for update order from payment screen
  double finalItemTax;

  // total product's price of all selected or not selected items
  double finalItemPriceWithOutTax;

  // tax from items to delivery and discount so that we can add tax from surcharges on multiple payments
  double taxFromItemToDel;

  AmountClass({
    this.taxPercent = 0.0,
    this.totalTax = 0.0,
    this.itemPrice = 0.0,
    // this.itemPriceWithOutTax = 0.0,
    this.totalPrice = 0.0,
    this.taxType = TaxType.NoTax,
    this.discount = 0.0,
    this.pHSurCharge = 0.0,
    this.ccSurCharge = 0.0,
    this.serviceCharge = 0.0,
    // this.pHSurChargeWOutT = 0.0,
    // this.ccSurChargeWOutT = 0.0,
    // this.discountWithoutTax = 0.0,
    this.discountWithTax = 0.0,
    this.finalPrice = 0.0,
    // this.finalPriceTax = 0.0,
    this.paidAmount = 0.0,
    this.finalItemPriceWithTax = 0.0,
    this.finalItemTax = 0.0,
    this.finalItemPriceWithOutTax = 0.0,
    this.taxFromItemToDel = 0.0,
  });
}
