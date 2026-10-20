/// What the user has done with the invoice. Paid, partially paid and
/// overdue are not stored; they are worked out from payments and dates
/// (see `InvoiceStatusResolver`).
enum InvoiceStage { draft, sent }
