import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../domain/entities/account.dart';
import '../../domain/value_objects/account_type.dart';
import '../models/account_model.dart';

abstract class AccountLocalDataSource {
  Future<void> create(Account account);
  Future<void> edit(Account account);
  Future<void> delete(int id);
  Future<AccountModel> load(int id);
  Future<List<Account>> loadAll();
  Future<List<Account>> loadAccountsWithFilter(List<String> accountNameFilter);
  Future<void> deposit(Booking booking);
  Future<void> withdraw(Booking booking);
  Future<void> transfer(Booking booking);
  Future<bool> checkAccountName(String accountName);
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  AccountLocalDataSourceImpl();

  @override
  Future<void> create(Account account) async {
    db = await openDatabase(localDbName);
    await db.rawInsert('INSERT INTO $accountDbName(type, name, amount, currency) VALUES(?, ?, ?, ?)', [
      account.type.name,
      account.name,
      account.amount,
      account.currency,
    ]);
  }

  @override
  Future<void> delete(int id) async {
    db = await openDatabase(localDbName);
    await db.rawDelete('DELETE FROM $accountDbName WHERE id = ?', [id]);
  }

  @override
  Future<AccountModel> load(int id) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<void> edit(Account account) async {
    db = await openDatabase(localDbName);
    try {
      await db.rawUpdate('UPDATE $accountDbName SET id = ?, type = ?, name = ?, amount = ?, currency = ? WHERE id = ?', [
        account.id,
        account.type.name,
        account.name,
        account.amount,
        account.currency,
        account.id,
      ]);
    } catch (e) {
      // TODO Fehler richtig behandeln
      print('Error: $e');
    }
  }

  @override
  Future<List<Account>> loadAll() async {
    db = await openDatabase(localDbName);
    List<Map> accountMap = await db.rawQuery('SELECT * FROM $accountDbName');
    List<Account> accountList = accountMap
        .map(
          (account) => Account(
            id: account['id'],
            type: AccountType.fromString(account['type']),
            name: account['name'],
            amount: account['amount'],
            currency: account['currency'],
          ),
        )
        .toList();
    accountList.sort((first, second) {
      int typeComparison = first.type.name.compareTo(second.type.name);
      if (typeComparison != 0) {
        return typeComparison;
      }
      return second.amount.compareTo(first.amount);
    });
    return accountList;
  }

  @override
  Future<List<Account>> loadAccountsWithFilter(List<String> accountNameFilter) async {
    db = await openDatabase(localDbName);
    List<Map> accountMap = await db.rawQuery('SELECT * FROM $accountDbName');
    List<Account> accountList = accountMap
        .map(
          (account) => Account(
            id: account['id'],
            type: AccountType.fromString(account['type']),
            name: account['name'],
            amount: account['amount'],
            currency: account['currency'],
          ),
        )
        .where((account) => !accountNameFilter.contains(account.name))
        .toList();
    accountList.sort((first, second) => second.type.name.compareTo(first.type.name));
    return accountList;
  }

  @override
  Future<void> deposit(Booking booking) async {
    db = await openDatabase(localDbName);
    await db.transaction((ta) async {
      List<Map> accountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.fromAccount]);
      if (accountBalance.isNotEmpty) {
        final currentAmount = accountBalance[0]['amount'];
        final newAmount = currentAmount + booking.amount;
        await ta.rawUpdate(
          'UPDATE $accountDbName SET amount = ? WHERE name = ?',
          [newAmount, booking.fromAccount],
        );
      }
    });
  }

  @override
  Future<void> withdraw(Booking booking) async {
    db = await openDatabase(localDbName);
    await db.transaction((ta) async {
      List<Map> accountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.fromAccount]);
      if (accountBalance.isNotEmpty) {
        final currentAmount = accountBalance[0]['amount'];
        final newAmount = currentAmount - booking.amount;
        await ta.rawUpdate(
          'UPDATE $accountDbName SET amount = ? WHERE name = ?',
          [newAmount, booking.fromAccount],
        );
      }
    });
  }

  @override
  Future<void> transfer(Booking booking) async {
    db = await openDatabase(localDbName);
    await db.transaction((ta) async {
      List<Map> fromAccountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.fromAccount]);
      List<Map> toAccountBalance = await ta.rawQuery('SELECT amount FROM $accountDbName WHERE name = ?', [booking.toAccount]);
      if (fromAccountBalance.isNotEmpty && toAccountBalance.isNotEmpty) {
        final fromCurrentAmount = fromAccountBalance[0]['amount'];
        final toCurrentAmount = toAccountBalance[0]['amount'];

        final newFromAmount = fromCurrentAmount - booking.amount;
        final newToAmount = toCurrentAmount + booking.amount;

        await ta.rawUpdate(
          'UPDATE $accountDbName SET amount = ? WHERE name = ?',
          [newFromAmount, booking.fromAccount],
        );
        await ta.rawUpdate(
          'UPDATE $accountDbName SET amount = ? WHERE name = ?',
          [newToAmount, booking.toAccount],
        );
      }
    });
  }

  @override
  Future<bool> checkAccountName(String accountName) async {
    db = await openDatabase(localDbName);
    List<Map> account = await db.rawQuery('SELECT * FROM $accountDbName WHERE LOWER(name) = ? LIMIT 1', [accountName.toLowerCase()]);
    if (account.isEmpty) {
      return false;
    }
    return true;
  }
}
