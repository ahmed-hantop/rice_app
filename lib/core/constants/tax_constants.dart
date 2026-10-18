/// Tax configuration constants for carrier offers
/// Complies with Saudi Arabia VAT regulations (BR-CAR-10)
library;

/// Saudi Arabia VAT rate (15%)
const double kSaudiVatRate = 0.15;

/// Calculates tax amount to be deducted from offer
/// 
/// Formula: Tax Amount = Offer Amount × Tax Rate (BR-CAR-04)
/// 
/// Example: For 1000 SAR offer -> 1000 × 0.15 = 150 SAR tax
double calculateTaxAmount(double offerAmount) {
  if (offerAmount <= 0) return 0.0;
  return offerAmount * kSaudiVatRate;
}

/// Calculates net offer amount after tax deduction
/// 
/// Formula: Net Offer = Offer Amount - Tax Amount (BR-CAR-04)
/// 
/// Example: For 1000 SAR offer -> 1000 - 150 = 850 SAR net
double calculateNetOffer(double offerAmount) {
  if (offerAmount <= 0) return 0.0;
  final taxAmount = calculateTaxAmount(offerAmount);
  return offerAmount - taxAmount;
}

/// Gets tax rate as percentage string for display
String getTaxRatePercentage() {
  return '${(kSaudiVatRate * 100).toInt()}%';
}
