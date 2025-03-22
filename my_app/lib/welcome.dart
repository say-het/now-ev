import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Wallet", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletCard(),
            const SizedBox(height: 20),
            _buildAddMoneyButton(context),
            const SizedBox(height: 30),
            const Text(
              "Transaction History",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildTransactionList()),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Wallet Balance",
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "₹ 5,000.00",
            style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoneyButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildAddMoneyDialog(context),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
        child: const Text(
          "Add Money",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    List<Map<String, String>> transactions = [
      {"title": "Bike Subscription", "amount": "- ₹799", "date": "March 20, 2025"},
      {"title": "Added Money", "amount": "+ ₹1,000", "date": "March 18, 2025"},
      {"title": "Scooter Rent", "amount": "- ₹299", "date": "March 15, 2025"},
    ];

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(transactions[index]["title"]!, style: const TextStyle(color: Colors.white)),
          subtitle: Text(transactions[index]["date"]!, style: TextStyle(color: Colors.grey[400])),
          trailing: Text(
            transactions[index]["amount"]!,
            style: TextStyle(
              color: transactions[index]["amount"]!.contains("+") ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddMoneyDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text("Add Money", style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter Amount",
          hintStyle: TextStyle(color: Colors.grey[500]),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle money adding logic here
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Add", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}