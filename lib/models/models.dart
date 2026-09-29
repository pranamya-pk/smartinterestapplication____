class Contact {
  final int? id;
  final String name;
  final String mobile;
  final String? email;
  final String type;

  Contact({
    this.id,
    required this.name,
    required this.mobile,
    this.email,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'email': email,
        'type': type,
      };

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
        id: map['id'],
        name: map['name'],
        mobile: map['mobile'],
        email: map['email'],
        type: map['type'],
      );
}

class LoanTransaction {
  final int? id;
  final int contactId;
  final double amount;
  final String type;
  final double rate;
  final String rateType;
  final DateTime startDate;
  final DateTime? dueDate;
  final String note;

  LoanTransaction({
    this.id,
    required this.contactId,
    required this.amount,
    required this.type,
    required this.rate,
    required this.rateType,
    required this.startDate,
    this.dueDate,
    required this.note,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'contact_id': contactId,
        'amount': amount,
        'type': type,
        'rate': rate,
        'rate_type': rateType,
        'start_date': startDate.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
        'note': note,
      };

  factory LoanTransaction.fromMap(Map<String, dynamic> map) => LoanTransaction(
        id: map['id'],
        contactId: map['contact_id'],
        amount: (map['amount'] as num).toDouble(),
        type: map['type'],
        rate: (map['rate'] as num).toDouble(),
        rateType: map['rate_type'],
        startDate: DateTime.parse(map['start_date']),
        dueDate: map['due_date'] == null ? null : DateTime.parse(map['due_date']),
        note: map['note'] ?? '',
      );
}

class Payment {
  final int? id;
  final int transactionId;
  final double amount;
  final DateTime date;
  final String mode;
  final String? proofPath;

  Payment({
    this.id,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.mode,
    this.proofPath,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'transaction_id': transactionId,
        'amount': amount,
        'payment_date': date.toIso8601String(),
        'mode': mode,
        'proof_path': proofPath,
      };

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
        id: map['id'],
        transactionId: map['transaction_id'],
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['payment_date']),
        mode: map['mode'],
        proofPath: map['proof_path'],
      );
}
